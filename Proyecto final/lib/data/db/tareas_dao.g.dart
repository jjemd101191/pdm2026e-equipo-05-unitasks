// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tareas_dao.dart';

// ignore_for_file: type=lint
mixin _$TareasDaoMixin on DatabaseAccessor<AppDatabase> {
  $CoursesTable get courses => attachedDatabase.courses;
  $TasksTable get tasks => attachedDatabase.tasks;
  $SubtasksTable get subtasks => attachedDatabase.subtasks;
  $RemindersTable get reminders => attachedDatabase.reminders;
  TareasDaoManager get managers => TareasDaoManager(this);
}

class TareasDaoManager {
  final _$TareasDaoMixin _db;
  TareasDaoManager(this._db);
  $$CoursesTableTableManager get courses =>
      $$CoursesTableTableManager(_db.attachedDatabase, _db.courses);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db.attachedDatabase, _db.tasks);
  $$SubtasksTableTableManager get subtasks =>
      $$SubtasksTableTableManager(_db.attachedDatabase, _db.subtasks);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db.attachedDatabase, _db.reminders);
}
