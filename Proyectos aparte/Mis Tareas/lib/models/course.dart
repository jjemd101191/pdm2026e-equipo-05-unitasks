import 'package:flutter/material.dart';

/// Curso académico: agrupa las tareas, exámenes y proyectos del estudiante.
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
    this.pendientes = 0,
    this.totalTareas = 0,
    this.archivado = false,
  });

  final String id;
  final String nombre;
  final String docente;
  final Color color;
  final List<String> dias;
  final String horaInicio;
  final String horaFin;
  final String periodo;
  final int pendientes;
  final int totalTareas;
  final bool archivado;

  Course copyWith({
    String? nombre,
    String? docente,
    Color? color,
    List<String>? dias,
    String? horaInicio,
    String? horaFin,
    String? periodo,
    int? pendientes,
    int? totalTareas,
    bool? archivado,
  }) => Course(
    id: id,
    nombre: nombre ?? this.nombre,
    docente: docente ?? this.docente,
    color: color ?? this.color,
    dias: dias ?? this.dias,
    horaInicio: horaInicio ?? this.horaInicio,
    horaFin: horaFin ?? this.horaFin,
    periodo: periodo ?? this.periodo,
    pendientes: pendientes ?? this.pendientes,
    totalTareas: totalTareas ?? this.totalTareas,
    archivado: archivado ?? this.archivado,
  );

  /// Horario listo para mostrar, p. ej. «Lun · Mié · 10:00–12:00».
  String get horario {
    final horas = (horaInicio.isEmpty || horaFin.isEmpty)
        ? ''
        : ' · $horaInicio–$horaFin';
    return '${dias.join(' · ')}$horas';
  }
}
