import 'package:flutter/material.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/course_repository.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/task_repository.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/course.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/task.dart';

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
  Course? curso,
  Prioridad prioridad = Prioridad.media,
  TipoTarea tipo = TipoTarea.tarea,
  EstadoTarea estado = EstadoTarea.pendiente,
  DateTime? fechaEntrega,
  RecordatorioOpcion recordatorio = RecordatorioOpcion.sinRecordatorio,
  List<Subtask> subtareas = const <Subtask>[],
}) => Task(
  id: id,
  titulo: titulo,
  curso: curso ?? cursoPrueba(),
  prioridad: prioridad,
  tipo: tipo,
  estado: estado,
  fechaEntrega: fechaEntrega ?? DateTime.now().add(const Duration(days: 1)),
  recordatorio: recordatorio,
  subtareas: subtareas,
);

/// Repositorio de cursos en memoria para pruebas de interfaz.
class CursoRepoMemoria implements CourseRepository {
  CursoRepoMemoria([List<Course>? cursos])
    : cursos = List<Course>.of(cursos ?? const <Course>[]);

  final List<Course> cursos;

  /// Se conecta al repositorio de tareas para replicar la regla de negocio:
  /// no se elimina un curso que todavía tiene tareas.
  TareaRepoMemoria? tareas;

  bool fallaAlCargar = false;
  bool fallaAlEliminar = false;
  int llamadas = 0;

  @override
  Future<List<Course>> obtenerCursos() async {
    llamadas++;
    if (fallaAlCargar) throw Exception('sin conexión');
    return List<Course>.of(cursos);
  }

  @override
  Future<Course?> obtenerCurso(String id) async {
    for (final curso in cursos) {
      if (curso.id == id) return curso;
    }
    return null;
  }

  @override
  Future<void> guardarCurso(Course curso) async {
    final indice = cursos.indexWhere((actual) => actual.id == curso.id);
    if (indice < 0) {
      cursos.add(curso);
    } else {
      cursos[indice] = curso;
    }
  }

  @override
  Future<void> eliminarCurso(String id) async {
    if (fallaAlEliminar) throw StateError('fallo de almacenamiento');
    final asociadas =
        tareas?.tareas.where((tarea) => tarea.cursoId == id).length ?? 0;
    if (asociadas > 0) throw CursoConTareasException(asociadas);
    final indice = cursos.indexWhere((curso) => curso.id == id);
    if (indice < 0) throw StateError('curso inexistente');
    cursos.removeAt(indice);
  }

  @override
  Future<void> restaurarCurso(Course curso, {int? indice}) async {
    final posicion = indice == null
        ? cursos.length
        : indice.clamp(0, cursos.length);
    cursos.insert(posicion, curso);
  }
}

/// Repositorio de tareas en memoria para pruebas de interfaz.
class TareaRepoMemoria implements TaskRepository {
  TareaRepoMemoria([List<Task>? tareas])
    : tareas = List<Task>.of(tareas ?? const <Task>[]);

  final List<Task> tareas;
  bool fallaAlCargar = false;
  bool fallaAlGuardar = false;

  @override
  Future<List<Task>> obtenerTareas() async {
    if (fallaAlCargar) throw Exception('sin conexión');
    return List<Task>.of(tareas);
  }

  @override
  Future<Task?> obtenerTarea(String id) async {
    for (final tarea in tareas) {
      if (tarea.id == id) return tarea;
    }
    return null;
  }

  @override
  Future<void> guardarTarea(Task tarea) async {
    if (fallaAlGuardar) throw StateError('fallo de almacenamiento');
    final indice = tareas.indexWhere((actual) => actual.id == tarea.id);
    if (indice < 0) {
      tareas.add(tarea);
    } else {
      tareas[indice] = tarea;
    }
  }

  @override
  Future<void> eliminarTarea(String id) async {
    tareas.removeWhere((tarea) => tarea.id == id);
  }

  @override
  Future<int> contarActivas() async =>
      tareas.where((tarea) => !tarea.completada).length;
}
