import 'modelos_remotos.dart';

/// Acceso a la copia del usuario en la nube.
///
/// Es una interfaz para que la sincronización se pueda probar sin Firebase:
/// las pruebas usan una implementación en memoria.
abstract class RemotoSync {
  /// Cursos del usuario; emite una lista completa cada vez que cambian.
  Stream<List<CursoRemoto>> observarCursos(String usuarioId);

  /// Tareas del usuario (con subtareas y recordatorio dentro).
  Stream<List<TareaRemota>> observarTareas(String usuarioId);

  Future<void> guardarCurso(String usuarioId, CursoRemoto curso);

  Future<void> eliminarCurso(String usuarioId, String cursoId);

  Future<void> guardarTarea(String usuarioId, TareaRemota tarea);

  Future<void> eliminarTarea(String usuarioId, String tareaId);
}
