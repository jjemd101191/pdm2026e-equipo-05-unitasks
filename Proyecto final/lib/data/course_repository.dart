import '../models/course.dart';

/// Acceso a los cursos guardados en el dispositivo.
abstract class CourseRepository {
  Future<List<Course>> obtenerCursos();

  Future<Course?> obtenerCurso(String id);

  Future<void> guardarCurso(Course curso);

  /// Elimina el curso solo si no tiene tareas asociadas.
  ///
  /// Se lanza [CursoConTareasException] cuando aún hay tareas: borrarlas en
  /// cascada sin avisar perdería trabajo del estudiante.
  Future<void> eliminarCurso(String id);

  /// Vuelve a guardar un curso eliminado (acción «Deshacer»).
  Future<void> restaurarCurso(Course curso, {int? indice});
}

class CursoConTareasException implements Exception {
  const CursoConTareasException(this.cantidadTareas);

  final int cantidadTareas;

  @override
  String toString() =>
      'El curso tiene $cantidadTareas tareas asociadas y no se puede eliminar.';
}
