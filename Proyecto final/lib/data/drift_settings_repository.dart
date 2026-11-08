import 'db/app_database.dart';
import 'settings_repository.dart';

/// Guarda el plan Premium en la base local, junto a los demás datos.
class DriftSettingsRepository implements SettingsRepository {
  DriftSettingsRepository(this._db);

  final AppDatabase _db;

  static const _clavePremium = 'premium_activo';

  @override
  Future<bool> esPremium() async =>
      await _db.ajustesDao.leer(_clavePremium) == 'true';

  @override
  Future<void> activarPremium() =>
      _db.ajustesDao.escribir(_clavePremium, 'true');

  @override
  Future<void> desactivarPremium() => _db.ajustesDao.borrar(_clavePremium);
}
