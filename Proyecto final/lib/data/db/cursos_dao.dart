import 'package:drift/drift.dart';

import 'app_database.dart';
import 'tablas.dart';

part 'cursos_dao.g.dart';

/// Consultas sobre la tabla `courses`.
///
/// Todas las consultas de la app filtran por [usuarioId]: cada cuenta de
/// Firebase ve solo sus cursos. Las filas creadas antes del esquema v4 tienen
/// `usuario_id` vacío hasta que el primer inicio de sesión las adopta.
@DriftAccessor(tables: [Courses, Tasks])
class CursosDao extends DatabaseAccessor<AppDatabase> with _$CursosDaoMixin {
  CursosDao(super.attachedDatabase);

  /// Cursos de una cuenta, ordenados por nombre (sin distinguir mayúsculas).
  Stream<List<CursoFila>> observarTodos([String usuarioId = '']) {
    final consulta = select(courses)
      ..where((c) => c.usuarioId.equals(usuarioId))
      ..orderBy([(c) => OrderingTerm.asc(c.nombre.lower())]);
    return consulta.watch();
  }

  /// Misma lista que [observarTodos], pero una sola vez.
  Future<List<CursoFila>> todos([String usuarioId = '']) =>
      (select(courses)..where((c) => c.usuarioId.equals(usuarioId))).get();

  Future<CursoFila?> buscar(String id) =>
      (select(courses)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<void> insertar(CoursesCompanion curso) => into(courses).insert(curso);

  /// Devuelve cuántas filas cambió (0 si el curso no existe).
  Future<int> actualizar(String id, CoursesCompanion curso) =>
      (update(courses)..where((c) => c.id.equals(id))).write(curso);

  Future<int> eliminar(String id) =>
      (delete(courses)..where((c) => c.id.equals(id))).go();

  /// Borra un curso solo si pertenece a [usuarioId] (usado al aplicar un
  /// borrado que llegó de Firestore).
  Future<int> eliminarDeUsuario(String usuarioId, String id) => (delete(
    courses,
  )..where((c) => c.id.equals(id) & c.usuarioId.equals(usuarioId))).go();

  Future<int> contarTareas(String cursoId) {
    final total = tasks.id.count();
    final consulta = selectOnly(tasks)
      ..addColumns([total])
      ..where(tasks.cursoId.equals(cursoId));
    return consulta.map((fila) => fila.read(total)!).getSingle();
  }

  /// Asigna al usuario actual las filas que todavía no tienen dueño.
  /// Devuelve cuántas adoptó.
  Future<int> reclamarSinDueno(String usuarioId) =>
      (update(courses)..where((c) => c.usuarioId.equals(''))).write(
        CoursesCompanion(usuarioId: Value(usuarioId)),
      );

  /// Inserta o reemplaza una fila tal como llega de la nube.
  Future<void> guardarDesdeRemoto(CoursesCompanion curso) =>
      into(courses).insertOnConflictUpdate(curso);
}
