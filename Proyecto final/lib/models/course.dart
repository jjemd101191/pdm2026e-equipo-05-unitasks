import 'package:flutter/material.dart';

/// Curso académico: agrupa las tareas, exámenes y proyectos del estudiante.
class Course {
  const Course({
    required this.nombre,
    required this.docente,
    required this.color,
    required this.dias,
    required this.horaInicio,
    required this.horaFin,
    this.periodo = '2026-2',
    this.pendientes = 0,
    this.totalTareas = 0,
  });

  final String nombre;
  final String docente;
  final Color color;
  final List<String> dias;
  final String horaInicio;
  final String horaFin;
  final String periodo;
  final int pendientes;
  final int totalTareas;

  /// Horario listo para mostrar, p. ej. «Lun · Mié · 10:00–12:00».
  String get horario {
    final horas = (horaInicio.isEmpty || horaFin.isEmpty)
        ? ''
        : ' · $horaInicio–$horaFin';
    return '${dias.join(' · ')}$horas';
  }
}
