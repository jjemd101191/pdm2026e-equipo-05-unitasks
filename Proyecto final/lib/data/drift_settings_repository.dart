import 'db/app_database.dart';
import 'settings_repository.dart';

/// Guarda el plan Premium en la base local, junto a los demás datos.
///
/// La clave incluye el uid cuando hay sesión, para que cada cuenta conserve
/// su propio plan en el mismo dispositivo. Sin sesión (o en pruebas) se usa
/// la clave histórica `premium_activo`.
class DriftSettingsRepository implements SettingsRepository {
  DriftSettingsRepository(this._db, {this.usuarioId = ''});

  final AppDatabase _db;
  final String usuarioId;

  String get _clavePremium =>
      usuarioId.isEmpty ? 'premium_activo' : 'premium_activo:$usuarioId';

  @override
  Future<bool> esPremium() async =>
      await _db.ajustesDao.leer(_clavePremium) == 'true';

  @override
  Future<void> activarPremium() =>
      _db.ajustesDao.escribir(_clavePremium, 'true');

  @override
  Future<void> desactivarPremium() => _db.ajustesDao.borrar(_clavePremium);
}
