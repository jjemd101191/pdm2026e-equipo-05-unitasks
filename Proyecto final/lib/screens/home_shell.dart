import 'package:flutter/material.dart';

import '../data/course_repository.dart';
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
  });

  final CourseRepository courseRepository;
  final TaskRepository taskRepository;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _indice = 0;

  Widget _pantallaActual() => switch (_indice) {
    0 => TaskListScreen(
      repositorio: widget.taskRepository,
      cursosRepositorio: widget.courseRepository,
    ),
    1 => CalendarScreen(
      repositorio: widget.taskRepository,
      cursosRepositorio: widget.courseRepository,
    ),
    2 => CourseListScreen(
      repositorio: widget.courseRepository,
      tareasRepositorio: widget.taskRepository,
    ),
    _ => ProfileScreen(
      repositorio: widget.taskRepository,
      cursosRepositorio: widget.courseRepository,
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pantallaActual(),
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
