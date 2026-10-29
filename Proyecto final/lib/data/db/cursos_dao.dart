import 'package:drift/drift.dart';

import 'app_database.dart';
import 'tablas.dart';

part 'cursos_dao.g.dart';

/// Consultas sobre la tabla `courses`.
@DriftAccessor(tables: [Courses, Tasks])
class CursosDao extends DatabaseAccessor<AppDatabase> with _$CursosDaoMixin {
  CursosDao(super.attachedDatabase);

  /// Todos los cursos ordenados por nombre (sin distinguir mayúsculas).
  Stream<List<CursoFila>> observarTodos() {
    final consulta = select(courses)
      ..orderBy([(c) => OrderingTerm.asc(c.nombre.lower())]);
    return consulta.watch();
  }

  Future<CursoFila?> buscar(String id) =>
      (select(courses)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<void> insertar(CoursesCompanion curso) => into(courses).insert(curso);

  /// Devuelve cuántas filas cambió (0 si el curso no existe).
  Future<int> actualizar(String id, CoursesCompanion curso) =>
      (update(courses)..where((c) => c.id.equals(id))).write(curso);

  Future<int> eliminar(String id) =>
      (delete(courses)..where((c) => c.id.equals(id))).go();

  Future<int> contarTareas(String cursoId) {
    final total = tasks.id.count();
    final consulta = selectOnly(tasks)
      ..addColumns([total])
      ..where(tasks.cursoId.equals(cursoId));
    return consulta.map((fila) => fila.read(total)!).getSingle();
  }
}
