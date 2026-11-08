import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/proveedores_auth.dart';
import '../data/course_repository.dart';
import '../data/db/app_database.dart';
import '../data/drift_course_repository.dart';
import '../data/drift_settings_repository.dart';
import '../data/drift_task_repository.dart';
import '../data/settings_repository.dart';
import '../data/sync/repos_sincronizados.dart';
import '../data/sync/remoto_sync.dart';
import '../data/sync/sincronizador.dart';
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

/// Copia del usuario en Firestore. `main` la sobrescribe; en pruebas se usa
/// una implementación en memoria.
final remotoSyncProvider = Provider<RemotoSync>(
  (ref) => throw UnimplementedError(
    'remotoSyncProvider debe sobrescribirse (ver main.dart)',
  ),
);

/// Repositorios de la cuenta activa. Sin sesión (`usuarioId` vacío) son los
/// locales de siempre; con sesión, cada escritura se copia a la nube.
final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  final usuarioId = ref.watch(usuarioIdProvider);
  final local = DriftCourseRepository(
    ref.watch(databaseProvider),
    usuarioId: usuarioId,
  );
  if (usuarioId.isEmpty) return local;
  return CursoRepoSincronizado(
    local: local,
    remoto: ref.watch(remotoSyncProvider),
    usuarioId: usuarioId,
  );
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final usuarioId = ref.watch(usuarioIdProvider);
  final local = DriftTaskRepository(
    ref.watch(databaseProvider),
    usuarioId: usuarioId,
  );
  if (usuarioId.isEmpty) return local;
  return TareaRepoSincronizado(
    local: local,
    remoto: ref.watch(remotoSyncProvider),
    usuarioId: usuarioId,
  );
});

/// Preferencias locales, con una clave por cuenta para el plan Premium.
final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => DriftSettingsRepository(
    ref.watch(databaseProvider),
    usuarioId: ref.watch(usuarioIdProvider),
  ),
);

/// Sincroniza la cuenta activa mientras dure la sesión.
final sincronizadorProvider = Provider<Sincronizador>((ref) {
  final sincronizador = Sincronizador(
    db: ref.watch(databaseProvider),
    remoto: ref.watch(remotoSyncProvider),
    usuarioId: ref.watch(usuarioIdProvider),
  );
  // Si la cuenta cambia, el provider se reconstruye: el anterior deja de
  // escuchar a la nube.
  ref.onDispose(() => unawaited(sincronizador.detener()));
  return sincronizador;
});

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
