import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/navigation_provider.dart';

class AppBottomNavigation extends ConsumerWidget {
  const AppBottomNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(navigationProvider);
    return NavigationBar(
      selectedIndex: selected.index,
      onDestinationSelected: (index) =>
          ref.read(navigationProvider.notifier).selectTab(AppTab.values[index]),
      destinations: const [
        NavigationDestination(
          key: ValueKey('nav-home'),
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Inicio',
        ),
        NavigationDestination(
          key: ValueKey('nav-budget'),
          icon: Icon(Icons.pie_chart_outline),
          selectedIcon: Icon(Icons.pie_chart),
          label: 'Presupuesto',
        ),
        NavigationDestination(
          key: ValueKey('nav-history'),
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long),
          label: 'Historial',
        ),
        NavigationDestination(
          key: ValueKey('nav-settings'),
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Ajustes',
        ),
      ],
    );
  }
}
