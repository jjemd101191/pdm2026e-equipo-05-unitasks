import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/movements_provider.dart';
import '../providers/navigation_provider.dart';
import '../widgets/movement_tile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movementsAsync = ref.watch(movementsProvider);
    return ListView(
      key: const PageStorageKey('home-scroll'),
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Tu dinero, a la vista',
          key: const ValueKey('home-heading'),
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text('Un pequeño vistazo a tus finanzas.'),
        const SizedBox(height: 24),
        Card(
          color: Theme.of(context).colorScheme.primary,
          child: const Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BALANCE DE EJEMPLO',
                  style: TextStyle(color: Colors.white70, letterSpacing: 1.2),
                ),
                SizedBox(height: 12),
                Text(
                  'Q 4,250.00',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Datos de demostración · Octubre 2026',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Text(
                'Últimos movimientos',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              key: const ValueKey('view-all'),
              // Modifica el mismo estado que utiliza la barra inferior.
              onPressed: () => ref
                  .read(navigationProvider.notifier)
                  .selectTab(AppTab.history),
              child: const Text('Ver todo'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          child: movementsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stackTrace) => const Padding(
              padding: EdgeInsets.all(20),
              child: Text('No se pudieron cargar los movimientos.'),
            ),
            data: (movements) => Column(
              children: [
                for (final movement in movements.take(3))
                  MovementTile(
                    key: ValueKey('home-${movement.id}'),
                    movement: movement,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
