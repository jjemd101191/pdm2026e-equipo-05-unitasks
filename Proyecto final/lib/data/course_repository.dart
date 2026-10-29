import '../models/course.dart';

/// Acceso a los cursos guardados en el dispositivo.
abstract class CourseRepository {
  /// Cursos ordenados por nombre; emite de nuevo con cada cambio.
  Stream<List<Course>> watchCursos();

  Future<void> crear(Course curso);

  Future<void> actualizar(Course curso);

  /// Elimina el curso solo si no tiene tareas asociadas.
  ///
  /// Se lanza [CursoConTareasException] cuando aún hay tareas: borrarlas en
  /// cascada sin avisar perdería trabajo del estudiante.
  Future<void> eliminar(String id);
}

class CursoConTareasException implements Exception {
  const CursoConTareasException(this.cantidadTareas);

  final int cantidadTareas;

  @override
  String toString() =>
      'El curso tiene $cantidadTareas tareas asociadas y no se puede eliminar.';
}
