import '../models/task.dart';

/// Acceso a las tareas guardadas en el dispositivo.
abstract class TaskRepository {
  Future<List<Task>> obtenerTareas();

  Future<Task?> obtenerTarea(String id);

  /// Crea o actualiza una tarea usando su [Task.id] como clave.
  Future<void> guardarTarea(Task tarea);

  Future<void> eliminarTarea(String id);

  /// Tareas cuyo estado no es «Completada».
  Future<int> contarActivas();
}
