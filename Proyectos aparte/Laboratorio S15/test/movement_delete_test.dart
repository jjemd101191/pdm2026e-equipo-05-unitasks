import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio_s15/app/app.dart';
import 'package:laboratorio_s15/data/movement_repository.dart';
import 'package:laboratorio_s15/data/sample_movements.dart';
import 'package:laboratorio_s15/models/movement.dart';
import 'package:laboratorio_s15/providers/movements_provider.dart';
import 'package:laboratorio_s15/widgets/movement_tile.dart';

/// Repositorio que siempre falla al borrar, para comprobar que la fila vuelve.
class _FailingDeleteRepository implements MovementRepository {
  @override
  Future<List<Movement>> fetchMovements() async =>
      List<Movement>.of(sampleMovements);

  @override
  Future<void> deleteMovement(String id) async {
    throw StateError('fallo de almacenamiento');
  }

  @override
  Future<void> restoreMovement(Movement movement, {int? index}) async {}
}

Future<void> openHistory(
  WidgetTester tester, {
  MovementRepository? repository,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        if (repository != null)
          movementRepositoryProvider.overrideWithValue(repository),
      ],
      child: const FinanceApp(),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const ValueKey('nav-history')));
  await tester.pumpAndSettle();
}

Movement movementOf(WidgetTester tester, String id) => tester
    .widget<MovementTile>(
      find.descendant(
        of: find.byKey(ValueKey(id)),
        matching: find.byType(MovementTile),
      ),
    )
    .movement;

void main() {
  testWidgets('deslizar borra y Deshacer restaura el mismo id y datos', (
    tester,
  ) async {
    await openHistory(tester);
    final original = movementOf(tester, 'mov-001');

    await tester.drag(
      find.byKey(const ValueKey('mov-001')),
      const Offset(-600, 0),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('mov-001')), findsNothing);
    expect(find.text('Deshacer'), findsOneWidget);

    await tester.tap(find.text('Deshacer'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('mov-001')), findsOneWidget);
    final restored = movementOf(tester, 'mov-001');
    expect(restored.id, original.id);
    expect(restored.title, original.title);
    expect(restored.category, original.category);
    expect(restored.date, original.date);
    expect(restored.amountInCents, original.amountInCents);
  });

  testWidgets('si el repositorio falla al borrar, la fila sigue visible', (
    tester,
  ) async {
    await openHistory(tester, repository: _FailingDeleteRepository());

    await tester.drag(
      find.byKey(const ValueKey('mov-001')),
      const Offset(-600, 0),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('mov-001')), findsOneWidget);
    expect(find.text('No se pudo eliminar el movimiento.'), findsOneWidget);
    expect(find.text('Deshacer'), findsNothing);
  });
}
