import 'course.dart';

/// Curso junto con los totales calculados desde sus tareas.
///
/// Es la vista que usa la pantalla de cursos para mostrar pendientes y el
/// anillo de avance. Los números se obtienen del repositorio de tareas, no se
/// escriben a mano en el curso.
class CourseSummary {
  const CourseSummary({
    required this.curso,
    required this.totalTareas,
    required this.pendientes,
  });

  final Course curso;
  final int totalTareas;
  final int pendientes;

  int get completadas => totalTareas - pendientes;

  /// Avance del curso (tareas completadas / tareas totales).
  double get avance => totalTareas == 0 ? 0 : completadas / totalTareas;
}
