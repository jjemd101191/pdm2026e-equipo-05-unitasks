import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../models/task.dart';
import 'ajustes_dao.dart';
import 'cursos_dao.dart';
import 'tablas.dart';
import 'tareas_dao.dart';

part 'app_database.g.dart';

/// Base de datos local de TaskU (SQLite vía Drift).
@DriftDatabase(
  tables: [Courses, Tasks, Subtasks, Reminders, AppSettings],
  daos: [CursosDao, TareasDao, AjustesDao],
)
class AppDatabase extends _$AppDatabase {
  /// [alCrear] se ejecuta una sola vez, justo después de crear las tablas
  /// en una instalación nueva. La app lo usa para cargar los datos de ejemplo.
  AppDatabase(super.e, {this.alCrear});

  /// Abre (o crea) el archivo `tasku.sqlite` de la plataforma.
  ///
  /// En web usa SQLite compilado a WASM; para eso `web/` debe tener
  /// `sqlite3.wasm` y `drift_worker.js` (ver docs/adr/0002).
  factory AppDatabase.abrir({Future<void> Function(AppDatabase db)? alCrear}) {
    final conexion = driftDatabase(
      name: 'tasku',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
    return AppDatabase(conexion, alCrear: alCrear);
  }

  final Future<void> Function(AppDatabase db)? alCrear;

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await alCrear?.call(this);
    },
    onUpgrade: (m, from, to) async {
      // v2: los cursos se pueden archivar sin borrar sus tareas.
      // La columna se agrega con valor por defecto `false`, así los cursos
      // que ya existían siguen visibles después de actualizar.
      if (from < 2) {
        await m.addColumn(courses, courses.archivado);
      }
      // v3: preferencias locales (plan Premium de la demostración).
      if (from < 3) {
        await m.createTable(appSettings);
      }
      // v4: cada fila pertenece a la cuenta de Firebase que inició sesión y
      // los cursos guardan cuándo cambiaron para resolver conflictos.
      if (from < 4) {
        await m.addColumn(courses, courses.usuarioId);
        await m.addColumn(tasks, tasks.usuarioId);
        await m.addColumn(courses, courses.actualizadaEn);
        // Las filas que ya existían se ponen al día con su fecha de creación;
        // el primer inicio de sesión las adopta (usuario_id sigue vacío).
        await customStatement(
          'UPDATE courses SET actualizada_en = creado_en '
          'WHERE actualizada_en IS NULL',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_courses_usuario '
          'ON courses (usuario_id)',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_tasks_usuario ON tasks (usuario_id)',
        );
      }
    },
    beforeOpen: (detalles) async {
      // SQLite trae las claves foráneas apagadas por defecto; sin esto no
      // funcionan ni el RESTRICT de cursos ni el CASCADE de subtareas.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Fuerza la apertura (y la migración) para detectar errores al arrancar
  /// en lugar de en la primera consulta.
  Future<void> verificar() => customSelect('SELECT 1').get();
}
