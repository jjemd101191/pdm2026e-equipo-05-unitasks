import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/db/app_database.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/drift_course_repository.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/seed_data.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/sync/estado_sync.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/sync/modelos_remotos.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/sync/repos_sincronizados.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/sync/sincronizador.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/course.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/task.dart';

import '../support/fakes.dart';
import '../support/remoto_sync_memoria.dart';

void main() {
  late AppDatabase db;
  late RemotoSyncMemoria remoto;
  late Sincronizador sync;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    remoto = RemotoSyncMemoria();
    sync = Sincronizador(db: db, remoto: remoto, usuarioId: 'u1');
  });

  tearDown(() async {
    await sync.detener();
    // Deja terminar las aplicaciones que ya estaban en curso antes de cerrar
    // la base (los escuchas se cancelan, pero un listen ya despachado sigue).
    await Future<void>.delayed(const Duration(milliseconds: 30));
    await db.close();
    await remoto.cerrar();
  });

  CursoRemoto cursoRemoto(Course curso, DateTime marca) =>
      CursoRemoto(curso: curso, actualizadaEn: marca, creadaEn: marca);

  TareaRemota tareaRemota(Task tarea, DateTime marca) =>
      TareaRemota(tarea: tarea, actualizadaEn: marca, creadaEn: marca);

  test('una cuenta nueva recibe los datos de ejemplo y los sube', () async {
    await sync.iniciar();

    final cursos = await db.cursosDao.todos('u1');
    final tareas = await db.tareasDao.todos('u1');
    expect(cursos, hasLength(4));
    expect(tareas, hasLength(8));
    expect(cursos.every((fila) => fila.usuarioId == 'u1'), isTrue);
    expect(remoto.cursos('u1'), hasLength(4));
    expect(remoto.tareas('u1'), hasLength(8));
    expect(sync.estado.value, EstadoSync.alDia);
  });

  test('las filas locales sin dueño se adoptan en el primer login', () async {
    await sembrarDatosIniciales(db);

    await sync.iniciar();

    final cursos = await db.cursosDao.todos('u1');
    expect(cursos, hasLength(4));
    expect(cursos.every((fila) => fila.usuarioId == 'u1'), isTrue);
    expect(await db.cursosDao.todos(''), isEmpty);
    expect(await db.tareasDao.todos(''), isEmpty);
    expect(remoto.cursos('u1'), hasLength(4));
    expect(remoto.tareas('u1'), hasLength(8));
  });

  test('descarga cursos, tareas, subtareas y recordatorio', () async {
    final marca = DateTime(2026, 11, 1, 12);
    await remoto.guardarCurso('u1', cursoRemoto(cursoPrueba(), marca));
    await remoto.guardarTarea(
      'u1',
      tareaRemota(
        tareaPrueba(
          recordatorioMinutos: 60,
          subtareas: const [Subtask(id: 's1', titulo: 'Leer', hecha: true)],
        ),
        marca,
      ),
    );

    await sync.iniciar();

    final cursos = await db.cursosDao.todos('u1');
    expect(cursos.single.nombre, 'Curso A');
    final tareas = await db.tareasDao.todos('u1');
    expect(tareas.single.tarea.titulo, 'Tarea de prueba');
    expect(tareas.single.subtareas.single.titulo, 'Leer');
    expect(tareas.single.subtareas.single.hecha, isTrue);
    expect(tareas.single.recordatorio!.minutosAntes, 60);
  });

  test('un cambio local más reciente no lo pisa el remoto', () async {
    final viejo = DateTime(2026, 10, 1);
    final nuevo = DateTime(2026, 11, 1);
    await remoto.guardarCurso(
      'u1',
      cursoRemoto(cursoPrueba(nombre: 'Versión remota'), viejo),
    );
    await db.cursosDao.insertar(
      cursoAFila(
        cursoPrueba(nombre: 'Versión local'),
        usuarioId: 'u1',
        actualizadaEn: nuevo,
        creadaEn: viejo,
      ),
    );

    await sync.iniciar();

    final cursos = await db.cursosDao.todos('u1');
    expect(cursos.single.nombre, 'Versión local');
    expect(remoto.cursos('u1')['curso-a']!.curso.nombre, 'Versión remota');
  });

  test('no toca los datos de otra cuenta', () async {
    final marca = DateTime(2026, 11, 1);
    await db.cursosDao.insertar(
      cursoAFila(
        cursoPrueba(id: 'curso-b', nombre: 'De otra cuenta'),
        usuarioId: 'u2',
        actualizadaEn: marca,
        creadaEn: marca,
      ),
    );
    await remoto.guardarCurso('u1', cursoRemoto(cursoPrueba(), marca));

    await sync.iniciar();

    final deU1 = await db.cursosDao.todos('u1');
    expect(deU1.map((fila) => fila.id), ['curso-a']);
    final deU2 = await db.cursosDao.todos('u2');
    expect(deU2.single.nombre, 'De otra cuenta');
  });

  test('un borrado remoto se aplica a la copia local', () async {
    final marca = DateTime(2026, 11, 1);
    await remoto.guardarCurso('u1', cursoRemoto(cursoPrueba(), marca));
    await sync.iniciar();
    expect(await db.cursosDao.todos('u1'), hasLength(1));

    await remoto.eliminarCurso('u1', 'curso-a');
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(await db.cursosDao.todos('u1'), isEmpty);
  });

  test('el repositorio sincronizado copia las altas a la nube', () async {
    final local = DriftCourseRepository(db, usuarioId: 'u1');
    final repositorio = CursoRepoSincronizado(
      local: local,
      remoto: remoto,
      usuarioId: 'u1',
    );

    await repositorio.crear(cursoPrueba());
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(remoto.cursos('u1'), contains('curso-a'));
    expect((await db.cursosDao.todos('u1')).single.nombre, 'Curso A');
  });

  test('sin conexión la app conserva los datos locales', () async {
    remoto.sinConexion = true;

    await sync.iniciar();

    // Se sembró localmente antes de fallar la subida.
    expect(await db.cursosDao.todos('u1'), hasLength(4));
    expect(sync.estado.value, isNot(EstadoSync.alDia));
  });
}
