import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/db/app_database.dart';
import 'package:pdm2026e_equipo_05_unitasks/providers/providers.dart';

import '../support/fakes.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
  });
  tearDown(() async {
    container.dispose();
    await db.close();
  });

  test('tareasProvider refleja lo que se escribe por el repositorio', () async {
    final cursos = container.read(courseRepositoryProvider);
    final tareas = container.read(taskRepositoryProvider);
    await cursos.crear(cursoPrueba());

    // Mantener el provider escuchado, como lo haría una pantalla.
    final suscripcion = container.listen(tareasProvider, (_, _) {});
    addTearDown(suscripcion.close);
    expect(await container.read(tareasProvider.future), isEmpty);

    await tareas.crear(tareaPrueba(titulo: 'Desde el repositorio'));
    await pumpEventQueue();

    final lista = await container.read(tareasProvider.future);
    expect(lista.single.titulo, 'Desde el repositorio');
  });

  // Riverpod 3 pausa los providers que nadie escucha; aquí se escuchan
  // como lo haría una pantalla antes de leer su valor.
  Future<T> leer<T>(ProviderListenable<Future<T>> provider) {
    final suscripcion = container.listen(provider, (_, _) {});
    addTearDown(suscripcion.close);
    return suscripcion.read();
  }

  test('resumenCursosProvider combina cursos y tareas', () async {
    await container.read(courseRepositoryProvider).crear(cursoPrueba());
    final tareas = container.read(taskRepositoryProvider);
    await tareas.crear(tareaPrueba(id: 't1'));
    await tareas.crear(tareaPrueba(id: 't2').alternarCompletada());

    final resumen = await leer(resumenCursosProvider.future);

    expect(resumen.single.totalTareas, 2);
    expect(resumen.single.pendientes, 1);
  });

  test('tareaProvider busca por id y da null si no existe', () async {
    await container.read(courseRepositoryProvider).crear(cursoPrueba());
    await container.read(taskRepositoryProvider).crear(tareaPrueba());

    expect(
      (await leer(tareaProvider('tarea-a').future))?.titulo,
      'Tarea de prueba',
    );
    expect(await leer(tareaProvider('otra').future), isNull);
  });

  test('sin sobrescribir la base, el error explica qué falta', () {
    final sinBase = ProviderContainer();
    addTearDown(sinBase.dispose);

    expect(() => sinBase.read(taskRepositoryProvider), throwsA(anything));
  });
}
