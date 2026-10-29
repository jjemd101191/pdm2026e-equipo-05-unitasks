import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course.dart';
import 'curso_dao.dart';
import 'course_repository.dart';

final cursoDaoProvider = Provider<CursoDao>((ref) => DemoCursoDao());
final cursosProvider = FutureProvider<List<Course>>(
  (ref) => ref.watch(cursoDaoProvider).obtenerCursos(),
  retry: (retryCount, error) => null,
);
