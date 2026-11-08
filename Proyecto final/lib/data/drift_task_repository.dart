import 'package:drift/drift.dart';

import '../models/task.dart';
import 'db/app_database.dart';
import 'db/tareas_dao.dart';
import 'task_repository.dart';

/// [TaskRepository] sobre la base SQLite (Drift).
///
/// [usuarioId] es el uid de Firebase Auth: filtra las consultas y marca las
/// filas nuevas. Con el valor vacío (sin sesión o en pruebas) se comporta
/// como antes del esquema v4.
class DriftTaskRepository implements TaskRepository {
  DriftTaskRepository(this._db, {this.usuarioId = ''});

  final AppDatabase _db;
  final String usuarioId;

  TareasDao get _dao => _db.tareasDao;

  @override
  Stream<List<Task>> watchTareas({String? cursoId}) => _dao
      .observar(cursoId: cursoId, usuarioId: usuarioId)
      .map((filas) => filas.map(tareaDesdeFilas).toList(growable: false));

  @override
  Future<Task?> obtenerTarea(String id) async {
    final filas = await _dao.buscar(id);
    return filas == null ? null : tareaDesdeFilas(filas);
  }

  @override
  Future<void> crear(Task tarea) => _dao.insertar(
    tareaAFila(tarea, usuarioId: usuarioId),
    subtareasAFilas(tarea),
    tarea.recordatorioMinutos,
  );

  @override
  Future<void> actualizar(Task tarea) async {
    final existia = await _dao.actualizar(
      tareaAFila(tarea, usuarioId: usuarioId),
      subtareasAFilas(tarea),
      tarea.recordatorioMinutos,
    );
    if (!existia) throw TareaNoEncontradaException(tarea.id);
  }

  @override
  Future<void> eliminar(String id) => _dao.eliminar(id);
}

Task tareaDesdeFilas(TareaConDetalle filas) {
  final tarea = filas.tarea;
  return Task(
    id: tarea.id,
    titulo: tarea.titulo,
    cursoId: tarea.cursoId,
    fechaEntrega: tarea.fechaEntrega,
    prioridad: tarea.prioridad,
    tipo: tarea.tipo,
    estado: tarea.estado,
    descripcion: tarea.descripcion,
    recordatorioMinutos: filas.recordatorio?.minutosAntes,
    subtareas: [
      for (final subtarea in filas.subtareas)
        Subtask(
          id: subtarea.id,
          titulo: subtarea.titulo,
          hecha: subtarea.hecha,
        ),
    ],
  );
}

TasksCompanion tareaAFila(
  Task tarea, {
  String usuarioId = '',
  DateTime? actualizadaEn,
  DateTime? creadaEn,
}) => TasksCompanion(
  id: Value(tarea.id),
  usuarioId: Value(usuarioId),
  cursoId: Value(tarea.cursoId),
  titulo: Value(tarea.titulo),
  descripcion: Value(tarea.descripcion),
  tipo: Value(tarea.tipo),
  prioridad: Value(tarea.prioridad),
  estado: Value(tarea.estado),
  fechaEntrega: Value(tarea.fechaEntrega),
  actualizadaEn: Value(actualizadaEn ?? DateTime.now()),
  creadaEn: creadaEn == null ? const Value.absent() : Value(creadaEn),
);

List<SubtasksCompanion> subtareasAFilas(Task tarea) => [
  for (final (posicion, subtarea) in tarea.subtareas.indexed)
    SubtasksCompanion.insert(
      id: subtarea.id,
      tareaId: tarea.id,
      titulo: subtarea.titulo,
      hecha: Value(subtarea.hecha),
      posicion: posicion,
    ),
];
