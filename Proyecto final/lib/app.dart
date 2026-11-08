import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_material.dart';
import 'data/sync/estado_sync.dart';
import 'providers/providers.dart';
import 'screens/home_shell.dart';

/// TaskU · compromisos académicos bajo control (PDM 2026 · Equipo 05).
///
/// Necesita un `ProviderScope` arriba con la base (o los repositorios)
/// sobrescritos. Los parámetros de sesión son opcionales: sin ellos la app
/// funciona como antes del login (lo usan las pruebas y el escritorio).
class TaskUApp extends ConsumerWidget {
  const TaskUApp({
    super.key,
    this.correoUsuario,
    this.alCerrarSesion,
    this.estadoSync,
    this.alSincronizar,
  });

  final String? correoUsuario;
  final Future<void> Function()? alCerrarSesion;
  final ValueListenable<EstadoSync>? estadoSync;
  final Future<void> Function()? alSincronizar;

  @override
  Widget build(BuildContext context, WidgetRef ref) => taskuMaterialApp(
    home: HomeShell(
      courseRepository: ref.watch(courseRepositoryProvider),
      taskRepository: ref.watch(taskRepositoryProvider),
      settingsRepository: ref.watch(settingsRepositoryProvider),
      correoUsuario: correoUsuario,
      alCerrarSesion: alCerrarSesion,
      estadoSync: estadoSync,
      alSincronizar: alSincronizar,
    ),
  );
}
