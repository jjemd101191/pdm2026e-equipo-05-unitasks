import 'dart:ui';

import 'package:drift/drift.dart';

import '../models/course.dart';
import 'course_repository.dart';
import 'db/app_database.dart';
import 'db/cursos_dao.dart';

/// [CourseRepository] sobre la base SQLite (Drift).
///
/// [usuarioId] es el uid de Firebase Auth: filtra las consultas y marca las
/// filas nuevas. Con el valor vacío (sin sesión o en pruebas) se comporta
/// como antes del esquema v4.
class DriftCourseRepository implements CourseRepository {
  DriftCourseRepository(this._db, {this.usuarioId = ''});

  final AppDatabase _db;
  final String usuarioId;

  CursosDao get _dao => _db.cursosDao;

  @override
  Stream<List<Course>> watchCursos() => _dao
      .observarTodos(usuarioId)
      .map((filas) => filas.map(cursoDesdeFila).toList(growable: false));

  @override
  Future<void> crear(Course curso) =>
      _dao.insertar(cursoAFila(curso, usuarioId: usuarioId));

  @override
  Future<void> actualizar(Course curso) async {
    final cambiadas = await _dao.actualizar(
      curso.id,
      cursoAFila(curso, usuarioId: usuarioId),
    );
    if (cambiadas == 0) throw StateError('No existe el curso ${curso.id}');
  }

  @override
  Future<void> eliminar(String id) async {
    // La clave foránea (RESTRICT) ya lo impediría, pero así el error dice
    // cuántas tareas hay y la pantalla puede explicarlo.
    final tareas = await _dao.contarTareas(id);
    if (tareas > 0) throw CursoConTareasException(tareas);
    await _dao.eliminar(id);
  }
}

Course cursoDesdeFila(CursoFila fila) => Course(
  id: fila.id,
  nombre: fila.nombre,
  docente: fila.docente,
  color: Color(fila.color),
  dias: fila.dias,
  horaInicio: fila.horaInicio,
  horaFin: fila.horaFin,
  periodo: fila.periodo,
  archivado: fila.archivado,
);

CoursesCompanion cursoAFila(
  Course curso, {
  String usuarioId = '',
  DateTime? actualizadaEn,
  DateTime? creadaEn,
}) => CoursesCompanion(
  id: Value(curso.id),
  usuarioId: Value(usuarioId),
  nombre: Value(curso.nombre),
  docente: Value(curso.docente),
  color: Value(curso.color.toARGB32()),
  dias: Value(curso.dias),
  horaInicio: Value(curso.horaInicio),
  horaFin: Value(curso.horaFin),
  periodo: Value(curso.periodo),
  archivado: Value(curso.archivado),
  actualizadaEn: Value(actualizadaEn ?? DateTime.now()),
  creadoEn: creadaEn == null ? const Value.absent() : Value(creadaEn),
);
