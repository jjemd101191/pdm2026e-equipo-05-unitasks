import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/course_repository.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/task_repository.dart';
import 'package:pdm2026e_equipo_05_unitasks/main.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/course.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/task.dart';
import 'package:pdm2026e_equipo_05_unitasks/providers/providers.dart';

/// Curso de prueba con valores predecibles.
Course cursoPrueba({
  String id = 'curso-a',
  String nombre = 'Curso A',
  String docente = 'Docente A',
  Color color = Colors.indigo,
  String periodo = '2026-2',
}) => Course(
  id: id,
  nombre: nombre,
  docente: docente,
  color: color,
  dias: const ['Lun'],
  horaInicio: '8:00',
  horaFin: '10:00',
  periodo: periodo,
);

/// Tarea de prueba; por defecto con entrega mañana para que no esté vencida.
Task tareaPrueba({
  String id = 'tarea-a',
  String titulo = 'Tarea de prueba',
  String cursoId = 'curso-a',
  Prioridad prioridad = Prioridad.media,
  TipoTarea tipo = TipoTarea.tarea,
  EstadoTarea estado = EstadoTarea.pendiente,
  DateTime? fechaEntrega,
  int? recordatorioMinutos,
  List<Subtask> subtareas = const <Subtask>[],
}) => Task(
  id: id,
  titulo: titulo,
  cursoId: cursoId,
  prioridad: prioridad,
  tipo: tipo,
  estado: estado,
  fechaEntrega: fechaEntrega ?? DateTime.now().add(const Duration(days: 1)),
  recordatorioMinutos: recordatorioMinutos,
  subtareas: subtareas,
);

/// La app completa con repositorios en memoria en lugar de la base.
Widget appDePrueba({
  required CourseRepository cursos,
  required TaskRepository tareas,
}) {
  return ProviderScope(
    overrides: [
      courseRepositoryProvider.overrideWithValue(cursos),
      taskRepositoryProvider.overrideWithValue(tareas),
    ],
    child: const TaskUApp(),
  );
}

/// Emite el valor actual al suscribirse y de nuevo con cada [avisar], igual
/// que los streams de Drift.
class _Observable {
  final _cambios = StreamController<void>.broadcast();

  void avisar() => _cambios.add(null);

  Stream<T> observar<T>(T Function() leer) async* {
    yield leer();
    yield* _cambios.stream.map((_) => leer());
  }
}

/// Repositorio de cursos en memoria para pruebas de interfaz.
class CursoRepoMemoria implements CourseRepository {
  CursoRepoMemoria([List<Course>? cursos])
    : cursos = List<Course>.of(cursos ?? const <Course>[]);

  final List<Course> cursos;
  final _observable = _Observable();

  /// Se conecta al repositorio de tareas para replicar la regla de negocio:
  /// no se elimina un curso que todavía tiene tareas.
  TareaRepoMemoria? tareas;

  bool fallaAlCargar = false;
  bool fallaAlEliminar = false;
  int llamadas = 0;

  @override
  Stream<List<Course>> watchCursos() {
    llamadas++;
    if (fallaAlCargar) return Stream.error(Exception('sin conexión'));
    return _observable.observar(() => List<Course>.unmodifiable(cursos));
  }

  @override
  Future<void> crear(Course curso) async {
    if (cursos.any((actual) => actual.id == curso.id)) {
      throw StateError('curso duplicado');
    }
    cursos.add(curso);
    _observable.avisar();
  }

  @override
  Future<void> actualizar(Course curso) async {
    final indice = cursos.indexWhere((actual) => actual.id == curso.id);
    if (indice < 0) throw StateError('curso inexistente');
    cursos[indice] = curso;
    _observable.avisar();
  }

  @override
  Future<void> eliminar(String id) async {
    if (fallaAlEliminar) throw StateError('fallo de almacenamiento');
    final asociadas =
        tareas?.tareas.where((tarea) => tarea.cursoId == id).length ?? 0;
    if (asociadas > 0) throw CursoConTareasException(asociadas);
    final indice = cursos.indexWhere((curso) => curso.id == id);
    if (indice < 0) throw StateError('curso inexistente');
    cursos.removeAt(indice);
    _observable.avisar();
  }
}

/// Repositorio de tareas en memoria (el `FakeTaskRepository` del contrato).
class TareaRepoMemoria implements TaskRepository {
  TareaRepoMemoria([List<Task>? tareas])
    : tareas = List<Task>.of(tareas ?? const <Task>[]);

  final List<Task> tareas;
  final _observable = _Observable();
  bool fallaAlCargar = false;
  bool fallaAlGuardar = false;

  @override
  Stream<List<Task>> watchTareas({String? cursoId}) {
    if (fallaAlCargar) return Stream.error(Exception('sin conexión'));
    return _observable.observar(
      () => List<Task>.unmodifiable(
        tareas.where((tarea) => cursoId == null || tarea.cursoId == cursoId),
      ),
    );
  }

  @override
  Future<Task?> obtenerTarea(String id) async {
    for (final tarea in tareas) {
      if (tarea.id == id) return tarea;
    }
    return null;
  }

  @override
  Future<void> crear(Task tarea) async {
    if (fallaAlGuardar) throw StateError('fallo de almacenamiento');
    tareas.add(tarea);
    _observable.avisar();
  }

  @override
  Future<void> actualizar(Task tarea) async {
    if (fallaAlGuardar) throw StateError('fallo de almacenamiento');
    final indice = tareas.indexWhere((actual) => actual.id == tarea.id);
    if (indice < 0) throw TareaNoEncontradaException(tarea.id);
    tareas[indice] = tarea;
    _observable.avisar();
  }

  @override
  Future<void> eliminar(String id) async {
    tareas.removeWhere((tarea) => tarea.id == id);
    _observable.avisar();
  }
}
