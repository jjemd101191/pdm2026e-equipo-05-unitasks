import 'dart:async';

import 'package:pdm2026e_equipo_05_unitasks/data/sync/modelos_remotos.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/sync/remoto_sync.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/sync/sincronizador.dart';

/// Nube falsa para probar la sincronización sin Firebase.
///
/// Guarda una colección por usuario y avisa a los escuchas después de cada
/// escritura. Con [sinConexion] las escrituras fallan, como Firestore cuando
/// no hay red.
class RemotoSyncMemoria implements RemotoSync {
  final Map<String, Map<String, CursoRemoto>> _cursos = {};
  final Map<String, Map<String, TareaRemota>> _tareas = {};
  final Map<String, StreamController<List<CursoRemoto>>> _controladoresCursos =
      {};
  final Map<String, StreamController<List<TareaRemota>>> _controladoresTareas =
      {};

  bool sinConexion = false;
  int escrituras = 0;
  int borrados = 0;

  Map<String, CursoRemoto> cursos(String usuarioId) =>
      _cursos.putIfAbsent(usuarioId, () => {});

  Map<String, TareaRemota> tareas(String usuarioId) =>
      _tareas.putIfAbsent(usuarioId, () => {});

  @override
  Stream<List<CursoRemoto>> observarCursos(String usuarioId) async* {
    yield cursos(usuarioId).values.toList();
    yield* _controladorCursos(usuarioId).stream;
  }

  @override
  Stream<List<TareaRemota>> observarTareas(String usuarioId) async* {
    yield tareas(usuarioId).values.toList();
    yield* _controladorTareas(usuarioId).stream;
  }

  @override
  Future<void> guardarCurso(String usuarioId, CursoRemoto curso) async {
    _verificarConexion();
    cursos(usuarioId)[curso.curso.id] = curso;
    escrituras++;
    _controladorCursos(usuarioId).add(cursos(usuarioId).values.toList());
  }

  @override
  Future<void> eliminarCurso(String usuarioId, String cursoId) async {
    _verificarConexion();
    cursos(usuarioId).remove(cursoId);
    borrados++;
    _controladorCursos(usuarioId).add(cursos(usuarioId).values.toList());
  }

  @override
  Future<void> guardarTarea(String usuarioId, TareaRemota tarea) async {
    _verificarConexion();
    tareas(usuarioId)[tarea.tarea.id] = tarea;
    escrituras++;
    _controladorTareas(usuarioId).add(tareas(usuarioId).values.toList());
  }

  @override
  Future<void> eliminarTarea(String usuarioId, String tareaId) async {
    _verificarConexion();
    tareas(usuarioId).remove(tareaId);
    borrados++;
    _controladorTareas(usuarioId).add(tareas(usuarioId).values.toList());
  }

  void _verificarConexion() {
    if (sinConexion) throw StateError('Sin conexión');
  }

  StreamController<List<CursoRemoto>> _controladorCursos(String usuarioId) =>
      _controladoresCursos.putIfAbsent(
        usuarioId,
        () => StreamController<List<CursoRemoto>>.broadcast(),
      );

  StreamController<List<TareaRemota>> _controladorTareas(String usuarioId) =>
      _controladoresTareas.putIfAbsent(
        usuarioId,
        () => StreamController<List<TareaRemota>>.broadcast(),
      );

  Future<void> cerrar() async {
    for (final controlador in _controladoresCursos.values) {
      await controlador.close();
    }
    for (final controlador in _controladoresTareas.values) {
      await controlador.close();
    }
  }
}

/// Sincronizador que no hace nada. Las pruebas de UI del login solo
/// comprueban qué pantalla se monta, no la sincronización (que tiene sus
/// propias pruebas en `test/data/sincronizacion_test.dart`). Así no quedan
/// temporizadores ni escrituras a medias cuando la prueba termina.
class SincronizadorInactivo extends Sincronizador {
  SincronizadorInactivo({
    required super.db,
    required super.remoto,
    required super.usuarioId,
  });

  @override
  Future<void> iniciar() async {}

  @override
  Future<void> sincronizarAhora() async {}

  @override
  Future<void> detener() async {}
}
