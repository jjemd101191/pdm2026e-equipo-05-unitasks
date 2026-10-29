import 'dart:async';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/db/app_database.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/task.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  CoursesCompanion curso(String id, String nombre) => CoursesCompanion.insert(
    id: id,
    nombre: nombre,
    color: 0xFF4F46E5,
    dias: const Value(['Lun', 'Mié']),
  );

  TasksCompanion tarea(String id, {String cursoId = 'c1', DateTime? entrega}) =>
      TasksCompanion.insert(
        id: id,
        cursoId: cursoId,
        titulo: 'Tarea $id',
        tipo: TipoTarea.tarea,
        prioridad: Prioridad.media,
        estado: EstadoTarea.pendiente,
        fechaEntrega: entrega ?? DateTime(2026, 11, 10, 23, 59),
      );

  SubtasksCompanion subtarea(String id, String tareaId, int posicion) =>
      SubtasksCompanion.insert(
        id: id,
        tareaId: tareaId,
        titulo: 'Subtarea $id',
        posicion: posicion,
      );

  group('CursosDao', () {
    test('ordena por nombre sin importar mayúsculas', () async {
      await db.cursosDao.insertar(curso('c1', 'redes'));
      await db.cursosDao.insertar(curso('c2', 'Base de Datos'));

      final cursos = await db.cursosDao.observarTodos().first;

      expect(cursos.map((c) => c.nombre), ['Base de Datos', 'redes']);
      expect(cursos.first.dias, ['Lun', 'Mié']);
    });

    test('cuenta las tareas de un curso', () async {
      await db.cursosDao.insertar(curso('c1', 'Redes'));
      expect(await db.cursosDao.contarTareas('c1'), 0);

      await db.tareasDao.insertar(tarea('t1'), const [], null);
      await db.tareasDao.insertar(tarea('t2'), const [], null);
      expect(await db.cursosDao.contarTareas('c1'), 2);
    });

    test('rechaza un nombre vacío', () async {
      await expectLater(
        db.cursosDao.insertar(curso('c1', '')),
        throwsA(isA<InvalidDataException>()),
      );
    });
  });

  group('TareasDao', () {
    setUp(() => db.cursosDao.insertar(curso('c1', 'Redes')));

    test(
      'guarda la tarea con sus subtareas en orden y su recordatorio',
      () async {
        await db.tareasDao.insertar(tarea('t1'), [
          subtarea('s2', 't1', 1),
          subtarea('s1', 't1', 0),
        ], 60);

        final leida = await db.tareasDao.buscar('t1');

        expect(leida, isNotNull);
        expect(leida!.subtareas.map((s) => s.id), ['s1', 's2']);
        expect(leida.recordatorio?.minutosAntes, 60);
      },
    );

    test('una tarea sin subtareas no se duplica por el JOIN', () async {
      await db.tareasDao.insertar(tarea('t1'), const [], null);
      await db.tareasDao.insertar(tarea('t2'), [
        subtarea('a', 't2', 0),
        subtarea('b', 't2', 1),
        subtarea('c', 't2', 2),
      ], null);

      final tareas = await db.tareasDao.observar().first;

      expect(tareas.map((t) => t.tarea.id), ['t1', 't2']);
      expect(tareas.first.subtareas, isEmpty);
      expect(tareas.last.subtareas, hasLength(3));
    });

    test('ordena por fecha de entrega y filtra por curso', () async {
      await db.cursosDao.insertar(curso('c2', 'Base de Datos'));
      await db.tareasDao.insertar(
        tarea('tarde', entrega: DateTime(2026, 12, 1)),
        const [],
        null,
      );
      await db.tareasDao.insertar(
        tarea('pronto', entrega: DateTime(2026, 11, 1)),
        const [],
        null,
      );
      await db.tareasDao.insertar(tarea('otra', cursoId: 'c2'), const [], null);

      final todas = await db.tareasDao.observar().first;
      final delCurso = await db.tareasDao.observar(cursoId: 'c1').first;

      expect(todas.map((t) => t.tarea.id), ['pronto', 'otra', 'tarde']);
      expect(delCurso.map((t) => t.tarea.id), ['pronto', 'tarde']);
    });

    test('al actualizar conserva el id del recordatorio', () async {
      await db.tareasDao.insertar(tarea('t1'), const [], 60);
      final idOriginal = (await db.tareasDao.buscar('t1'))!.recordatorio!.id;

      await db.tareasDao.actualizar(tarea('t1'), const [], 24 * 60);
      final actualizado = (await db.tareasDao.buscar('t1'))!.recordatorio!;

      expect(actualizado.id, idOriginal);
      expect(actualizado.minutosAntes, 24 * 60);
    });

    test('quitar el recordatorio borra la fila', () async {
      await db.tareasDao.insertar(tarea('t1'), const [], 60);
      await db.tareasDao.actualizar(tarea('t1'), const [], null);

      expect((await db.tareasDao.buscar('t1'))!.recordatorio, isNull);
      expect(await db.select(db.reminders).get(), isEmpty);
    });

    test('actualizar una tarea inexistente devuelve false', () async {
      expect(
        await db.tareasDao.actualizar(tarea('nada'), const [], null),
        isFalse,
      );
    });

    test('eliminar borra en cascada subtareas y recordatorio', () async {
      await db.tareasDao.insertar(tarea('t1'), [subtarea('s1', 't1', 0)], 60);

      await db.tareasDao.eliminar('t1');

      expect(await db.select(db.tasks).get(), isEmpty);
      expect(await db.select(db.subtasks).get(), isEmpty);
      expect(await db.select(db.reminders).get(), isEmpty);
    });

    test(
      'la clave foránea no deja crear tareas de un curso inexistente',
      () async {
        await expectLater(
          db.tareasDao.insertar(
            tarea('t1', cursoId: 'fantasma'),
            const [],
            null,
          ),
          throwsA(isA<SqliteException>()),
        );
      },
    );

    test('la clave foránea no deja borrar un curso con tareas', () async {
      await db.tareasDao.insertar(tarea('t1'), const [], null);

      await expectLater(
        db.cursosDao.eliminar('c1'),
        throwsA(isA<SqliteException>()),
      );
    });

    test('el stream vuelve a emitir cuando cambia solo una subtarea', () async {
      await db.tareasDao.insertar(tarea('t1'), [subtarea('s1', 't1', 0)], null);

      final valores = <bool>[];
      final primera = Completer<void>();
      final segunda = Completer<void>();
      final suscripcion = db.tareasDao.observar().listen((tareas) {
        valores.add(tareas.single.subtareas.single.hecha);
        if (!primera.isCompleted) {
          primera.complete();
        } else if (!segunda.isCompleted) {
          segunda.complete();
        }
      });
      addTearDown(suscripcion.cancel);

      await primera.future;
      await db.tareasDao.actualizar(tarea('t1'), [
        subtarea('s1', 't1', 0).copyWith(hecha: const Value(true)),
      ], null);
      await segunda.future;

      expect(valores, [false, true]);
    });
  });
}
