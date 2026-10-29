import 'package:flutter/foundation.dart';

/// Prioridad de un compromiso académico.
///
/// Ojo: en la base se guarda el `name` de cada valor, así que renombrar un
/// valor exige una migración.
enum Prioridad {
  alta('Alta'),
  media('Media'),
  baja('Baja');

  const Prioridad(this.etiqueta);

  final String etiqueta;
}

/// Tipo de compromiso: tarea, examen o proyecto.
enum TipoTarea {
  tarea('Tarea'),
  examen('Examen'),
  proyecto('Proyecto');

  const TipoTarea(this.etiqueta);

  final String etiqueta;
}

/// Estado del compromiso dentro del flujo de trabajo.
enum EstadoTarea {
  pendiente('Pendiente'),
  enProgreso('En progreso'),
  completada('Completada');

  const EstadoTarea(this.etiqueta);

  final String etiqueta;
}

/// Opciones de recordatorio que ofrece el formulario.
///
/// La tarea solo guarda los minutos de anticipación
/// ([Task.recordatorioMinutos]); este enum es un atajo para la interfaz.
enum RecordatorioOpcion {
  sinRecordatorio(null, 'Sin recordatorio'),
  quinceMinutos(15, '15 minutos antes'),
  unaHora(60, '1 hora antes'),
  unDia(24 * 60, '1 día antes'),
  dosDias(2 * 24 * 60, '2 días antes');

  const RecordatorioOpcion(this.minutos, this.etiqueta);

  final int? minutos;
  final String etiqueta;

  bool get activo => minutos != null;

  /// Opción que corresponde a [minutos], o `null` si no es una de las
  /// predefinidas (por ejemplo, un valor importado a mano).
  static RecordatorioOpcion? desdeMinutos(int? minutos) {
    for (final opcion in values) {
      if (opcion.minutos == minutos) return opcion;
    }
    return null;
  }
}

/// Subtarea: elemento de la lista de verificación de una tarea.
@immutable
class Subtask {
  const Subtask({required this.id, required this.titulo, this.hecha = false});

  final String id;
  final String titulo;
  final bool hecha;

  Subtask copyWith({String? titulo, bool? hecha}) => Subtask(
    id: id,
    titulo: titulo ?? this.titulo,
    hecha: hecha ?? this.hecha,
  );

  @override
  bool operator ==(Object other) =>
      other is Subtask &&
      other.id == id &&
      other.titulo == titulo &&
      other.hecha == hecha;

  @override
  int get hashCode => Object.hash(id, titulo, hecha);

  @override
  String toString() => 'Subtask($id, $titulo, hecha: $hecha)';
}

/// Compromiso académico: tarea, examen o proyecto.
///
/// Es inmutable: cada cambio produce una instancia nueva con [copyWith]. La
/// tarea guarda solo el [cursoId]; el curso completo se busca en la lista de
/// cursos (así editar un curso no deja copias viejas dentro de las tareas).
@immutable
class Task {
  Task({
    required this.id,
    required this.titulo,
    required this.cursoId,
    required this.fechaEntrega,
    this.prioridad = Prioridad.media,
    this.tipo = TipoTarea.tarea,
    this.estado = EstadoTarea.pendiente,
    this.descripcion = '',
    this.recordatorioMinutos,
    List<Subtask> subtareas = const <Subtask>[],
  }) : assert(
         recordatorioMinutos == null || recordatorioMinutos > 0,
         'El recordatorio debe ser antes de la entrega',
       ),
       subtareas = List<Subtask>.unmodifiable(subtareas);

  final String id;
  final String titulo;
  final String cursoId;
  final DateTime fechaEntrega;
  final Prioridad prioridad;
  final TipoTarea tipo;
  final EstadoTarea estado;
  final String descripcion;

  /// Minutos antes de [fechaEntrega] en que debe sonar el aviso;
  /// `null` = sin recordatorio.
  final int? recordatorioMinutos;
  final List<Subtask> subtareas;

  bool get completada => estado == EstadoTarea.completada;

  int get completadas => subtareas.where((subtarea) => subtarea.hecha).length;

  double get progreso =>
      subtareas.isEmpty ? (completada ? 1 : 0) : completadas / subtareas.length;

  /// Momento exacto del aviso, o `null` si la tarea no tiene recordatorio.
  DateTime? get fechaRecordatorio {
    final minutos = recordatorioMinutos;
    if (minutos == null) return null;
    return fechaEntrega.subtract(Duration(minutes: minutos));
  }

  /// Texto del recordatorio para mostrar en pantalla.
  String get etiquetaRecordatorio {
    final minutos = recordatorioMinutos;
    final opcion = RecordatorioOpcion.desdeMinutos(minutos);
    if (opcion != null) return opcion.etiqueta;
    return '$minutos minutos antes';
  }

  /// `true` cuando la fecha de entrega ya pasó y la tarea sigue activa.
  bool get vencida => vencidaEn(DateTime.now());

  /// Igual que [vencida], pero con la hora de referencia explícita
  /// (útil en pruebas).
  bool vencidaEn(DateTime ahora) => !completada && fechaEntrega.isBefore(ahora);

  /// Alterna entre completada y en progreso.
  /// Al completar, marca también todas las subtareas.
  Task alternarCompletada() {
    if (completada) {
      return copyWith(estado: EstadoTarea.enProgreso);
    }
    return copyWith(
      estado: EstadoTarea.completada,
      subtareas: [
        for (final subtarea in subtareas) subtarea.copyWith(hecha: true),
      ],
    );
  }

  /// Marca o desmarca una subtarea. Si la tarea estaba completada, se reabre.
  Task alternarSubtarea(String subtareaId) {
    final actualizadas = [
      for (final subtarea in subtareas)
        subtarea.id == subtareaId
            ? subtarea.copyWith(hecha: !subtarea.hecha)
            : subtarea,
    ];
    return copyWith(
      subtareas: actualizadas,
      estado: completada ? EstadoTarea.enProgreso : estado,
    );
  }

  Task agregarSubtarea(Subtask subtarea) =>
      copyWith(subtareas: [...subtareas, subtarea]);

  Task quitarSubtarea(String subtareaId) => copyWith(
    subtareas: subtareas
        .where((subtarea) => subtarea.id != subtareaId)
        .toList(),
  );

  /// Copia con cambios. Como `null` en [recordatorioMinutos] significa «no
  /// cambiar», para quitar el recordatorio se usa [quitarRecordatorio].
  Task copyWith({
    String? titulo,
    String? cursoId,
    DateTime? fechaEntrega,
    Prioridad? prioridad,
    TipoTarea? tipo,
    EstadoTarea? estado,
    String? descripcion,
    int? recordatorioMinutos,
    bool quitarRecordatorio = false,
    List<Subtask>? subtareas,
  }) {
    return Task(
      id: id,
      titulo: titulo ?? this.titulo,
      cursoId: cursoId ?? this.cursoId,
      fechaEntrega: fechaEntrega ?? this.fechaEntrega,
      prioridad: prioridad ?? this.prioridad,
      tipo: tipo ?? this.tipo,
      estado: estado ?? this.estado,
      descripcion: descripcion ?? this.descripcion,
      recordatorioMinutos: quitarRecordatorio
          ? null
          : (recordatorioMinutos ?? this.recordatorioMinutos),
      subtareas: subtareas ?? this.subtareas,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Task &&
      other.id == id &&
      other.titulo == titulo &&
      other.cursoId == cursoId &&
      other.fechaEntrega == fechaEntrega &&
      other.prioridad == prioridad &&
      other.tipo == tipo &&
      other.estado == estado &&
      other.descripcion == descripcion &&
      other.recordatorioMinutos == recordatorioMinutos &&
      listEquals(other.subtareas, subtareas);

  @override
  int get hashCode => Object.hash(
    id,
    titulo,
    cursoId,
    fechaEntrega,
    prioridad,
    tipo,
    estado,
    descripcion,
    recordatorioMinutos,
    Object.hashAll(subtareas),
  );

  @override
  String toString() => 'Task($id, $titulo, curso: $cursoId, $estado)';
}
