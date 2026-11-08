import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/db/app_database.dart';

void main() {
  /// Deja una base recién creada como si fuera la versión [version],
  /// quitando todo lo que se agregó después. Devuelve nada; la base queda
  /// cerrada y lista para reabrirse.
  Future<void> degradarA(AppDatabase db, int version) async {
    await db.customStatement('DROP INDEX IF EXISTS idx_courses_usuario');
    await db.customStatement('DROP INDEX IF EXISTS idx_tasks_usuario');
    await db.customStatement('ALTER TABLE courses DROP COLUMN usuario_id');
    await db.customStatement('ALTER TABLE courses DROP COLUMN actualizada_en');
    await db.customStatement('ALTER TABLE tasks DROP COLUMN usuario_id');
    if (version < 3) {
      await db.customStatement('DROP TABLE app_settings');
    }
    if (version < 2) {
      await db.customStatement('ALTER TABLE courses DROP COLUMN archivado');
    }
    await db.customStatement('PRAGMA user_version = $version');
    await db.close();
  }

  Future<void> conBaseTemporal(
    Future<void> Function(AppDatabase antes, File archivo) preparar,
    Future<void> Function(AppDatabase despues) verificar,
  ) async {
    final carpeta = await Directory.systemTemp.createTemp('tasku_migracion_');
    final archivo = File('${carpeta.path}/tasku.sqlite');
    AppDatabase? despues;
    try {
      final antes = AppDatabase(NativeDatabase(archivo));
      await antes.verificar();
      await antes.cursosDao.insertar(
        CoursesCompanion.insert(
          id: 'c1',
          nombre: 'Redes',
          color: 0xFF4F46E5,
          dias: const Value(['Lun', 'Mié']),
        ),
      );
      await preparar(antes, archivo);

      despues = AppDatabase(NativeDatabase(archivo));
      await despues.verificar();
      await verificar(despues);
    } finally {
      await despues?.close();
      try {
        await carpeta.delete(recursive: true);
      } on FileSystemException {
        // En Windows el archivo puede tardar un instante en liberarse.
      }
    }
  }

  Future<int> versionDe(AppDatabase db) async {
    final fila = await db.customSelect('PRAGMA user_version').getSingle();
    return fila.data['user_version'] as int;
  }

  group('migración del esquema', () {
    test('v1 → v4 conserva los cursos y agrega las columnas nuevas', () async {
      await conBaseTemporal((antes, _) => degradarA(antes, 1), (despues) async {
        final cursos = await despues.cursosDao.observarTodos().first;
        expect(cursos, hasLength(1));
        expect(cursos.single.nombre, 'Redes');
        expect(cursos.single.dias, ['Lun', 'Mié']);
        // El curso que ya existía queda visible y sin dueño hasta el login.
        expect(cursos.single.archivado, isFalse);
        expect(cursos.single.usuarioId, '');
        expect(cursos.single.actualizadaEn, cursos.single.creadoEn);
        expect(await versionDe(despues), 4);
      });
    });

    test('v2 → v4 agrega app_settings y conserva los cursos', () async {
      await conBaseTemporal((antes, _) => degradarA(antes, 2), (despues) async {
        final cursos = await despues.cursosDao.observarTodos().first;
        expect(cursos, hasLength(1));
        expect(cursos.single.nombre, 'Redes');
        expect(await despues.ajustesDao.leer('premium_activo'), isNull);

        await despues.ajustesDao.escribir('premium_activo', 'true');
        expect(await despues.ajustesDao.leer('premium_activo'), 'true');
        expect(await versionDe(despues), 4);
      });
    });

    test('v3 → v4 conserva los cursos y rellena actualizadaEn', () async {
      await conBaseTemporal((antes, _) => degradarA(antes, 3), (despues) async {
        final cursos = await despues.cursosDao.observarTodos().first;
        expect(cursos, hasLength(1));
        expect(cursos.single.nombre, 'Redes');
        expect(cursos.single.usuarioId, '');
        expect(cursos.single.actualizadaEn, isNotNull);
        expect(cursos.single.actualizadaEn, cursos.single.creadoEn);

        // Un curso nuevo sí lleva dueño.
        await despues.cursosDao.insertar(
          CoursesCompanion.insert(
            id: 'c2',
            nombre: 'Álgebra',
            color: 0xFF0EA5E9,
            dias: const Value(['Mar']),
            usuarioId: const Value('uid-1'),
          ),
        );
        final nuevos = await despues.cursosDao.observarTodos('uid-1').first;
        expect(nuevos.single.id, 'c2');
        expect(await versionDe(despues), 4);
      });
    });

    test('el esquema nuevo guarda y devuelve el valor de archivado', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      await db.cursosDao.insertar(
        CoursesCompanion.insert(
          id: 'c1',
          nombre: 'Base de Datos',
          color: 0xFF0EA5E9,
          dias: const Value(['Mar']),
          archivado: const Value(true),
        ),
      );

      final fila = await db.cursosDao.buscar('c1');
      expect(fila, isNotNull);
      expect(fila!.archivado, isTrue);
    });
  });
}
