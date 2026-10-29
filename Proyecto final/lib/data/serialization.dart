import 'package:flutter/material.dart';

import '../models/course.dart';
import '../models/task.dart';

/// Convierte los modelos a mapas JSON y de vuelta.
///
/// La fecha de entrega se guarda en ISO 8601 y los enums por su nombre, de
/// modo que el contenido de la base sea estable y fácil de inspeccionar.
Map<String, dynamic> cursoAJson(Course curso) => {
  'id': curso.id,
  'nombre': curso.nombre,
  'docente': curso.docente,
  'color': curso.color.toARGB32(),
  'dias': curso.dias,
  'horaInicio': curso.horaInicio,
  'horaFin': curso.horaFin,
  'periodo': curso.periodo,
};

Course cursoDesdeJson(Map<String, dynamic> json) => Course(
  id: json['id'] as String,
  nombre: json['nombre'] as String? ?? 'Curso sin nombre',
  docente: json['docente'] as String? ?? 'Sin docente',
  color: Color(json['color'] as int? ?? 0xFF64748B),
  dias: (json['dias'] as List?)?.cast<String>() ?? const <String>[],
  horaInicio: json['horaInicio'] as String? ?? '',
  horaFin: json['horaFin'] as String? ?? '',
  periodo: json['periodo'] as String? ?? '2026-2',
);

Map<String, dynamic> tareaAJson(Task tarea) => {
  'id': tarea.id,
  'titulo': tarea.titulo,
  'cursoId': tarea.curso.id,
  'prioridad': tarea.prioridad.name,
  'tipo': tarea.tipo.name,
  'estado': tarea.estado.name,
  'descripcion': tarea.descripcion,
  'fechaEntrega': tarea.fechaEntrega?.toIso8601String(),
  'recordatorio': tarea.recordatorio.name,
  'subtareas': [
    for (final subtarea in tarea.subtareas)
      {'id': subtarea.id, 'titulo': subtarea.titulo, 'hecha': subtarea.hecha},
  ],
};

/// Reconstruye una tarea resolviendo su curso en [cursosPorId].
///
/// Si el curso ya no existe, se usa un curso provisional para no perder la
/// tarea. La app impide borrar cursos con tareas, así que este caso solo
/// cubriría datos externos o una base manipulada a mano.
Task tareaDesdeJson(
  Map<String, dynamic> json,
  Map<String, Course> cursosPorId,
) {
  final cursoId = json['cursoId'] as String? ?? '';
  final curso =
      cursosPorId[cursoId] ??
      Course(
        id: cursoId,
        nombre: 'Curso eliminado',
        docente: 'Sin docente',
        color: const Color(0xFF94A3B8),
        dias: const <String>[],
        horaInicio: '',
        horaFin: '',
      );

  final subtareasJson = (json['subtareas'] as List?) ?? const [];
  final subtareas = <Subtask>[];
  for (var indice = 0; indice < subtareasJson.length; indice++) {
    final dato = subtareasJson[indice];
    if (dato is! Map) continue;
    subtareas.add(
      Subtask(
        id: dato['id'] as String? ?? 'subtarea-$indice',
        titulo: dato['titulo'] as String? ?? '',
        hecha: dato['hecha'] as bool? ?? false,
      ),
    );
  }

  return Task(
    id: json['id'] as String,
    titulo: json['titulo'] as String? ?? 'Tarea sin título',
    curso: curso,
    prioridad: Prioridad.desdeNombre(json['prioridad'] as String?),
    tipo: TipoTarea.desdeNombre(json['tipo'] as String?),
    estado: EstadoTarea.desdeNombre(json['estado'] as String?),
    descripcion: json['descripcion'] as String? ?? '',
    fechaEntrega: DateTime.tryParse(json['fechaEntrega'] as String? ?? ''),
    recordatorio: RecordatorioOpcion.desdeNombre(
      json['recordatorio'] as String?,
    ),
    subtareas: subtareas,
  );
}
