import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movement.dart';
import '../models/movement_filter.dart';
import 'movements_provider.dart';

class MovementFilterNotifier extends Notifier<MovementFilter> {
  @override
  MovementFilter build() => const MovementFilter();

  void selectCategory(String category) {
    if (state.category == category) return;
    state = state.copyWith(category: category);
  }

  void selectMonth(String month) {
    if (state.month == month) return;
    state = state.copyWith(month: month);
  }

  void setText(String text) {
    if (state.text == text) return;
    state = state.copyWith(text: text);
  }

  void clear() => state = const MovementFilter();
}

final movementFilterProvider =
    NotifierProvider<MovementFilterNotifier, MovementFilter>(
      MovementFilterNotifier.new,
    );

/// Provider dependiente: observa el filtro y la fuente de movimientos.
/// Al cambiar cualquiera de los dos, la lista se vuelve a calcular sola.
final filteredMovementsProvider = Provider<AsyncValue<List<Movement>>>((ref) {
  final filter = ref.watch(movementFilterProvider);
  return ref
      .watch(movementsProvider)
      .whenData(
        (movements) => movements.where(filter.accepts).toList(growable: false),
      );
});

/// Categorías presentes en los datos, precedidas por «Todas».
final movementCategoriesProvider = Provider<List<String>>((ref) {
  final movements = ref.watch(movementsProvider).value ?? const <Movement>[];
  final categories =
      movements.map((movement) => movement.category).toSet().toList()..sort();
  return [MovementFilter.allCategories, ...categories];
});

/// Meses presentes en los datos, del más reciente al más antiguo.
final movementMonthsProvider = Provider<List<String>>((ref) {
  final movements = ref.watch(movementsProvider).value ?? const <Movement>[];
  final months =
      movements.map((movement) => monthKey(movement.date)).toSet().toList()
        ..sort((a, b) => b.compareTo(a));
  return [MovementFilter.allMonths, ...months];
});
