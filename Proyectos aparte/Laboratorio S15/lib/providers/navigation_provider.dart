import 'package:flutter_riverpod/flutter_riverpod.dart';

// Este orden coincide con el IndexedStack y la barra inferior.
enum AppTab { home, budget, history, settings }

class NavigationNotifier extends Notifier<AppTab> {
  @override
  AppTab build() => AppTab.home;

  void selectTab(AppTab tab) {
    state = tab;
  }
}

final navigationProvider = NotifierProvider<NavigationNotifier, AppTab>(
  NavigationNotifier.new,
);
