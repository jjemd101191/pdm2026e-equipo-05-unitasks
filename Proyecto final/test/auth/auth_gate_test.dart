import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_equipo_05_unitasks/app.dart';
import 'package:pdm2026e_equipo_05_unitasks/auth/auth_gate.dart';
import 'package:pdm2026e_equipo_05_unitasks/auth/proveedores_auth.dart';
import 'package:pdm2026e_equipo_05_unitasks/auth/usuario_app.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/db/app_database.dart';
import 'package:pdm2026e_equipo_05_unitasks/providers/providers.dart';
import 'package:pdm2026e_equipo_05_unitasks/screens/login_screen.dart';

import '../support/fake_autenticacion.dart';
import '../support/remoto_sync_memoria.dart';

void main() {
  testWidgets('sin sesión muestra el login y con sesión monta la app', (
    tester,
  ) async {
    final auth = FakeAutenticacion();
    final db = AppDatabase(NativeDatabase.memory());
    final remoto = RemotoSyncMemoria();
    addTearDown(() async {
      await auth.cerrar();
      await remoto.cerrar();
      await db.close();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          autenticacionProvider.overrideWithValue(auth),
          remotoSyncProvider.overrideWithValue(remoto),
          sincronizadorProvider.overrideWithValue(
            SincronizadorInactivo(db: db, remoto: remoto, usuarioId: 'uid-1'),
          ),
        ],
        child: const AuthGate(),
      ),
    );
    await tester.pump();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(TaskUApp), findsNothing);

    await auth.iniciarSesion('ana@ejemplo.com', 'secreto1');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(TaskUApp), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('cerrar sesión vuelve al login', (tester) async {
    final auth = FakeAutenticacion(
      usuario: const UsuarioApp(uid: 'uid-1', correo: 'ana@ejemplo.com'),
    );
    final db = AppDatabase(NativeDatabase.memory());
    final remoto = RemotoSyncMemoria();
    addTearDown(() async {
      await auth.cerrar();
      await remoto.cerrar();
      await db.close();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          autenticacionProvider.overrideWithValue(auth),
          remotoSyncProvider.overrideWithValue(remoto),
          sincronizadorProvider.overrideWithValue(
            SincronizadorInactivo(db: db, remoto: remoto, usuarioId: 'uid-1'),
          ),
        ],
        child: const AuthGate(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(TaskUApp), findsOneWidget);

    await auth.cerrarSesion();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
