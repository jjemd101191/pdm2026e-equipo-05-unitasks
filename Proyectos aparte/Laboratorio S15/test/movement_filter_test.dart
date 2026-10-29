import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio_s15/app/app.dart';

Future<void> openHistory(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(const ProviderScope(child: FinanceApp()));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const ValueKey('nav-history')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('cambiar el filtro actualiza el listado sin recargar', (
    tester,
  ) async {
    await openHistory(tester);
    expect(find.byKey(const ValueKey('mov-001')), findsOneWidget);
    expect(find.byKey(const ValueKey('mov-002')), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('filter-category-Alimentación')),
    );
    await tester.pumpAndSettle();

    // Solo quedan los movimientos de Alimentación; mov-002 es Movilidad.
    expect(find.byKey(const ValueKey('mov-001')), findsOneWidget);
    expect(find.byKey(const ValueKey('mov-002')), findsNothing);
    expect(find.textContaining('de 48 movimientos'), findsOneWidget);
  });

  testWidgets('un filtro sin resultados muestra el estado vacío', (
    tester,
  ) async {
    await openHistory(tester);

    await tester.enterText(find.byKey(const ValueKey('filter-text')), 'zzzz');
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('history-empty')), findsOneWidget);
    expect(find.text('No hay movimientos con este filtro.'), findsOneWidget);

    await tester.tap(find.text('Limpiar filtro'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('history-empty')), findsNothing);
    expect(find.byKey(const ValueKey('mov-001')), findsOneWidget);
  });
}
