// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ajustes_dao.dart';

// ignore_for_file: type=lint
mixin _$AjustesDaoMixin on DatabaseAccessor<AppDatabase> {
  $AppSettingsTable get appSettings => attachedDatabase.appSettings;
  AjustesDaoManager get managers => AjustesDaoManager(this);
}

class AjustesDaoManager {
  final _$AjustesDaoMixin _db;
  AjustesDaoManager(this._db);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db.attachedDatabase, _db.appSettings);
}
