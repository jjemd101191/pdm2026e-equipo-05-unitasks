import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../models/task.dart';
import 'cursos_dao.dart';
import 'tablas.dart';
import 'tareas_dao.dart';

part 'app_database.g.dart';

/// Base de datos local de TaskU (SQLite vía Drift).
@DriftDatabase(
  tables: [Courses, Tasks, Subtasks, Reminders],
  daos: [CursosDao, TareasDao],
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
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await alCrear?.call(this);
    },
    onUpgrade: (m, from, to) async {
      // v1 es la primera versión. Los cambios de esquema futuros van aquí,
      // uno por versión: if (from < 2) { ... }
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
