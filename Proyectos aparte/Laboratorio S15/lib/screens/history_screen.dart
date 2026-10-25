import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/movements_provider.dart';
import '../widgets/movement_tile.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  // Se crea una vez, fuera de build; IndexedStack mantiene este State.
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movements = ref.watch(movementsProvider);
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
          Text('${movements.length} movimientos de ejemplo'),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              key: const PageStorageKey('history-list'),
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: movements.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final movement = movements[index];
                return MovementTile(
                  key: ValueKey(movement.id),
                  movement: movement,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
