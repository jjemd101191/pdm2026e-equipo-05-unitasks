import 'course.dart';

/// Prioridad de un compromiso académico.
enum Prioridad {
  alta('Alta'),
  media('Media'),
  baja('Baja');

  const Prioridad(this.etiqueta);

  final String etiqueta;

  static Prioridad desdeNombre(String? nombre) => values.firstWhere(
    (valor) => valor.name == nombre,
    orElse: () => Prioridad.media,
  );
}

/// Tipo de compromiso: tarea, examen o proyecto.
enum TipoTarea {
  tarea('Tarea'),
  examen('Examen'),
  proyecto('Proyecto');

  const TipoTarea(this.etiqueta);

  final String etiqueta;

  static TipoTarea desdeNombre(String? nombre) => values.firstWhere(
    (valor) => valor.name == nombre,
    orElse: () => TipoTarea.tarea,
  );
}

/// Estado del compromiso dentro del flujo de trabajo.
enum EstadoTarea {
  pendiente('Pendiente'),
  enProgreso('En progreso'),
  completada('Completada');

  const EstadoTarea(this.etiqueta);

  final String etiqueta;

  static EstadoTarea desdeNombre(String? nombre) => values.firstWhere(
    (valor) => valor.name == nombre,
    orElse: () => EstadoTarea.pendiente,
  );
}

/// Opción de recordatorio elegida por el estudiante.
///
/// Guardar la opción (y no un texto) permite calcular después la fecha exacta
/// de la notificación a partir de la fecha de entrega.
enum RecordatorioOpcion {
  sinRecordatorio('Sin recordatorio'),
  unaHora('1 hora antes'),
  mismoDia('El mismo día · 8:00 a. m.'),
  unDia('1 día antes · 8:00 a. m.'),
  dosDias('2 días antes · 8:00 a. m.');

  const RecordatorioOpcion(this.etiqueta);

  final String etiqueta;

  bool get activo => this != RecordatorioOpcion.sinRecordatorio;

  /// Fecha y hora en que debería dispararse el aviso, o `null` si no aplica.
  DateTime? programadoPara(DateTime? entrega) {
    if (entrega == null || !activo) return null;
    final dia = DateTime(entrega.year, entrega.month, entrega.day);
    return switch (this) {
      RecordatorioOpcion.unaHora => entrega.subtract(const Duration(hours: 1)),
      RecordatorioOpcion.mismoDia => dia.add(const Duration(hours: 8)),
      RecordatorioOpcion.unDia =>
        dia.subtract(const Duration(days: 1)).add(const Duration(hours: 8)),
      RecordatorioOpcion.dosDias =>
        dia.subtract(const Duration(days: 2)).add(const Duration(hours: 8)),
      RecordatorioOpcion.sinRecordatorio => null,
    };
  }

  static RecordatorioOpcion desdeNombre(String? nombre) => values.firstWhere(
    (valor) => valor.name == nombre,
    orElse: () => RecordatorioOpcion.sinRecordatorio,
  );
}

/// Subtarea: elemento inmutable de la lista de verificación de una tarea.
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
}

/// Compromiso académico: tarea, examen o proyecto.
///
/// Es inmutable: cada cambio produce una instancia nueva con [copyWith]. Eso
/// permite guardar en la base local sin efectos colaterales sobre la lista que
/// están mostrando otras pantallas.
class Task {
  Task({
    required this.id,
    required this.titulo,
    required this.curso,
    this.prioridad = Prioridad.media,
    this.tipo = TipoTarea.tarea,
    this.estado = EstadoTarea.pendiente,
    this.descripcion = '',
    this.fechaEntrega,
    this.recordatorio = RecordatorioOpcion.sinRecordatorio,
    List<Subtask> subtareas = const <Subtask>[],
  }) : subtareas = List<Subtask>.unmodifiable(subtareas);

  final String id;
  final String titulo;
  final Course curso;
  final Prioridad prioridad;
  final TipoTarea tipo;
  final EstadoTarea estado;
  final String descripcion;
  final DateTime? fechaEntrega;
  final RecordatorioOpcion recordatorio;
  final List<Subtask> subtareas;

  /// Identificador del curso en la base de datos.
  String get cursoId => curso.id;

  int get completadas => subtareas.where((subtask) => subtask.hecha).length;

  double get progreso =>
      subtareas.isEmpty ? (completada ? 1 : 0) : completadas / subtareas.length;

  bool get completada => estado == EstadoTarea.completada;

  /// `true` cuando la fecha de entrega ya pasó y la tarea sigue activa.
  bool get vencida {
    final fecha = fechaEntrega;
    return fecha != null && !completada && fecha.isBefore(DateTime.now());
  }

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

  Task copyWith({
    String? titulo,
    Course? curso,
    Prioridad? prioridad,
    TipoTarea? tipo,
    EstadoTarea? estado,
    String? descripcion,
    DateTime? fechaEntrega,
    bool limpiarFechaEntrega = false,
    RecordatorioOpcion? recordatorio,
    List<Subtask>? subtareas,
  }) {
    return Task(
      id: id,
      titulo: titulo ?? this.titulo,
      curso: curso ?? this.curso,
      prioridad: prioridad ?? this.prioridad,
      tipo: tipo ?? this.tipo,
      estado: estado ?? this.estado,
      descripcion: descripcion ?? this.descripcion,
      fechaEntrega: limpiarFechaEntrega
          ? null
          : (fechaEntrega ?? this.fechaEntrega),
      recordatorio: recordatorio ?? this.recordatorio,
      subtareas: subtareas ?? this.subtareas,
    );
  }
}
