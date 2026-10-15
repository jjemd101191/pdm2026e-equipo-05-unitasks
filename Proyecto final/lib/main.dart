import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/home_shell.dart';
import 'theme.dart';

void main() => runApp(const TaskUApp());

/// TaskU · compromisos académicos bajo control (PDM 2026 · Equipo 05).
///
/// Punto de entrada de demostración del módulo de pantallas 4:
/// 4A detalle de tarea, 4B gestión de cursos y 4C formulario de curso.
/// Sustituye al contador de ejemplo que genera `flutter create`.
class TaskUApp extends StatelessWidget {
  const TaskUApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskU',
      debugShowCheckedModeBanner: false,
      theme: buildTaskuTheme(),
      locale: const Locale('es'),
      supportedLocales: const [Locale('es')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const HomeShell(),
    );
  }
}
