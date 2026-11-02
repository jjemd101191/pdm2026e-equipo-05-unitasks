import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/db/app_database.dart';
import 'data/seed_data.dart';
import 'providers/providers.dart';
import 'screens/home_shell.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TaskUStartup());
}

/// Conserva la apertura y migración existentes; permite reintentarlas sin borrar datos.
class TaskUStartup extends StatefulWidget {
  const TaskUStartup({super.key, this.crearBase});
  final AppDatabase Function()? crearBase;

  @override
  State<TaskUStartup> createState() => _TaskUStartupState();
}

class _TaskUStartupState extends State<TaskUStartup> {
  late Future<AppDatabase> _apertura = _abrir();
  AppDatabase? _base;

  Future<AppDatabase> _abrir() async {
    AppDatabase? db;
    try {
      db =
          widget.crearBase?.call() ??
          AppDatabase.abrir(alCrear: sembrarDatosIniciales);
      await db.verificar();
      if (mounted) {
        _base = db;
      } else {
        await db.close();
      }
      return db;
    } catch (_) {
      try {
        await db?.close();
      } catch (_) {
        /* La conexión ya falló al abrir. */
      }
      rethrow;
    }
  }

  Future<void> _reintentar() async {
    setState(() {
      _apertura = _abrir();
      // FutureBuilder se suscribe en el siguiente frame; el fallo puede ser inmediato.
      _apertura.ignore();
    });
  }

  @override
  void dispose() {
    _base?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<AppDatabase>(
    future: _apertura,
    builder: (context, estado) {
      if (estado.hasError) return _ArranqueFallido(onReintentar: _reintentar);
      if (estado.hasData) {
        return ProviderScope(
          overrides: [databaseProvider.overrideWithValue(estado.requireData)],
          child: const TaskUApp(),
        );
      }
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildTaskuTheme(),
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              semanticsLabel: 'Abriendo tus datos',
            ),
          ),
        ),
      );
    },
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
class _ArranqueFallido extends StatefulWidget {
  const _ArranqueFallido({required this.onReintentar});
  final Future<void> Function() onReintentar;

  @override
  State<_ArranqueFallido> createState() => _ArranqueFallidoState();
}

class _ArranqueFallidoState extends State<_ArranqueFallido> {
  bool _reintentando = false;

  Future<void> _reintentar() async {
    if (_reintentando) return;
    setState(() => _reintentando = true);
    try {
      await widget.onReintentar();
    } finally {
      if (mounted) setState(() => _reintentando = false);
    }
  }

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
                  'Reintenta abrir tus datos. Si el problema continúa, '
                  'revisa el espacio libre del dispositivo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: kMuted, height: 1.5),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: _reintentando ? null : _reintentar,
                  icon: const Icon(Icons.refresh),
                  label: Text(_reintentando ? 'Reintentando…' : 'Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
