import 'dart:ui';

import '../../models/course.dart';
import '../../models/task.dart';

/// Un curso con su marca de tiempo, tal como viaja a Firestore.
class CursoRemoto {
  const CursoRemoto({
    required this.curso,
    required this.actualizadaEn,
    required this.creadaEn,
  });

  final Course curso;
  final DateTime actualizadaEn;
  final DateTime creadaEn;

  Map<String, dynamic> aMapa() => {
    'nombre': curso.nombre,
    'docente': curso.docente,
    'color': curso.color.toARGB32(),
    'dias': curso.dias,
    'horaInicio': curso.horaInicio,
    'horaFin': curso.horaFin,
    'periodo': curso.periodo,
    'archivado': curso.archivado,
    'creadaEnMs': creadaEn.millisecondsSinceEpoch,
    'actualizadaEnMs': actualizadaEn.millisecondsSinceEpoch,
  };

  /// Reconstruye el curso a partir del documento. Los valores faltantes o de
  /// otro tipo se ignoran para no romper la app con datos viejos.
  factory CursoRemoto.desdeMapa(String id, Map<String, dynamic> mapa) {
    final actualizada = _fecha(mapa['actualizadaEnMs']) ?? DateTime.now();
    return CursoRemoto(
      curso: Course(
        id: id,
        nombre: _texto(mapa['nombre'], 'Curso sin nombre'),
        docente: _texto(mapa['docente']),
        color: Color(_color(mapa['color'])),
        dias: _listaTexto(mapa['dias']),
        horaInicio: _texto(mapa['horaInicio']),
        horaFin: _texto(mapa['horaFin']),
        periodo: _texto(mapa['periodo'], '2026-2'),
        archivado: mapa['archivado'] == true,
      ),
      actualizadaEn: actualizada,
      creadaEn: _fecha(mapa['creadaEnMs']) ?? actualizada,
    );
  }
}

/// Una tarea con sus hijas y su marca de tiempo, tal como viaja a Firestore.
class TareaRemota {
  const TareaRemota({
    required this.tarea,
    required this.actualizadaEn,
    required this.creadaEn,
  });

  final Task tarea;
  final DateTime actualizadaEn;
  final DateTime creadaEn;

  Map<String, dynamic> aMapa() => {
    'titulo': tarea.titulo,
    'cursoId': tarea.cursoId,
    'descripcion': tarea.descripcion,
    'tipo': tarea.tipo.name,
    'prioridad': tarea.prioridad.name,
    'estado': tarea.estado.name,
    'fechaEntregaMs': tarea.fechaEntrega.millisecondsSinceEpoch,
    'recordatorioMinutos': tarea.recordatorioMinutos,
    'subtareas': [
      for (final subtarea in tarea.subtareas)
        {'id': subtarea.id, 'titulo': subtarea.titulo, 'hecha': subtarea.hecha},
    ],
    'creadaEnMs': creadaEn.millisecondsSinceEpoch,
    'actualizadaEnMs': actualizadaEn.millisecondsSinceEpoch,
  };

  factory TareaRemota.desdeMapa(String id, Map<String, dynamic> mapa) {
    final actualizada = _fecha(mapa['actualizadaEnMs']) ?? DateTime.now();
    final subtareas = <Subtask>[];
    final crudas = mapa['subtareas'];
    if (crudas is List) {
      for (final cruda in crudas) {
        if (cruda is! Map) continue;
        final subtareaId = _texto(cruda['id']);
        if (subtareaId.isEmpty) continue;
        subtareas.add(
          Subtask(
            id: subtareaId,
            titulo: _texto(cruda['titulo'], 'Subtarea'),
            hecha: cruda['hecha'] == true,
          ),
        );
      }
    }
    final recordatorio = mapa['recordatorioMinutos'];
    return TareaRemota(
      tarea: Task(
        id: id,
        titulo: _texto(mapa['titulo'], 'Tarea sin título'),
        cursoId: _texto(mapa['cursoId']),
        fechaEntrega: _fecha(mapa['fechaEntregaMs']) ?? actualizada,
        tipo: _enum(TipoTarea.values, mapa['tipo'], TipoTarea.tarea),
        prioridad: _enum(Prioridad.values, mapa['prioridad'], Prioridad.media),
        estado: _enum(
          EstadoTarea.values,
          mapa['estado'],
          EstadoTarea.pendiente,
        ),
        descripcion: _texto(mapa['descripcion']),
        recordatorioMinutos: recordatorio is int && recordatorio > 0
            ? recordatorio
            : null,
        subtareas: subtareas,
      ),
      actualizadaEn: actualizada,
      creadaEn: _fecha(mapa['creadaEnMs']) ?? actualizada,
    );
  }
}

String _texto(Object? valor, [String porDefecto = '']) =>
    valor is String ? valor : porDefecto;

DateTime? _fecha(Object? valor) =>
    valor is int ? DateTime.fromMillisecondsSinceEpoch(valor) : null;

int _color(Object? valor) => valor is int ? valor : 0xFF64748B;

List<String> _listaTexto(Object? valor) => valor is List
    ? [
        for (final elemento in valor)
          if (elemento is String) elemento,
      ]
    : const <String>[];

T _enum<T extends Enum>(List<T> valores, Object? nombre, T porDefecto) {
  for (final valor in valores) {
    if (valor.name == nombre) return valor;
  }
  return porDefecto;
}
