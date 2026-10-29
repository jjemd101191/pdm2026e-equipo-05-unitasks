import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/course_repository.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/db/app_database.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/drift_course_repository.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/drift_task_repository.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/seed_data.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/task_repository.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/task.dart';

import '../support/fakes.dart';

void main() {
  // Cada prueba abre su propia base; no comparten conexión.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('con base en memoria', () {
    late AppDatabase db;
    late DriftCourseRepository cursos;
    late DriftTaskRepository tareas;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      cursos = DriftCourseRepository(db);
      tareas = DriftTaskRepository(db);
      await cursos.crear(cursoPrueba());
    });
    tearDown(() => db.close());

    test('un curso vuelve igual a como se guardó', () async {
      final curso = cursoPrueba(
        id: 'moviles',
        nombre: 'Dispositivos Móviles',
        color: const Color(0xFF0EA5E9),
      ).copyWith(dias: ['Lun', 'Mié'], horaInicio: '10:00', horaFin: '12:00');

      await cursos.crear(curso);
      final guardados = await cursos.watchCursos().first;

      expect(guardados, contains(curso));
    });

    test('actualizar un curso cambia sus datos', () async {
      await cursos.actualizar(cursoPrueba(nombre: 'Nombre nuevo'));
      final guardado = (await cursos.watchCursos().first).single;
      expect(guardado.nombre, 'Nombre nuevo');
    });

    test(
      'eliminar un curso con tareas lanza CursoConTareasException',
      () async {
        await tareas.crear(tareaPrueba(id: 't1'));
        await tareas.crear(tareaPrueba(id: 't2'));

        await expectLater(
          cursos.eliminar('curso-a'),
          throwsA(
            isA<CursoConTareasException>().having(
              (e) => e.cantidadTareas,
              'cantidadTareas',
              2,
            ),
          ),
        );
        expect(await cursos.watchCursos().first, hasLength(1));
      },
    );

    test('un curso sin tareas se elimina y se puede volver a crear', () async {
      await cursos.eliminar('curso-a');
      expect(await cursos.watchCursos().first, isEmpty);

      await cursos.crear(cursoPrueba());
      expect(await cursos.watchCursos().first, [cursoPrueba()]);
    });

    test('una tarea vuelve igual a como se guardó', () async {
      final tarea = tareaPrueba(
        titulo: 'Proyecto final',
        prioridad: Prioridad.alta,
        tipo: TipoTarea.proyecto,
        estado: EstadoTarea.enProgreso,
        fechaEntrega: DateTime(2026, 11, 20, 18, 30),
        recordatorioMinutos: 24 * 60,
        subtareas: const [
          Subtask(id: 's1', titulo: 'Diagrama', hecha: true),
          Subtask(id: 's2', titulo: 'Código'),
        ],
      );

      await tareas.crear(tarea);

      expect(await tareas.obtenerTarea(tarea.id), tarea);
    });

    test('actualizar reemplaza subtareas y recordatorio', () async {
      final original = tareaPrueba(
        // SQLite guarda las fechas al segundo; una fecha "redonda" evita
        // diferencias de microsegundos al comparar.
        fechaEntrega: DateTime(2026, 11, 5, 23, 59),
        recordatorioMinutos: 60,
        subtareas: const [Subtask(id: 's1', titulo: 'Uno')],
      );
      await tareas.crear(original);

      final editada = original
          .alternarCompletada()
          .agregarSubtarea(const Subtask(id: 's2', titulo: 'Dos'))
          .copyWith(titulo: 'Editada', quitarRecordatorio: true);
      await tareas.actualizar(editada);

      final leida = await tareas.obtenerTarea(original.id);
      expect(leida, editada);
      expect(leida!.recordatorioMinutos, isNull);
    });

    test('actualizar una tarea que no existe lanza una excepción', () async {
      await expectLater(
        tareas.actualizar(tareaPrueba(id: 'no-existe')),
        throwsA(isA<TareaNoEncontradaException>()),
      );
    });

    test('eliminar quita la tarea', () async {
      await tareas.crear(tareaPrueba());
      await tareas.eliminar('tarea-a');

      expect(await tareas.obtenerTarea('tarea-a'), isNull);
      expect(await tareas.watchTareas().first, isEmpty);
    });

    test('watchTareas avisa los cambios hechos desde otro lado', () async {
      final emisiones = tareas.watchTareas().map(
        (lista) => lista.map((t) => t.titulo).toList(),
      );
      final esperado = expectLater(emisiones, emitsThrough(['Recién creada']));

      await tareas.crear(tareaPrueba(titulo: 'Recién creada'));
      await esperado;
    });

    test('las semillas cargan 4 cursos y 8 tareas', () async {
      final semillas = AppDatabase(
        NativeDatabase.memory(),
        alCrear: sembrarDatosIniciales,
      );
      addTearDown(semillas.close);

      final cursosSemilla = await DriftCourseRepository(
        semillas,
      ).watchCursos().first;
      final tareasSemilla = await DriftTaskRepository(
        semillas,
      ).watchTareas().first;

      expect(cursosSemilla, hasLength(4));
      expect(tareasSemilla, hasLength(8));
      expect(tareasSemilla.where((t) => !t.completada), hasLength(6));
      final avance = tareasSemilla.firstWhere(
        (t) => t.id == 'demo-avance-proyecto',
      );
      expect(avance.subtareas, hasLength(4));
      expect(avance.completadas, 3);
      expect(avance.recordatorioMinutos, 24 * 60);
    });
  });

  group('en un archivo', () {
    late Directory carpeta;

    setUp(() async {
      carpeta = await Directory.systemTemp.createTemp('tasku_test_');
    });
    tearDown(() => carpeta.delete(recursive: true));

    test('los datos sobreviven a cerrar y reabrir la base', () async {
      final archivo = File('${carpeta.path}/tasku.sqlite');

      final primera = AppDatabase(
        NativeDatabase(archivo),
        alCrear: sembrarDatosIniciales,
      );
      final repositorio = DriftTaskRepository(primera);
      final original = await repositorio.obtenerTarea('demo-laboratorio-sql');
      await repositorio.actualizar(
        original!.copyWith(titulo: 'Título persistido').alternarCompletada(),
      );
      await primera.close();

      var sembradas = 0;
      final segunda = AppDatabase(
        NativeDatabase(archivo),
        alCrear: (_) async => sembradas++,
      );
      addTearDown(segunda.close);
      final recuperada = await DriftTaskRepository(
        segunda,
      ).obtenerTarea('demo-laboratorio-sql');

      expect(recuperada!.titulo, 'Título persistido');
      expect(recuperada.completada, isTrue);
      expect(recuperada.subtareas.every((s) => s.hecha), isTrue);
      expect(sembradas, 0, reason: 'las semillas solo van en la primera vez');
    });
  });
}
