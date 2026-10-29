import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Curso académico: agrupa las tareas, exámenes y proyectos del estudiante.
///
/// El curso no guarda cuántas tareas tiene: esos números se calculan a partir
/// de las tareas reales (ver [CourseSummary]). Así la información nunca queda
/// desincronizada cuando se completa o elimina una tarea.
@immutable
class Course {
  const Course({
    required this.id,
    required this.nombre,
    required this.docente,
    required this.color,
    required this.dias,
    required this.horaInicio,
    required this.horaFin,
    this.periodo = '2026-2',
  });

  /// Curso de reemplazo cuando una tarea apunta a un id que no se encontró
  /// (por ejemplo, mientras la lista de cursos todavía se está cargando).
  const Course.desconocido(this.id)
    : nombre = 'Curso no disponible',
      docente = '',
      color = const Color(0xFF94A3B8),
      dias = const <String>[],
      horaInicio = '',
      horaFin = '',
      periodo = '';

  final String id;
  final String nombre;
  final String docente;
  final Color color;
  final List<String> dias;
  final String horaInicio;
  final String horaFin;
  final String periodo;

  /// Horario listo para mostrar, p. ej. «Lun · Mié · 10:00–12:00».
  String get horario {
    final horas = (horaInicio.isEmpty || horaFin.isEmpty)
        ? ''
        : ' · $horaInicio–$horaFin';
    return '${dias.join(' · ')}$horas';
  }

  Course copyWith({
    String? nombre,
    String? docente,
    Color? color,
    List<String>? dias,
    String? horaInicio,
    String? horaFin,
    String? periodo,
  }) {
    return Course(
      id: id,
      nombre: nombre ?? this.nombre,
      docente: docente ?? this.docente,
      color: color ?? this.color,
      dias: dias ?? this.dias,
      horaInicio: horaInicio ?? this.horaInicio,
      horaFin: horaFin ?? this.horaFin,
      periodo: periodo ?? this.periodo,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Course &&
      other.id == id &&
      other.nombre == nombre &&
      other.docente == docente &&
      // Por valor: un MaterialColor y un Color con el mismo ARGB son iguales.
      other.color.toARGB32() == color.toARGB32() &&
      listEquals(other.dias, dias) &&
      other.horaInicio == horaInicio &&
      other.horaFin == horaFin &&
      other.periodo == periodo;

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    docente,
    color.toARGB32(),
    Object.hashAll(dias),
    horaInicio,
    horaFin,
    periodo,
  );

  @override
  String toString() => 'Course($id, $nombre)';
}

/// Búsqueda de cursos por id, para las pantallas que reciben una tarea (que
/// solo conoce `cursoId`) y necesitan el nombre o el color del curso.
extension BuscarCurso on Iterable<Course> {
  Course porId(String id) {
    for (final curso in this) {
      if (curso.id == id) return curso;
    }
    return Course.desconocido(id);
  }
}
