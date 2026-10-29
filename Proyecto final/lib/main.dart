import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/db/app_database.dart';
import 'data/seed_data.dart';
import 'providers/providers.dart';
import 'screens/home_shell.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase.abrir(alCrear: sembrarDatosIniciales);
  try {
    await db.verificar();
  } catch (error, stackTrace) {
    debugPrint('No se pudo abrir la base local: $error');
    debugPrintStack(stackTrace: stackTrace);
    runApp(const _ArranqueFallido());
    return;
  }
  runApp(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const TaskUApp(),
    ),
  );
}

/// TaskU · compromisos académicos bajo control (PDM 2026 · Equipo 05).
///
/// Necesita un [ProviderScope] arriba con la base (o los repositorios)
/// sobrescritos.
class TaskUApp extends ConsumerWidget {
  const TaskUApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      // TODO(integrante-3): cuando las pantallas lean los providers
      // directamente, HomeShell ya no necesita recibir los repositorios.
      home: HomeShell(
        courseRepository: ref.watch(courseRepositoryProvider),
        taskRepository: ref.watch(taskRepositoryProvider),
      ),
    );
  }
}

/// Pantalla mínima si la base local no se puede abrir al arrancar.
class _ArranqueFallido extends StatelessWidget {
  const _ArranqueFallido();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildTaskuTheme(),
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.storage_outlined,
                  size: 48,
                  color: Color(0xFFCBD5E1),
                ),
                const SizedBox(height: 14),
                const Text(
                  'No pudimos abrir tus datos locales.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: kInk,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Cierra y vuelve a abrir TaskU. Si el problema continúa, '
                  'revisa el espacio libre del dispositivo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: kMuted, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
