import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movement_filter.dart';
import '../providers/movement_filter_provider.dart';
import '../providers/movements_provider.dart';
import '../widgets/movement_tile.dart';
import '../widgets/status_view.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  // Se crean una vez, fuera de build; IndexedStack mantiene este State.
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilter() {
    _searchController.clear();
    ref.read(movementFilterProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(movementFilterProvider);
    final movementsAsync = ref.watch(movementsProvider);
    final filteredAsync = ref.watch(filteredMovementsProvider);
    final total = movementsAsync.value?.length ?? 0;
    final countLabel = movementsAsync.when(
      loading: () => 'Cargando movimientos…',
      error: (error, stackTrace) => 'No se pudieron cargar los movimientos.',
      data: (_) => filter.isActive
          ? '${filteredAsync.value?.length ?? 0} de $total movimientos'
          : '$total movimientos de ejemplo',
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Historial',
            key: const ValueKey('history-heading'),
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(countLabel),
          const SizedBox(height: 12),
          _FilterBar(controller: _searchController),
          const SizedBox(height: 12),
          Expanded(
            child: filteredAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => StatusView(
                icon: Icons.error_outline,
                message:
                    'No pudimos cargar tus movimientos.\n'
                    'Inténtalo de nuevo.',
                actionLabel: 'Reintentar',
                onAction: () => ref.read(movementsProvider.notifier).reload(),
              ),
              data: (movements) {
                if (movements.isEmpty) {
                  return StatusView(
                    key: const ValueKey('history-empty'),
                    icon: Icons.filter_alt_off_outlined,
                    message: filter.isActive
                        ? 'No hay movimientos con este filtro.'
                        : 'Aún no hay movimientos.',
                    actionLabel: filter.isActive ? 'Limpiar filtro' : null,
                    onAction: filter.isActive ? _clearFilter : null,
                  );
                }
                return ListView.separated(
                  key: const PageStorageKey('history-list'),
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: movements.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final movement = movements[index];
                    return MovementTile(
                      key: ValueKey(movement.id),
                      movement: movement,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Búsqueda, categoría y mes. Cada cambio actualiza el filtro compartido.
class _FilterBar extends ConsumerWidget {
  const _FilterBar({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(movementFilterProvider);
    final categories = ref.watch(movementCategoriesProvider);
    final months = ref.watch(movementMonthsProvider);
    final notifier = ref.read(movementFilterProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: const ValueKey('filter-text'),
          controller: controller,
          onChanged: notifier.setText,
          decoration: const InputDecoration(
            isDense: true,
            hintText: 'Buscar por título o categoría',
            prefixIcon: Icon(Icons.search, size: 20),
          ),
        ),
        const SizedBox(height: 6),
        _ChipRow(
          children: [
            for (final category in categories)
              _FilterChip(
                key: ValueKey('filter-category-$category'),
                label: category,
                selected: filter.category == category,
                onTap: () => notifier.selectCategory(category),
              ),
          ],
        ),
        _ChipRow(
          children: [
            for (final month in months)
              _FilterChip(
                key: ValueKey('filter-month-$month'),
                label: monthLabel(month),
                selected: filter.month == month,
                onTap: () => notifier.selectMonth(month),
              ),
          ],
        ),
      ],
    );
  }
}

class _ChipRow extends StatelessWidget {
  const _ChipRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: children),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onSelected: (_) => onTap(),
      ),
    );
  }
}
