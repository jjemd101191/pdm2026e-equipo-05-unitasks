import '../models/course.dart';

// shortcut: contrato provisional de la pareja B; ajustar al recibir el DAO de A.
abstract class CursoDao {
  Future<List<Course>> obtenerCursos();
  Future<void> guardarCurso(Course curso);
  Future<int> tareasDe(String id);
  Future<void> eliminarCurso(String id);
  Future<void> archivarCurso(String id);
  Future<void> restaurarCurso(Course curso, {int? indice});
}

class CursoDuplicadoException implements Exception {
  const CursoDuplicadoException();
}

class CursoEnUsoException implements Exception {
  const CursoEnUsoException(this.cantidad);
  final int cantidad;
}
