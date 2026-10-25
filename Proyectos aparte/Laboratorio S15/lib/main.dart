import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';

void main() {
  // ProviderScope habilita Riverpod en toda la aplicación.
  runApp(const ProviderScope(child: FinanceApp()));
}
