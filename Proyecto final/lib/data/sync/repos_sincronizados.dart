import 'dart:async';

import '../../models/course.dart';
import '../../models/task.dart';
import '../course_repository.dart';
import '../task_repository.dart';
import 'modelos_remotos.dart';
import 'remoto_sync.dart';

/// Envuelve un repositorio local y copia cada cambio a la nube.
///
/// La escritura remota nunca bloquea la pantalla: Firestore la encola y la
/// envía cuando hay conexión. Si falla, la app sigue con los datos locales
/// (el siguiente inicio de sesión vuelve a subir lo que falte).
class CursoRepoSincronizado implements CourseRepository {
  CursoRepoSincronizado({
    required this.local,
    required this.remoto,
    required this.usuarioId,
  });

  final CourseRepository local;
  final RemotoSync remoto;
  final String usuarioId;

  @override
  Stream<List<Course>> watchCursos() => local.watchCursos();

  @override
  Future<void> crear(Course curso) async {
    await local.crear(curso);
    _subir(curso);
  }

  @override
  Future<void> actualizar(Course curso) async {
    await local.actualizar(curso);
    _subir(curso);
  }

  @override
  Future<void> eliminar(String id) async {
    await local.eliminar(id);
    unawaited(remoto.eliminarCurso(usuarioId, id).catchError((_) {}));
  }

  void _subir(Course curso) {
    final ahora = DateTime.now();
    unawaited(
      remoto
          .guardarCurso(
            usuarioId,
            CursoRemoto(curso: curso, actualizadaEn: ahora, creadaEn: ahora),
          )
          .catchError((_) {}),
    );
  }
}

/// Igual que [CursoRepoSincronizado], para las tareas.
class TareaRepoSincronizado implements TaskRepository {
  TareaRepoSincronizado({
    required this.local,
    required this.remoto,
    required this.usuarioId,
  });

  final TaskRepository local;
  final RemotoSync remoto;
  final String usuarioId;

  @override
  Stream<List<Task>> watchTareas({String? cursoId}) =>
      local.watchTareas(cursoId: cursoId);

  @override
  Future<Task?> obtenerTarea(String id) => local.obtenerTarea(id);

  @override
  Future<void> crear(Task tarea) async {
    await local.crear(tarea);
    _subir(tarea);
  }

  @override
  Future<void> actualizar(Task tarea) async {
    await local.actualizar(tarea);
    _subir(tarea);
  }

  @override
  Future<void> eliminar(String id) async {
    await local.eliminar(id);
    unawaited(remoto.eliminarTarea(usuarioId, id).catchError((_) {}));
  }

  void _subir(Task tarea) {
    final ahora = DateTime.now();
    unawaited(
      remoto
          .guardarTarea(
            usuarioId,
            TareaRemota(tarea: tarea, actualizadaEn: ahora, creadaEn: ahora),
          )
          .catchError((_) {}),
    );
  }
}
