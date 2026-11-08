import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ads/anuncios.dart';
import 'app.dart';
import 'app_material.dart';
import 'auth/auth_gate.dart';
import 'auth/proveedores_auth.dart';
import 'auth/servicio_autenticacion_firebase.dart';
import 'data/db/app_database.dart';
import 'data/seed_data.dart';
import 'data/sync/firestore_remoto_sync.dart';
import 'firebase_options.dart';
import 'providers/providers.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Precarga el intersticial en Android/iOS; en web/escritorio no hace nada.
  Anuncios.preparar();

  // En escritorio no hay soporte de Firebase: la app sigue siendo local.
  if (!_firebaseSoportado) {
    runApp(const TaskUStartup());
    return;
  }

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error) {
    runApp(TaskUStartup(app: _FirebaseNoDisponible(detalle: '$error')));
    return;
  }

  runApp(
    ProviderScope(
      overrides: [
        autenticacionProvider.overrideWithValue(
          ServicioAutenticacionFirebase(),
        ),
        remotoSyncProvider.overrideWithValue(FirestoreRemotoSync()),
      ],
      child: const TaskUStartup(app: AuthGate()),
    ),
  );
}

/// Firebase Auth y Firestore solo existen en web, Android e iOS.
bool get _firebaseSoportado =>
    kIsWeb ||
    defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS;

/// Conserva la apertura y migración existentes; permite reintentarlas sin borrar datos.
class TaskUStartup extends StatefulWidget {
  const TaskUStartup({super.key, this.crearBase, this.app = const TaskUApp()});

  final AppDatabase Function()? crearBase;

  /// Qué montar cuando la base está lista. En producción es `AuthGate`.
  final Widget app;

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
          child: widget.app,
        );
      }
      return taskuMaterialApp(
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

/// Si Firebase no arranca (por ejemplo, configuración incompleta), se explica
/// sin dejar la pantalla en blanco.
class _FirebaseNoDisponible extends StatelessWidget {
  const _FirebaseNoDisponible({required this.detalle});

  final String detalle;

  @override
  Widget build(BuildContext context) => taskuMaterialApp(
    home: Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_outlined, size: 48),
              const SizedBox(height: 14),
              const Text(
                'No pudimos conectar con Firebase.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                detalle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
