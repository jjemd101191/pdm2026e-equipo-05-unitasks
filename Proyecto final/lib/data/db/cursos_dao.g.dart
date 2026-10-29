// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cursos_dao.dart';

// ignore_for_file: type=lint
mixin _$CursosDaoMixin on DatabaseAccessor<AppDatabase> {
  $CoursesTable get courses => attachedDatabase.courses;
  $TasksTable get tasks => attachedDatabase.tasks;
  CursosDaoManager get managers => CursosDaoManager(this);
}

class CursosDaoManager {
  final _$CursosDaoMixin _db;
  CursosDaoManager(this._db);
  $$CoursesTableTableManager get courses =>
      $$CoursesTableTableManager(_db.attachedDatabase, _db.courses);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db.attachedDatabase, _db.tasks);
}
