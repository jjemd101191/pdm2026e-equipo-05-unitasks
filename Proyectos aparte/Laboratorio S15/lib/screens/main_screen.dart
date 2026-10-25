import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/navigation_provider.dart';
import '../widgets/app_bottom_navigation.dart';
import 'coming_soon_screen.dart';
import 'history_screen.dart';
import 'home_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(navigationProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.account_balance_wallet_outlined),
            SizedBox(width: 10),
            Text('Mi bolsillo', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            // Las pantallas siguen montadas y conservan su estado.
            child: IndexedStack(
              index: activeTab.index,
              children: const [
                HomeScreen(),
                ComingSoonScreen(
                  title: 'Presupuesto',
                  icon: Icons.pie_chart_outline,
                ),
                HistoryScreen(),
                ComingSoonScreen(
                  title: 'Ajustes',
                  icon: Icons.settings_outlined,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(),
    );
  }
}
