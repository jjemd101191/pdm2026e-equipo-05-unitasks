import '../models/task.dart';

/// Acceso a las tareas guardadas en el dispositivo.
///
/// Es el contrato que usan las pantallas: ninguna toca la base directamente.
abstract class TaskRepository {
  /// Tareas ordenadas por fecha de entrega. Emite de nuevo cada vez que algo
  /// cambia (incluidas subtareas y recordatorios). Con [cursoId] se limita a
  /// las tareas de ese curso.
  Stream<List<Task>> watchTareas({String? cursoId});

  /// La tarea con ese id, o `null` si no existe (p. ej. al abrir una
  /// notificación de una tarea que ya se borró).
  Future<Task?> obtenerTarea(String id);

  /// Guarda una tarea nueva con sus subtareas y su recordatorio.
  Future<void> crear(Task tarea);

  /// Reemplaza una tarea existente. Lanza [TareaNoEncontradaException] si el
  /// id no existe.
  Future<void> actualizar(Task tarea);

  /// Elimina la tarea junto con sus subtareas y su recordatorio.
  Future<void> eliminar(String id);
}

class TareaNoEncontradaException implements Exception {
  const TareaNoEncontradaException(this.id);

  final String id;

  @override
  String toString() => 'No existe la tarea $id.';
}
