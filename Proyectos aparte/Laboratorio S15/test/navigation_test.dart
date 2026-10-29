import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio_s15/app/app.dart';
import 'package:laboratorio_s15/providers/navigation_provider.dart';

Future<void> openApp(WidgetTester tester, {double width = 390}) async {
  tester.view.physicalSize = Size(width, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const ProviderScope(child: FinanceApp()));
  await tester.pumpAndSettle();
}

ProviderContainer appContainer(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(FinanceApp)));

void expectActiveTab(WidgetTester tester, AppTab tab) {
  // Contrasta el estado real con la barra y la pantalla seleccionada.
  expect(appContainer(tester).read(navigationProvider), tab);
  expect(
    tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
    tab.index,
  );
  expect(
    tester.widget<IndexedStack>(find.byType(IndexedStack)).index,
    tab.index,
  );
}

Future<void> selectTab(WidgetTester tester, String name) async {
  await tester.tap(find.byKey(ValueKey('nav-$name')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Las cuatro pestañas cambian la pantalla y la selección', (
    tester,
  ) async {
    await openApp(tester);
    expect(find.byKey(const ValueKey('home-heading')), findsOneWidget);
    expectActiveTab(tester, AppTab.home);

    await selectTab(tester, 'budget');
    expect(
      find.byKey(const ValueKey('coming-soon-Presupuesto')),
      findsOneWidget,
    );
    expect(find.text('Próximamente'), findsOneWidget);
    expect(find.byKey(const ValueKey('home-heading')), findsNothing);
    expectActiveTab(tester, AppTab.budget);

    await selectTab(tester, 'history');
    expect(find.byKey(const ValueKey('history-heading')), findsOneWidget);
    expect(find.byKey(const ValueKey('mov-001')), findsOneWidget);
    expectActiveTab(tester, AppTab.history);

    await selectTab(tester, 'settings');
    expect(find.byKey(const ValueKey('coming-soon-Ajustes')), findsOneWidget);
    expect(find.text('Próximamente'), findsOneWidget);
    expectActiveTab(tester, AppTab.settings);

    await selectTab(tester, 'home');
    expect(find.byKey(const ValueKey('home-heading')), findsOneWidget);
    expectActiveTab(tester, AppTab.home);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Ver todo selecciona Historial sin apilar otra ruta', (
    tester,
  ) async {
    await openApp(tester);
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    await tester.tap(find.byKey(const ValueKey('view-all')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('history-heading')), findsOneWidget);
    expect(find.byKey(const ValueKey('mov-001')), findsOneWidget);
    expectActiveTab(tester, AppTab.history);
    expect(navigator.canPop(), isFalse);
  });

  testWidgets('Historial conserva el scroll al volver por barra y Ver todo', (
    tester,
  ) async {
    await openApp(tester);
    await selectTab(tester, 'history');
    final list = find.byKey(const PageStorageKey('history-list'));
    final scrollable = find.descendant(
      of: list,
      matching: find.byType(Scrollable),
    );
    await tester.drag(list, const Offset(0, -1400));
    await tester.pumpAndSettle();
    final state = tester.state<ScrollableState>(scrollable);
    final offset = state.position.pixels;
    expect(offset, greaterThan(500));
    expect(find.byKey(const ValueKey('mov-001')), findsNothing);

    // También recorremos las pantallas pendientes: todas deben conservar el State.
    for (final tab in ['budget', 'settings', 'home']) {
      await selectTab(tester, tab);
      await selectTab(tester, 'history');
      expect(tester.state<ScrollableState>(scrollable), same(state));
      expect(state.position.pixels, offset);
      expectActiveTab(tester, AppTab.history);
    }

    await selectTab(tester, 'home');
    await tester.tap(find.byKey(const ValueKey('view-all')));
    await tester.pumpAndSettle();
    expect(tester.state<ScrollableState>(scrollable), same(state));
    expect(state.position.pixels, offset);
    expectActiveTab(tester, AppTab.history);
    expect(tester.takeException(), isNull);
  });

  testWidgets('La interfaz reacciona al provider sin pulsar la barra', (
    tester,
  ) async {
    await openApp(tester);
    final container = appContainer(tester);
    const headings = {
      AppTab.home: 'home-heading',
      AppTab.budget: 'coming-soon-Presupuesto',
      AppTab.history: 'history-heading',
      AppTab.settings: 'coming-soon-Ajustes',
    };

    for (final tab in AppTab.values.reversed) {
      container.read(navigationProvider.notifier).selectTab(tab);
      await tester.pumpAndSettle();
      expectActiveTab(tester, tab);
      expect(find.byKey(ValueKey(headings[tab]!)), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('La interfaz funciona en un móvil de 320 píxeles', (
    tester,
  ) async {
    await openApp(tester, width: 320);
    expect(tester.takeException(), isNull);
    for (final tab in ['budget', 'history', 'settings', 'home']) {
      await selectTab(tester, tab);
      expect(tester.takeException(), isNull);
    }
  });
}
