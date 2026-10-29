import '../models/course.dart';
import '../models/task.dart';
import 'local_store.dart';
import 'serialization.dart';
import 'task_repository.dart';

/// Implementación de [TaskRepository] sobre el almacenamiento local Hive.
class HiveTaskRepository implements TaskRepository {
  HiveTaskRepository(this._store);

  final LocalStore _store;

  @override
  Future<List<Task>> obtenerTareas() async => _leerTareas();

  @override
  Future<Task?> obtenerTarea(String id) async {
    final tareas = _leerTareas().where((tarea) => tarea.id == id);
    return tareas.isEmpty ? null : tareas.first;
  }

  @override
  Future<void> guardarTarea(Task tarea) =>
      _store.guardarTarea(tarea.id, tareaAJson(tarea));

  @override
  Future<void> eliminarTarea(String id) => _store.eliminarTarea(id);

  @override
  Future<int> contarActivas() async =>
      _leerTareas().where((tarea) => !tarea.completada).length;

  List<Task> _leerTareas() {
    final cursosPorId = <String, Course>{};
    for (final json in _store.cursosJson) {
      final curso = cursoDesdeJson(json);
      cursosPorId[curso.id] = curso;
    }
    return [
      for (final json in _store.tareasJson) tareaDesdeJson(json, cursosPorId),
    ];
  }
}
