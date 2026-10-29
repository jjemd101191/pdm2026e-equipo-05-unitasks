import '../models/course.dart';
import 'curso_dao.dart';
import 'demo_data.dart';

// shortcut: demo sin persistencia; sustituir por SqliteCursoDao de la pareja A.
class DemoCursoDao implements CursoDao {
  DemoCursoDao({List<Course>? cursos, Map<String, int>? tareas})
    : cursos = List.of(cursos ?? cursosDemo),
      tareas = Map.of(
        tareas ?? {for (final c in cursos ?? cursosDemo) c.id: c.totalTareas},
      );

  final List<Course> cursos;
  final Map<String, int> tareas;

  @override
  Future<List<Course>> obtenerCursos() async => List.of(cursos);

  @override
  Future<int> tareasDe(String id) async => tareas[id] ?? 0;

  @override
  Future<void> guardarCurso(Course curso) async {
    if (cursos.any(
      (c) =>
          c.id != curso.id &&
          c.periodo == curso.periodo &&
          c.nombre.trim().toLowerCase() == curso.nombre.trim().toLowerCase(),
    )) {
      throw const CursoDuplicadoException();
    }
    final i = cursos.indexWhere((c) => c.id == curso.id);
    if (i < 0) {
      cursos.add(curso);
    } else {
      cursos[i] = curso;
    }
  }

  @override
  Future<void> eliminarCurso(String id) async {
    final cantidad = await tareasDe(id);
    if (cantidad > 0) throw CursoEnUsoException(cantidad);
    final i = cursos.indexWhere((c) => c.id == id);
    if (i < 0) throw StateError('Curso inexistente');
    cursos.removeAt(i);
  }

  @override
  Future<void> archivarCurso(String id) async {
    final i = cursos.indexWhere((c) => c.id == id);
    if (i < 0) throw StateError('Curso inexistente');
    cursos[i] = cursos[i].copyWith(archivado: true);
  }

  @override
  Future<void> restaurarCurso(Course curso, {int? indice}) async {
    if (cursos.any((c) => c.id == curso.id)) {
      throw StateError('El curso ya existe');
    }
    await guardarCurso(curso);
  }
}
