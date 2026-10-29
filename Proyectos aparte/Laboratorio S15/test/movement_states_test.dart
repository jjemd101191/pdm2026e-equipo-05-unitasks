import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio_s15/app/app.dart';
import 'package:laboratorio_s15/data/movement_repository.dart';
import 'package:laboratorio_s15/data/sample_movements.dart';
import 'package:laboratorio_s15/models/movement.dart';
import 'package:laboratorio_s15/providers/movements_provider.dart';

/// Falla la primera consulta y responde bien en el reintento.
class _FailingOnceRepository implements MovementRepository {
  int calls = 0;

  @override
  Future<List<Movement>> fetchMovements() async {
    calls++;
    if (calls == 1) throw StateError('sin conexión');
    return sampleMovements.take(5).toList();
  }

  @override
  Future<void> deleteMovement(String id) async {}

  @override
  Future<void> restoreMovement(Movement movement, {int? index}) async {}
}

Future<void> openHistory(
  WidgetTester tester,
  MovementRepository repository,
) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [movementRepositoryProvider.overrideWithValue(repository)],
      child: const FinanceApp(),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const ValueKey('nav-history')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('el listado muestra el error y Reintentar recupera los datos', (
    tester,
  ) async {
    await openHistory(tester, _FailingOnceRepository());

    expect(find.text('Reintentar'), findsOneWidget);
    expect(find.byKey(const ValueKey('mov-001')), findsNothing);

    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();

    expect(find.text('Reintentar'), findsNothing);
    expect(find.byKey(const ValueKey('mov-001')), findsOneWidget);
  });
}
