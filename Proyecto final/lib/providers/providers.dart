import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/course_repository.dart';
import '../data/db/app_database.dart';
import '../data/drift_course_repository.dart';
import '../data/drift_task_repository.dart';
import '../data/task_repository.dart';
import '../models/course.dart';
import '../models/course_summary.dart';
import '../models/task.dart';

// Único origen de verdad de la app. Las pantallas leen las listas con
// `ref.watch(...)` y escriben a través de los repositorios; nadie guarda
// copias propias de los datos.
//
// En pruebas se puede reemplazar cualquier nivel:
//   ProviderScope(overrides: [
//     taskRepositoryProvider.overrideWithValue(FakeTaskRepository()),
//   ], child: ...)

/// La base abierta. `main` la sobrescribe con la instancia real; si alguien
/// la lee sin hacerlo, el error lo dice claramente.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError(
    'databaseProvider debe sobrescribirse en el ProviderScope (ver main.dart)',
  ),
);

final courseRepositoryProvider = Provider<CourseRepository>(
  (ref) => DriftCourseRepository(ref.watch(databaseProvider)),
);

final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => DriftTaskRepository(ref.watch(databaseProvider)),
);

/// Todos los cursos, ordenados por nombre.
final cursosProvider = StreamProvider<List<Course>>(
  (ref) => ref.watch(courseRepositoryProvider).watchCursos(),
);

/// Todas las tareas, ordenadas por fecha de entrega.
final tareasProvider = StreamProvider<List<Task>>(
  (ref) => ref.watch(taskRepositoryProvider).watchTareas(),
);

/// Tareas de un solo curso: `ref.watch(tareasDeCursoProvider(curso.id))`.
final tareasDeCursoProvider = StreamProvider.family<List<Task>, String>(
  (ref, cursoId) =>
      ref.watch(taskRepositoryProvider).watchTareas(cursoId: cursoId),
);

/// Una tarea por id, al día con la base (`null` si se eliminó).
final tareaProvider = FutureProvider.family<Task?, String>((ref, id) async {
  final tareas = await ref.watch(tareasProvider.future);
  for (final tarea in tareas) {
    if (tarea.id == id) return tarea;
  }
  return null;
});

/// Cursos con sus totales de tareas, para la pantalla de cursos.
final resumenCursosProvider = FutureProvider<List<CourseSummary>>((ref) async {
  final cursos = await ref.watch(cursosProvider.future);
  final tareas = await ref.watch(tareasProvider.future);
  return CourseSummary.deCursos(cursos, tareas);
});
