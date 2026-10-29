import '../models/course.dart';
import 'demo_data.dart';

abstract class CourseRepository {
  Future<List<Course>> obtenerCursos();
  Future<void> eliminarCurso(String id);
  Future<void> restaurarCurso(Course curso, {int? indice});
  Future<void> guardarCurso(Course curso);
}

/// Repositorio temporal en memoria hasta que el equipo integre su base local.
class DemoCourseRepository implements CourseRepository {
  DemoCourseRepository({List<Course>? cursos})
    : _cursos = List<Course>.of(cursos ?? cursosDemo);

  final List<Course> _cursos;

  @override
  Future<List<Course>> obtenerCursos() async {
    await Future.delayed(const Duration(seconds: 2));
    return List<Course>.of(_cursos);
  }

  @override
  Future<void> eliminarCurso(String id) async {
    final indice = _cursos.indexWhere((curso) => curso.id == id);
    if (indice == -1) throw StateError('No existe el curso $id');
    _cursos.removeAt(indice);
  }

  @override
  Future<void> restaurarCurso(Course curso, {int? indice}) async {
    if (_cursos.any((actual) => actual.id == curso.id)) {
      throw StateError('El curso ${curso.id} ya existe');
    }
    final posicion = indice == null
        ? _cursos.length
        : indice.clamp(0, _cursos.length);
    _cursos.insert(posicion, curso);
  }

  @override
  Future<void> guardarCurso(Course curso) async {
    final indice = _cursos.indexWhere((actual) => actual.id == curso.id);
    if (indice == -1) {
      _cursos.add(curso);
    } else {
      _cursos[indice] = curso;
    }
  }
}

final CourseRepository demoCourseRepository = DemoCourseRepository();
