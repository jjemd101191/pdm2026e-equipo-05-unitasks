import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../data/course_repository.dart';
import '../data/settings_repository.dart';
import '../data/sync/estado_sync.dart';
import '../data/task_repository.dart';
import 'calendar_screen.dart';
import 'course_list_screen.dart';
import 'profile_screen.dart';
import 'task_list_screen.dart';

/// Esqueleto de la app con las cuatro pestañas principales del mockup.
///
/// Cada pestaña se construye al seleccionarla, de modo que vuelve a leer la
/// base local y refleja los cambios hechos en las demás (por ejemplo, una
/// tarea nueva actualiza los pendientes de Cursos).
class HomeShell extends StatefulWidget {
  const HomeShell({
    super.key,
    required this.courseRepository,
    required this.taskRepository,
    required this.settingsRepository,
    this.correoUsuario,
    this.alCerrarSesion,
    this.estadoSync,
    this.alSincronizar,
  });

  final CourseRepository courseRepository;
  final TaskRepository taskRepository;
  final SettingsRepository settingsRepository;

  /// Datos de la sesión; sin ellos la pestaña Perfil muestra «Perfil local».
  final String? correoUsuario;
  final Future<void> Function()? alCerrarSesion;
  final ValueListenable<EstadoSync>? estadoSync;
  final Future<void> Function()? alSincronizar;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _indice = 0;

  /// Cambia cada vez que termina una pasada de sincronización; forma parte
  /// de la key de la pestaña para que su `State` se recree y vuelva a leer
  /// la base (si no, Flutter reutiliza el State y no recarga).
  int _revisionSync = 0;

  @override
  void initState() {
    super.initState();
    // Cuando la sincronización cambia de estado (por ejemplo, al terminar de
    // bajar o sembrar), se reconstruye la pestaña para que muestre los datos
    // nuevos sin que el usuario tenga que cambiar de pestaña.
    widget.estadoSync?.addListener(_alCambiarSincronizacion);
  }

  @override
  void didUpdateWidget(HomeShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.estadoSync != widget.estadoSync) {
      oldWidget.estadoSync?.removeListener(_alCambiarSincronizacion);
      widget.estadoSync?.addListener(_alCambiarSincronizacion);
    }
  }

  @override
  void dispose() {
    widget.estadoSync?.removeListener(_alCambiarSincronizacion);
    super.dispose();
  }

  void _alCambiarSincronizacion() {
    // Solo al terminar: recargar al empezar borraría lo que el usuario está
    // escribiendo en la búsqueda durante un «Sincronizar» manual.
    if (!mounted || widget.estadoSync?.value != EstadoSync.alDia) return;
    setState(() => _revisionSync++);
  }

  Widget _pantallaActual() => switch (_indice) {
    0 => TaskListScreen(
      repositorio: widget.taskRepository,
      cursosRepositorio: widget.courseRepository,
      ajustes: widget.settingsRepository,
    ),
    1 => CalendarScreen(
      repositorio: widget.taskRepository,
      cursosRepositorio: widget.courseRepository,
      ajustes: widget.settingsRepository,
    ),
    2 => CourseListScreen(
      repositorio: widget.courseRepository,
      tareasRepositorio: widget.taskRepository,
    ),
    _ => ProfileScreen(
      repositorio: widget.taskRepository,
      cursosRepositorio: widget.courseRepository,
      ajustes: widget.settingsRepository,
      correoUsuario: widget.correoUsuario,
      alCerrarSesion: widget.alCerrarSesion,
      estadoSync: widget.estadoSync,
      alSincronizar: widget.alSincronizar,
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyedSubtree(
        key: ValueKey('pestana-$_indice-sync-$_revisionSync'),
        child: _pantallaActual(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (indice) => setState(() => _indice = indice),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Calendario',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Cursos',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
