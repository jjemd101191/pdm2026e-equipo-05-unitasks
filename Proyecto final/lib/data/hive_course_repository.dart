import '../models/course.dart';
import 'course_repository.dart';
import 'local_store.dart';
import 'serialization.dart';

/// Implementación de [CourseRepository] sobre el almacenamiento local Hive.
class HiveCourseRepository implements CourseRepository {
  HiveCourseRepository(this._store);

  final LocalStore _store;

  @override
  Future<List<Course>> obtenerCursos() async {
    final cursos = _store.cursosJson.map(cursoDesdeJson).toList();
    cursos.sort(
      (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()),
    );
    return cursos;
  }

  @override
  Future<Course?> obtenerCurso(String id) async {
    final json = _store.cursosJson.where((dato) => dato['id'] == id);
    if (json.isEmpty) return null;
    return cursoDesdeJson(json.first);
  }

  @override
  Future<void> guardarCurso(Course curso) =>
      _store.guardarCurso(curso.id, cursoAJson(curso));

  @override
  Future<void> eliminarCurso(String id) async {
    final tareasDelCurso = _store.tareasJson.where(
      (dato) => dato['cursoId'] == id,
    );
    if (tareasDelCurso.isNotEmpty) {
      throw CursoConTareasException(tareasDelCurso.length);
    }
    await _store.eliminarCurso(id);
  }

  @override
  Future<void> restaurarCurso(Course curso, {int? indice}) =>
      guardarCurso(curso);
}
