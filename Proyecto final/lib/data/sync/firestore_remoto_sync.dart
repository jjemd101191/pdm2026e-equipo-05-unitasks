import 'package:cloud_firestore/cloud_firestore.dart';

import 'modelos_remotos.dart';
import 'remoto_sync.dart';

/// [RemotoSync] real: Firestore con una subcolección por usuario.
///
/// Las reglas del proyecto (`firestore.rules`) solo permiten leer y escribir
/// dentro de `users/{uid}` cuando el uid del token coincide.
class FirestoreRemotoSync implements RemotoSync {
  FirestoreRemotoSync({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _cursos(String usuarioId) =>
      _firestore.collection('users').doc(usuarioId).collection('courses');

  CollectionReference<Map<String, dynamic>> _tareas(String usuarioId) =>
      _firestore.collection('users').doc(usuarioId).collection('tasks');

  @override
  Stream<List<CursoRemoto>> observarCursos(String usuarioId) =>
      _cursos(usuarioId).snapshots().map(
        (snapshot) => [
          for (final documento in snapshot.docs)
            CursoRemoto.desdeMapa(documento.id, documento.data()),
        ],
      );

  @override
  Stream<List<TareaRemota>> observarTareas(String usuarioId) =>
      _tareas(usuarioId).snapshots().map(
        (snapshot) => [
          for (final documento in snapshot.docs)
            TareaRemota.desdeMapa(documento.id, documento.data()),
        ],
      );

  @override
  Future<void> guardarCurso(String usuarioId, CursoRemoto curso) =>
      _cursos(usuarioId).doc(curso.curso.id).set(curso.aMapa());

  @override
  Future<void> eliminarCurso(String usuarioId, String cursoId) =>
      _cursos(usuarioId).doc(cursoId).delete();

  @override
  Future<void> guardarTarea(String usuarioId, TareaRemota tarea) =>
      _tareas(usuarioId).doc(tarea.tarea.id).set(tarea.aMapa());

  @override
  Future<void> eliminarTarea(String usuarioId, String tareaId) =>
      _tareas(usuarioId).doc(tareaId).delete();
}
