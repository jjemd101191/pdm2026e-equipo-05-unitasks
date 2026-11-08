import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_equipo_05_unitasks/auth/auth_gate.dart';
import 'package:pdm2026e_equipo_05_unitasks/auth/proveedores_auth.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/db/app_database.dart';
import 'package:pdm2026e_equipo_05_unitasks/main.dart';
import 'package:pdm2026e_equipo_05_unitasks/providers/providers.dart';
import 'package:pdm2026e_equipo_05_unitasks/screens/login_screen.dart';

import '../support/fake_autenticacion.dart';
import '../support/remoto_sync_memoria.dart';

void main() {
  testWidgets('el arranque real conserva la base al pasar del login a la app', (
    tester,
  ) async {
    final auth = FakeAutenticacion();
    final db = AppDatabase(NativeDatabase.memory());
    final remoto = RemotoSyncMemoria();
    addTearDown(() async {
      await Future<void>.delayed(const Duration(milliseconds: 80));
      await auth.cerrar();
      await remoto.cerrar();
      await db.close();
    });

    // Igual que main(): base, autenticación y nube en un solo scope.
    await tester.pumpWidget(
      TaskUStartup(
        crearBase: () => db,
        construirApp: (base) => ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(base),
            autenticacionProvider.overrideWithValue(auth),
            remotoSyncProvider.overrideWithValue(remoto),
          ],
          child: const AuthGate(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(LoginScreen), findsOneWidget);

    await auth.iniciarSesion('ana@ejemplo.com', 'secreto1');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(tester.takeException(), isNull);
  });
}
