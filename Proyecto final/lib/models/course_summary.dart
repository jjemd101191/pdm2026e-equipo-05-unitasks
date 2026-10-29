import 'course.dart';
import 'task.dart';

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

  /// Arma un resumen por curso contando las [tareas] de cada uno.
  static List<CourseSummary> deCursos(List<Course> cursos, List<Task> tareas) {
    final total = <String, int>{};
    final pendientes = <String, int>{};
    for (final tarea in tareas) {
      total.update(tarea.cursoId, (n) => n + 1, ifAbsent: () => 1);
      if (!tarea.completada) {
        pendientes.update(tarea.cursoId, (n) => n + 1, ifAbsent: () => 1);
      }
    }
    return [
      for (final curso in cursos)
        CourseSummary(
          curso: curso,
          totalTareas: total[curso.id] ?? 0,
          pendientes: pendientes[curso.id] ?? 0,
        ),
    ];
  }

  final Course curso;
  final int totalTareas;
  final int pendientes;

  int get completadas => totalTareas - pendientes;

  /// Avance del curso (tareas completadas / tareas totales).
  double get avance => totalTareas == 0 ? 0 : completadas / totalTareas;
}
