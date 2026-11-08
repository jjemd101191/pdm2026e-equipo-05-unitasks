import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app.dart';
import '../app_material.dart';
import '../data/sync/sincronizador.dart';
import '../providers/providers.dart';
import '../screens/login_screen.dart';
import 'proveedores_auth.dart';
import 'usuario_app.dart';

/// Decide qué se ve según la sesión de Firebase.
///
/// Sin sesión: login. Con sesión: crea un `ProviderScope` por usuario (así
/// ningún provider conserva datos de la cuenta anterior) y monta la app.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sesion = ref.watch(usuarioProvider);
    return sesion.when(
      loading: () => taskuMaterialApp(home: const _CargandoSesion()),
      error: (_, _) => taskuMaterialApp(
        home: _ErrorSesion(onReintentar: () => ref.invalidate(usuarioProvider)),
      ),
      data: (usuario) {
        if (usuario == null) return taskuMaterialApp(home: const LoginScreen());
        return ProviderScope(
          key: ValueKey(usuario.uid),
          overrides: [usuarioIdProvider.overrideWithValue(usuario.uid)],
          child: _SesionIniciada(usuario: usuario),
        );
      },
    );
  }
}

class _CargandoSesion extends StatelessWidget {
  const _CargandoSesion();

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: CircularProgressIndicator(semanticsLabel: 'Comprobando la sesión'),
    ),
  );
}

class _ErrorSesion extends StatelessWidget {
  const _ErrorSesion({required this.onReintentar});

  final VoidCallback onReintentar;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 48),
            const SizedBox(height: 16),
            const Text(
              'No se pudo comprobar la sesión.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onReintentar,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Arranca la sincronización de la cuenta y monta la app. La nube no bloquea:
/// si falla, se sigue usando la copia local.
class _SesionIniciada extends ConsumerStatefulWidget {
  const _SesionIniciada({required this.usuario});

  final UsuarioApp usuario;

  @override
  ConsumerState<_SesionIniciada> createState() => _SesionIniciadaState();
}

class _SesionIniciadaState extends ConsumerState<_SesionIniciada> {
  late final Sincronizador _sincronizador;

  @override
  void initState() {
    super.initState();
    _sincronizador = ref.read(sincronizadorProvider);
    unawaited(_sincronizador.iniciar());
  }

  @override
  void dispose() {
    unawaited(_sincronizador.detener());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TaskUApp(
    correoUsuario: widget.usuario.correo,
    alCerrarSesion: () => ref.read(autenticacionProvider).cerrarSesion(),
    estadoSync: _sincronizador.estado,
    alSincronizar: _sincronizador.sincronizarAhora,
  );
}
