import 'course.dart';

/// Subtarea: elemento de la lista de verificación de una tarea.
class Subtask {
  Subtask(this.titulo, {this.hecha = false});

  final String titulo;
  bool hecha;
}

/// Compromiso académico: tarea, examen o proyecto.
class Task {
  Task({
    required this.titulo,
    required this.curso,
    this.prioridad = 'Media',
    this.tipo = 'Tarea',
    this.estado = 'Pendiente',
    this.descripcion = '',
    this.fechaEntrega = '',
    this.recordatorio = '',
    this.recordatorioActivo = true,
    List<Subtask>? subtareas,
  }) : subtareas = subtareas ?? <Subtask>[];

  final String titulo;
  final Course curso;
  final String prioridad;
  final String tipo;
  String estado;
  final String descripcion;
  final String fechaEntrega;
  final String recordatorio;
  final bool recordatorioActivo;
  final List<Subtask> subtareas;

  int get completadas => subtareas.where((s) => s.hecha).length;

  double get progreso => subtareas.isEmpty ? 0 : completadas / subtareas.length;

  bool get completada => estado == 'Completada';

  /// Alterna entre completada y en progreso.
  /// Al completar, marca también todas las subtareas.
  void alternarCompletada() {
    if (completada) {
      estado = 'En progreso';
    } else {
      estado = 'Completada';
      for (final subtarea in subtareas) {
        subtarea.hecha = true;
      }
    }
  }
}
