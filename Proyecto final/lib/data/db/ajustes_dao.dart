import 'package:drift/drift.dart';

import 'app_database.dart';
import 'tablas.dart';

part 'ajustes_dao.g.dart';

/// Consultas sobre la tabla `app_settings` (preferencias clave-valor).
@DriftAccessor(tables: [AppSettings])
class AjustesDao extends DatabaseAccessor<AppDatabase> with _$AjustesDaoMixin {
  AjustesDao(super.attachedDatabase);

  Future<String?> leer(String clave) async {
    final fila = await (select(
      appSettings,
    )..where((tabla) => tabla.clave.equals(clave))).getSingleOrNull();
    return fila?.valor;
  }

  Future<void> escribir(String clave, String valor) async {
    await into(appSettings).insertOnConflictUpdate(
      AppSettingsCompanion.insert(clave: clave, valor: valor),
    );
  }

  Future<void> borrar(String clave) async {
    await (delete(
      appSettings,
    )..where((tabla) => tabla.clave.equals(clave))).go();
  }
}
