import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/course_repository.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/hive_course_repository.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/hive_task_repository.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/local_store.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/seed_data.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/task.dart';

import 'support/fakes.dart';

void main() {
  late Directory temporal;

  setUpAll(() async {
    temporal = await Directory.systemTemp.createTemp('tasku_test_');
  });

  tearDownAll(() async {
    await Hive.close();
    if (await temporal.exists()) {
      await temporal.delete(recursive: true);
    }
  });

  test('la primera apertura siembra cursos y tareas una sola vez', () async {
    final store = await LocalStore.abrir(ruta: temporal.path, sufijo: 'a');
    addTearDown(store.cerrar);

    await sembrarDatosIniciales(store);
    final cursos = await HiveCourseRepository(store).obtenerCursos();
    final tareas = await HiveTaskRepository(store).obtenerTareas();

    expect(cursos, hasLength(4));
    expect(tareas, hasLength(8));
    expect(await HiveTaskRepository(store).contarActivas(), 6);

    // Sembrar de nuevo no duplica ni sobrescribe.
    await sembrarDatosIniciales(store);
    expect(await HiveTaskRepository(store).obtenerTareas(), hasLength(8));
  });

  test('una tarea guardada se recupera después de cerrar y reabrir', () async {
    final store = await LocalStore.abrir(ruta: temporal.path, sufijo: 'b');
    await sembrarDatosIniciales(store);
    final repositorio = HiveTaskRepository(store);
    final original = (await repositorio.obtenerTareas()).first;

    final editada = original.copyWith(
      titulo: 'Título persistido',
      estado: EstadoTarea.completada,
    );
    await repositorio.guardarTarea(editada);
    await store.cerrar();

    final reabierto = await LocalStore.abrir(ruta: temporal.path, sufijo: 'b');
    addTearDown(reabierto.cerrar);
    final recuperada = await HiveTaskRepository(
      reabierto,
    ).obtenerTarea(original.id);

    expect(recuperada, isNotNull);
    expect(recuperada!.titulo, 'Título persistido');
    expect(recuperada.completada, isTrue);
    expect(recuperada.curso.nombre, original.curso.nombre);
    expect(recuperada.subtareas.length, original.subtareas.length);
  });

  test('los campos del modelo sobreviven a la serialización', () async {
    final store = await LocalStore.abrir(ruta: temporal.path, sufijo: 'c');
    addTearDown(store.cerrar);
    await sembrarDatosIniciales(store);

    final tarea = (await HiveTaskRepository(store).obtenerTareas()).firstWhere(
      (actual) => actual.id == 'demo-avance-proyecto',
    );

    expect(tarea.prioridad, Prioridad.alta);
    expect(tarea.tipo, TipoTarea.proyecto);
    expect(tarea.estado, EstadoTarea.enProgreso);
    expect(tarea.recordatorio, RecordatorioOpcion.unDia);
    expect(tarea.fechaEntrega, isNotNull);
    expect(tarea.subtareas, hasLength(4));
    expect(tarea.completadas, 3);
  });

  test('no se elimina un curso que tiene tareas', () async {
    final store = await LocalStore.abrir(ruta: temporal.path, sufijo: 'd');
    addTearDown(store.cerrar);
    await sembrarDatosIniciales(store);

    final cursos = HiveCourseRepository(store);
    await expectLater(
      cursos.eliminarCurso('dispositivos-moviles'),
      throwsA(isA<CursoConTareasException>()),
    );
    expect(await cursos.obtenerCurso('dispositivos-moviles'), isNotNull);
  });

  test('un curso sin tareas se elimina y se puede restaurar', () async {
    final store = await LocalStore.abrir(ruta: temporal.path, sufijo: 'e');
    addTearDown(store.cerrar);
    final repositorio = HiveCourseRepository(store);
    final curso = cursoPrueba(
      id: 'curso-sin-tareas',
      nombre: 'Curso sin tareas',
    );

    await repositorio.guardarCurso(curso);
    await repositorio.eliminarCurso(curso.id);
    expect(await repositorio.obtenerCurso(curso.id), isNull);

    await repositorio.restaurarCurso(curso);
    expect(
      (await repositorio.obtenerCurso(curso.id))!.nombre,
      'Curso sin tareas',
    );
  });
}
