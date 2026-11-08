import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdm2026e_equipo_05_unitasks/providers/providers.dart';
import 'support/fakes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/db/app_database.dart';
import 'package:pdm2026e_equipo_05_unitasks/main.dart';

class BaseFallida extends AppDatabase {
  BaseFallida() : super(NativeDatabase.memory());
  bool cerrada = false;
  @override
  Future<void> verificar() async => throw StateError('fallo de prueba');
  @override
  Future<void> close() async {
    cerrada = true;
  }
}

class BaseLista extends BaseFallida {
  @override
  Future<void> verificar() async {}
}

void main() {
  testWidgets(
    'arranque falla, cierra conexión fallida y reintenta con base nueva',
    (tester) async {
      final fallida = BaseFallida();
      final correcta = BaseLista();

      var intentos = 0;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            courseRepositoryProvider.overrideWithValue(CursoRepoMemoria()),
            taskRepositoryProvider.overrideWithValue(TareaRepoMemoria()),
            settingsRepositoryProvider.overrideWithValue(AjustesRepoMemoria()),
          ],
          child: TaskUStartup(
            crearBase: () => ++intentos == 1 ? fallida : correcta,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(fallida.cerrada, isTrue);
      expect(find.text('No pudimos abrir tus datos locales.'), findsOneWidget);
      expect(find.text('Reintentar'), findsOneWidget);
      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();
      expect(intentos, 2);
      expect(find.byType(TaskUApp), findsOneWidget);
      expect(find.text('No pudimos abrir tus datos locales.'), findsNothing);
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets('fallo al crear conexión también permite otro intento', (
    tester,
  ) async {
    var intentos = 0;
    await tester.pumpWidget(
      TaskUStartup(
        crearBase: () {
          intentos++;
          throw StateError('fallo de fábrica');
        },
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(intentos, 2);
    expect(find.text('Reintentar'), findsOneWidget);
  });
}
