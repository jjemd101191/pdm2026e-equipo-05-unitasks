import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/db/app_database.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/drift_settings_repository.dart';

void main() {
  test('el plan Premium persiste en la base local', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final ajustes = DriftSettingsRepository(db);

    expect(await ajustes.esPremium(), isFalse);

    await ajustes.activarPremium();
    expect(await ajustes.esPremium(), isTrue);

    await ajustes.desactivarPremium();
    expect(await ajustes.esPremium(), isFalse);
  });
}
