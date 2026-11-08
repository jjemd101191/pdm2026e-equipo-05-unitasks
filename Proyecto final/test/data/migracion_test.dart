import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/db/app_database.dart';

void main() {
  group('migración del esquema', () {
    test('v1 → v3 conserva los cursos y agrega la columna archivado', () async {
      final carpeta = await Directory.systemTemp.createTemp('tasku_migracion_');
      final archivo = File('${carpeta.path}/tasku.sqlite');
      AppDatabase? antes;
      AppDatabase? despues;

      try {
        // 1. Crear la base con el esquema actual (v2) y sembrar un curso.
        antes = AppDatabase(NativeDatabase(archivo));
        await antes.verificar();
        await antes.cursosDao.insertar(
          CoursesCompanion.insert(
            id: 'c1',
            nombre: 'Redes',
            color: 0xFF4F46E5,
            dias: const Value(['Lun', 'Mié']),
          ),
        );

        // 2. Dejarla como una base v1: sin las tablas/columnas nuevas y con
        //    user_version 1.
        await antes.customStatement(
          'ALTER TABLE courses DROP COLUMN archivado',
        );
        await antes.customStatement('DROP TABLE app_settings');
        await antes.customStatement('PRAGMA user_version = 1');
        await antes.close();
        antes = null;

        // 3. Reabrir: Drift detecta v1, ejecuta onUpgrade y migra a v2.
        despues = AppDatabase(NativeDatabase(archivo));
        await despues.verificar();

        final cursos = await despues.cursosDao.observarTodos().first;
        expect(cursos, hasLength(1));
        expect(cursos.single.nombre, 'Redes');
        expect(cursos.single.dias, ['Lun', 'Mié']);
        // El curso que ya existía queda visible (archivado = false).
        expect(cursos.single.archivado, isFalse);

        final version = await despues
            .customSelect('PRAGMA user_version')
            .getSingle();
        expect(version.data['user_version'], 3);
      } finally {
        await antes?.close();
        await despues?.close();
        try {
          await carpeta.delete(recursive: true);
        } on FileSystemException {
          // En Windows el archivo puede tardar un instante en liberarse.
        }
      }
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

    test('v2 → v3 agrega app_settings y conserva los cursos', () async {
      final carpeta = await Directory.systemTemp.createTemp('tasku_migracion_');
      final archivo = File('${carpeta.path}/tasku.sqlite');
      AppDatabase? antes;
      AppDatabase? despues;

      try {
        // 1. Crear la base con el esquema actual (v3) y sembrar un curso.
        antes = AppDatabase(NativeDatabase(archivo));
        await antes.verificar();
        await antes.cursosDao.insertar(
          CoursesCompanion.insert(
            id: 'c1',
            nombre: 'Redes',
            color: 0xFF4F46E5,
            dias: const Value(['Lun', 'Mié']),
          ),
        );

        // 2. Dejarla como una base v2: sin la tabla de preferencias.
        await antes.customStatement('DROP TABLE app_settings');
        await antes.customStatement('PRAGMA user_version = 2');
        await antes.close();
        antes = null;

        // 3. Reabrir: Drift detecta v2 y crea la tabla nueva.
        despues = AppDatabase(NativeDatabase(archivo));
        await despues.verificar();

        final cursos = await despues.cursosDao.observarTodos().first;
        expect(cursos, hasLength(1));
        expect(cursos.single.nombre, 'Redes');
        expect(await despues.ajustesDao.leer('premium_activo'), isNull);

        await despues.ajustesDao.escribir('premium_activo', 'true');
        expect(await despues.ajustesDao.leer('premium_activo'), 'true');

        final version = await despues
            .customSelect('PRAGMA user_version')
            .getSingle();
        expect(version.data['user_version'], 3);
      } finally {
        await antes?.close();
        await despues?.close();
        try {
          await carpeta.delete(recursive: true);
        } on FileSystemException {
          // En Windows el archivo puede tardar un instante en liberarse.
        }
      }
    });
  });
}
