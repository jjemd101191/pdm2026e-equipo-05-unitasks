import 'package:drift/drift.dart';

import '../../models/task.dart';

// Esquema v1 de la base local. Las tablas se llaman en inglés (courses,
// tasks, subtasks, reminders) para que el SQL se lea igual que en el
// diagrama del proyecto; las columnas quedan en snake_case.
//
// Si cambias algo aquí: sube `schemaVersion` en app_database.dart, agrega
// el paso en `onUpgrade` y vuelve a correr `dart run build_runner build`.

/// Los días de clase se guardan como texto separado por comas ("Lun,Mié").
class DiasConverter extends TypeConverter<List<String>, String> {
  const DiasConverter();

  @override
  List<String> fromSql(String fromDb) =>
      fromDb.isEmpty ? const <String>[] : fromDb.split(',');

  @override
  String toSql(List<String> value) => value.join(',');
}

@DataClassName('CursoFila')
class Courses extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text().withLength(min: 1, max: 80)();
  TextColumn get docente => text().withDefault(const Constant(''))();

  /// Color en formato ARGB de 32 bits.
  IntColumn get color => integer()();
  TextColumn get dias =>
      text().map(const DiasConverter()).withDefault(const Constant(''))();
  TextColumn get horaInicio => text().withDefault(const Constant(''))();
  TextColumn get horaFin => text().withDefault(const Constant(''))();
  TextColumn get periodo => text().withDefault(const Constant('2026-2'))();
  DateTimeColumn get creadoEn => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TareaFila')
@TableIndex(name: 'idx_tasks_curso', columns: {#cursoId})
@TableIndex(name: 'idx_tasks_entrega', columns: {#fechaEntrega})
class Tasks extends Table {
  TextColumn get id => text()();

  /// RESTRICT: la base no deja borrar un curso que todavía tiene tareas.
  /// La regla también se revisa en el repositorio para dar un mensaje claro.
  TextColumn get cursoId =>
      text().references(Courses, #id, onDelete: KeyAction.restrict)();
  TextColumn get titulo => text().withLength(min: 1, max: 120)();
  TextColumn get descripcion => text().withDefault(const Constant(''))();
  TextColumn get tipo => textEnum<TipoTarea>()();
  TextColumn get prioridad => textEnum<Prioridad>()();
  TextColumn get estado => textEnum<EstadoTarea>()();
  DateTimeColumn get fechaEntrega => dateTime()();
  DateTimeColumn get creadaEn => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get actualizadaEn =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SubtareaFila')
@TableIndex(name: 'idx_subtasks_tarea', columns: {#tareaId})
class Subtasks extends Table {
  TextColumn get id => text()();
  TextColumn get tareaId =>
      text().references(Tasks, #id, onDelete: KeyAction.cascade)();
  TextColumn get titulo => text().withLength(min: 1, max: 120)();
  BoolColumn get hecha => boolean().withDefault(const Constant(false))();

  /// Orden dentro de la lista de verificación.
  IntColumn get posicion => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Recordatorio de una tarea. Por ahora hay como máximo uno por tarea
/// (índice único), pero la tabla aparte deja abierta la puerta a varios.
///
/// El `id` entero sirve directamente como id de la notificación local, y se
/// mantiene al editar la tarea, así que se puede cancelar/reprogramar.
@DataClassName('RecordatorioFila')
@TableIndex(name: 'idx_reminders_tarea', columns: {#tareaId}, unique: true)
class Reminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tareaId =>
      text().references(Tasks, #id, onDelete: KeyAction.cascade)();
  IntColumn get minutosAntes =>
      // ignore: recursive_getters
      integer().check(minutosAntes.isBiggerThanValue(0))();
}
