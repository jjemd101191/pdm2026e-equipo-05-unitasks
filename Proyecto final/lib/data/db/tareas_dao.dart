import 'package:drift/drift.dart';

import 'app_database.dart';
import 'tablas.dart';

part 'tareas_dao.g.dart';

/// Una tarea con todo lo que cuelga de ella.
typedef TareaConDetalle = ({
  TareaFila tarea,
  List<SubtareaFila> subtareas,
  RecordatorioFila? recordatorio,
});

/// Consultas sobre `tasks`, `subtasks` y `reminders`.
///
/// Una tarea y sus hijas siempre se escriben juntas dentro de una
/// transacción, para que nadie vea una tarea a medio guardar.
@DriftAccessor(tables: [Tasks, Subtasks, Reminders])
class TareasDao extends DatabaseAccessor<AppDatabase> with _$TareasDaoMixin {
  TareasDao(super.attachedDatabase);

  /// Tareas ordenadas por fecha de entrega, opcionalmente de un solo curso.
  ///
  /// Es una sola consulta con JOIN, así que el stream se vuelve a emitir
  /// cuando cambia cualquiera de las tres tablas (no solo `tasks`).
  Stream<List<TareaConDetalle>> observar({String? cursoId}) {
    final consulta = _consultaConDetalle();
    if (cursoId != null) consulta.where(tasks.cursoId.equals(cursoId));
    return consulta.watch().map(_agrupar);
  }

  Future<TareaConDetalle?> buscar(String id) async {
    final consulta = _consultaConDetalle()..where(tasks.id.equals(id));
    final tareas = _agrupar(await consulta.get());
    return tareas.isEmpty ? null : tareas.first;
  }

  Future<void> insertar(
    TasksCompanion tarea,
    List<SubtasksCompanion> subtareas,
    int? minutosRecordatorio,
  ) {
    return transaction(() async {
      await into(tasks).insert(tarea);
      await _reemplazarHijas(tarea.id.value, subtareas, minutosRecordatorio);
    });
  }

  /// Devuelve `false` si la tarea no existía.
  Future<bool> actualizar(
    TasksCompanion tarea,
    List<SubtasksCompanion> subtareas,
    int? minutosRecordatorio,
  ) {
    final id = tarea.id.value;
    return transaction(() async {
      final cambiadas = await (update(tasks)..where((t) => t.id.equals(id)))
          .write(tarea.copyWith(actualizadaEn: Value(DateTime.now())));
      if (cambiadas == 0) return false;
      await _reemplazarHijas(id, subtareas, minutosRecordatorio);
      return true;
    });
  }

  /// Borra la tarea; subtareas y recordatorio se van por el CASCADE.
  Future<int> eliminar(String id) =>
      (delete(tasks)..where((t) => t.id.equals(id))).go();

  Future<void> _reemplazarHijas(
    String tareaId,
    List<SubtasksCompanion> subtareas,
    int? minutosRecordatorio,
  ) async {
    // Las subtareas se reescriben completas: son pocas y así el orden
    // (posicion) siempre coincide con la lista del modelo.
    await (delete(subtasks)..where((s) => s.tareaId.equals(tareaId))).go();
    await batch((b) => b.insertAll(subtasks, subtareas));

    if (minutosRecordatorio == null) {
      await (delete(reminders)..where((r) => r.tareaId.equals(tareaId))).go();
      return;
    }
    // Upsert sobre tarea_id para conservar el id del recordatorio (que es
    // el id de la notificación) cuando solo cambian los minutos.
    await into(reminders).insert(
      RemindersCompanion.insert(
        tareaId: tareaId,
        minutosAntes: minutosRecordatorio,
      ),
      onConflict: DoUpdate(
        (_) => RemindersCompanion(minutosAntes: Value(minutosRecordatorio)),
        target: [reminders.tareaId],
      ),
    );
  }

  JoinedSelectStatement<HasResultSet, dynamic> _consultaConDetalle() {
    return select(tasks).join([
      leftOuterJoin(reminders, reminders.tareaId.equalsExp(tasks.id)),
      leftOuterJoin(subtasks, subtasks.tareaId.equalsExp(tasks.id)),
    ])..orderBy([
      OrderingTerm.asc(tasks.fechaEntrega),
      OrderingTerm.asc(tasks.id),
      OrderingTerm.asc(subtasks.posicion),
    ]);
  }

  /// El JOIN devuelve una fila por subtarea; aquí se vuelven a juntar.
  List<TareaConDetalle> _agrupar(List<TypedResult> filas) {
    final porTarea = <String, TareaConDetalle>{};
    for (final fila in filas) {
      final tarea = fila.readTable(tasks);
      final actual = porTarea.putIfAbsent(
        tarea.id,
        () => (
          tarea: tarea,
          subtareas: <SubtareaFila>[],
          recordatorio: fila.readTableOrNull(reminders),
        ),
      );
      final subtarea = fila.readTableOrNull(subtasks);
      if (subtarea != null) actual.subtareas.add(subtarea);
    }
    return porTarea.values.toList();
  }
}
