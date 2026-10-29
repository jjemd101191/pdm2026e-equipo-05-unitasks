import 'dart:ui';

import 'package:drift/drift.dart';

import '../models/course.dart';
import 'course_repository.dart';
import 'db/app_database.dart';
import 'db/cursos_dao.dart';

/// [CourseRepository] sobre la base SQLite (Drift).
class DriftCourseRepository implements CourseRepository {
  DriftCourseRepository(this._db);

  final AppDatabase _db;

  CursosDao get _dao => _db.cursosDao;

  @override
  Stream<List<Course>> watchCursos() => _dao.observarTodos().map(
    (filas) => filas.map(cursoDesdeFila).toList(growable: false),
  );

  @override
  Future<void> crear(Course curso) => _dao.insertar(cursoAFila(curso));

  @override
  Future<void> actualizar(Course curso) async {
    final cambiadas = await _dao.actualizar(curso.id, cursoAFila(curso));
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
);

CoursesCompanion cursoAFila(Course curso) => CoursesCompanion(
  id: Value(curso.id),
  nombre: Value(curso.nombre),
  docente: Value(curso.docente),
  color: Value(curso.color.toARGB32()),
  dias: Value(curso.dias),
  horaInicio: Value(curso.horaInicio),
  horaFin: Value(curso.horaFin),
  periodo: Value(curso.periodo),
);
