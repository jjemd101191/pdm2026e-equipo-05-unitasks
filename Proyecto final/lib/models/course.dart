import 'package:flutter/material.dart';

/// Curso académico: agrupa las tareas, exámenes y proyectos del estudiante.
///
/// El curso no guarda cuántas tareas tiene: esos números se calculan a partir
/// de las tareas reales (ver [CourseSummary]). Así la información nunca queda
/// desincronizada cuando se completa o elimina una tarea.
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
  bool operator ==(Object other) => other is Course && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
