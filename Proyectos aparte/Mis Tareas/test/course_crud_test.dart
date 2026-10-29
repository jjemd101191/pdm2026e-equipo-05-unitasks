import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/data/course_repository.dart';
import 'package:flutter_application_1/data/curso_dao.dart';
import 'package:flutter_application_1/data/cursos_provider.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/course.dart';
import 'package:flutter_application_1/models/course_filter.dart';
import 'package:flutter_application_1/screens/course_list_screen.dart';
import 'package:flutter_application_1/theme.dart';

Course curso(String id, String nombre, {int pendientes = 1}) => Course(
  id: id,
  nombre: nombre,
  docente: 'Docente $nombre',
  color: kIndigo,
  dias: const ['Lun'],
  horaInicio: '8:00',
  horaFin: '10:00',
  pendientes: pendientes,
  totalTareas: 3,
);

class DaoFalso extends DemoCursoDao {
  DaoFalso(List<Course> cursos, {Map<String, int>? tareas})
    : super(cursos: cursos, tareas: tareas ?? {});
  int consultas = 0;
  bool fallaCarga = false,
      fallaGuardar = false,
      fallaBorrar = false,
      fallaArchivar = false,
      fallaConteo = false,
      carrera = false;
  Completer<List<Course>>? espera;
  @override
  Future<List<Course>> obtenerCursos() async {
    consultas++;
    if (fallaCarga) throw StateError('fallo');
    if (espera != null) return espera!.future;
    return super.obtenerCursos();
  }

  @override
  Future<void> guardarCurso(Course curso) async {
    if (fallaGuardar) throw StateError('fallo');
    return super.guardarCurso(curso);
  }

  @override
  Future<int> tareasDe(String id) async {
    if (fallaConteo) throw StateError('fallo');
    return super.tareasDe(id);
  }

  @override
  Future<void> eliminarCurso(String id) async {
    if (fallaBorrar) throw StateError('fallo');
    if (carrera) throw const CursoEnUsoException(2);
    return super.eliminarCurso(id);
  }

  @override
  Future<void> archivarCurso(String id) async {
    if (fallaArchivar) throw StateError('fallo');
    return super.archivarCurso(id);
  }
}

Future<void> abrir(WidgetTester tester, DaoFalso dao) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [cursoDaoProvider.overrideWithValue(dao)],
      child: MaterialApp(
        theme: buildMisTareasTheme(),
        home: const CourseListScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> borrar(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Opciones del curso').first);
  await tester.pumpAndSettle();
  await tester.tap(find.text('Eliminar curso'));
  await tester.pumpAndSettle();
}

void main() {
  test('filtro inmutable y copyWith conserva identidad y archivado', () {
    const filtro = CourseFilter(periodo: '2026-2');
    expect(
      filtro.copyWith(texto: 'base'),
      const CourseFilter(periodo: '2026-2', texto: 'base'),
    );
    expect(filtro.texto, isEmpty);
    final original = curso('uno', 'Base').copyWith(archivado: true);
    final editado = original.copyWith(nombre: 'Datos');
    expect(editado.id, original.id);
    expect(editado.archivado, isTrue);
    expect(editado.totalTareas, original.totalTareas);
    expect(original.nombre, 'Base');
  });
  testWidgets('app mantiene pestañas, cursos y datos de demostración', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();
    expect(find.text('Mis Tareas'), findsOneWidget);
    await tester.tap(find.text('Cursos'));
    await tester.pumpAndSettle();
    expect(find.text('Mis cursos'), findsOneWidget);
    expect(find.text('4 pendientes'), findsOneWidget);
  });
  testWidgets('carga, error y reintento consultan al DAO', (tester) async {
    final dao = DaoFalso([curso('a', 'Base')])..fallaCarga = true;
    await abrir(tester, dao);
    expect(find.text('Reintentar'), findsOneWidget);
    dao.fallaCarga = false;
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.text('Base'), findsOneWidget);
    expect(dao.consultas, 2);
  });
  testWidgets('muestra indicador mientras consulta y estado vacío después', (
    tester,
  ) async {
    final dao = DaoFalso([])..espera = Completer<List<Course>>();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [cursoDaoProvider.overrideWithValue(dao)],
        child: const MaterialApp(home: CourseListScreen()),
      ),
    );
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    dao.espera!.complete([]);
    await tester.pumpAndSettle();
    expect(find.text('Aún no hay cursos.'), findsOneWidget);
    expect(find.text('+ Agregar curso'), findsOneWidget);
  });
  testWidgets('búsqueda por nombre o docente y chips conservan el filtro', (
    tester,
  ) async {
    final dao = DaoFalso([
      curso('a', 'Base'),
      curso('b', 'Redes', pendientes: 0),
    ]);
    await abrir(tester, dao);
    await tester.enterText(find.byType(TextField), 'docente base');
    await tester.pumpAndSettle();
    expect(find.text('Base'), findsOneWidget);
    expect(find.text('Redes'), findsNothing);
    await tester.tap(find.text('Con pendientes'));
    await tester.pumpAndSettle();
    expect(find.text('Base'), findsOneWidget);
    expect(dao.consultas, 1);
    await tester.tap(find.byTooltip('Limpiar búsqueda'));
    await tester.tap(find.text('Todos'));
    await tester.pumpAndSettle();
    expect(find.text('Redes'), findsOneWidget);
  });
  testWidgets('crear refresca desde DAO sin recargar a mano', (tester) async {
    final dao = DaoFalso([]);
    await abrir(tester, dao);
    await tester.tap(find.byTooltip('Agregar curso'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Nuevo curso');
    await tester.tap(find.text('Guardar curso'));
    await tester.pumpAndSettle();
    expect(find.text('Nuevo curso'), findsOneWidget);
    expect(dao.cursos.single.nombre, 'Nuevo curso');
    expect(dao.consultas, 2);
  });
  testWidgets('tocar tarjeta abre formulario lleno y guarda conservando id', (
    tester,
  ) async {
    final original = curso('id-estable', 'Base');
    final dao = DaoFalso([original]);
    await abrir(tester, dao);
    await tester.tap(find.text('Base'));
    await tester.pumpAndSettle();
    expect(find.text('Editar curso'), findsOneWidget);
    expect(find.text('Base'), findsOneWidget);
    expect(find.text('Docente Base'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'Base actualizada');
    await tester.tap(find.text('Guardar cambios'));
    await tester.pumpAndSettle();
    expect(find.text('Base actualizada'), findsOneWidget);
    expect(dao.cursos.single.id, 'id-estable');
    expect(dao.cursos.single.totalTareas, original.totalTareas);
    expect(dao.consultas, 2);
  });
  testWidgets(
    'duplicado muestra mensaje humano y conserva formulario y datos',
    (tester) async {
      final dao = DaoFalso([curso('a', 'Base'), curso('b', 'Redes')]);
      await abrir(tester, dao);
      await tester.tap(find.text('Redes'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, '  BASE  ');
      await tester.tap(find.text('Guardar cambios'));
      await tester.pumpAndSettle();
      expect(
        find.text('Ya existe un curso con ese nombre en este periodo.'),
        findsOneWidget,
      );
      expect(find.text('Editar curso'), findsOneWidget);
      expect(dao.cursos.last.nombre, 'Redes');
    },
  );
  testWidgets('guardar falla sin perder los datos escritos', (tester) async {
    final dao = DaoFalso([])..fallaGuardar = true;
    await abrir(tester, dao);
    await tester.tap(find.byTooltip('Agregar curso'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Curso pendiente');
    await tester.tap(find.text('Guardar curso'));
    await tester.pumpAndSettle();
    expect(find.text('Curso pendiente'), findsOneWidget);
    expect(
      find.text('No se pudo guardar el curso. Inténtalo de nuevo.'),
      findsOneWidget,
    );
    expect(dao.cursos, isEmpty);
  });
  testWidgets('nombre vacío no se guarda', (tester) async {
    final dao = DaoFalso([]);
    await abrir(tester, dao);
    await tester.tap(find.byTooltip('Agregar curso'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar curso'));
    await tester.pumpAndSettle();
    expect(find.text('Escribe el nombre del curso'), findsOneWidget);
    expect(dao.cursos, isEmpty);
  });
  testWidgets('curso en uso no se borra y archivar conserva tareas e id', (
    tester,
  ) async {
    final dao = DaoFalso([curso('a', 'Base')], tareas: {'a': 12});
    await abrir(tester, dao);
    await borrar(tester);
    expect(
      find.text('Tiene 12 tareas. Archívalo para dejar de verlo.'),
      findsOneWidget,
    );
    expect(dao.cursos, hasLength(1));
    await tester.tap(find.text('Archivar'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('a')), findsNothing);
    expect(dao.cursos.single.archivado, isTrue);
    expect(dao.tareas['a'], 12);
    await tester.tap(find.text('Archivados'));
    await tester.pumpAndSettle();
    expect(find.text('Base'), findsOneWidget);
  });
  testWidgets('deslizar también bloquea borrado de cursos en uso', (
    tester,
  ) async {
    final dao = DaoFalso([curso('a', 'Base')], tareas: {'a': 12});
    await abrir(tester, dao);
    await tester.drag(find.byKey(const ValueKey('a')), const Offset(-600, 0));
    await tester.pumpAndSettle();
    expect(find.text('Curso en uso'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('a')), findsOneWidget);
    expect(dao.cursos.single.archivado, isFalse);
  });
  testWidgets('borrar sin tareas y deshacer refresca y conserva id', (
    tester,
  ) async {
    final dao = DaoFalso([curso('a', 'Base')]);
    await abrir(tester, dao);
    await borrar(tester);
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();
    expect(dao.cursos, isEmpty);
    await tester.tap(find.text('Deshacer'));
    await tester.pumpAndSettle();
    expect(find.text('Base'), findsOneWidget);
    expect(dao.cursos.single.id, 'a');
    expect(dao.consultas, 3);
  });
  testWidgets('deslizar sin tareas elimina solo después de confirmar', (
    tester,
  ) async {
    final dao = DaoFalso([curso('a', 'Base')]);
    await abrir(tester, dao);
    await tester.drag(find.byKey(const ValueKey('a')), const Offset(-600, 0));
    await tester.pumpAndSettle();
    expect(dao.cursos, hasLength(1));
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();
    expect(dao.cursos, isEmpty);
    expect(tester.takeException(), isNull);
  });
  testWidgets('fallo al borrar mantiene curso visible', (tester) async {
    final dao = DaoFalso([curso('a', 'Base')])..fallaBorrar = true;
    await abrir(tester, dao);
    await borrar(tester);
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();
    expect(find.text('Base'), findsOneWidget);
    expect(dao.cursos, hasLength(1));
    expect(
      find.text('No se pudo eliminar el curso. Inténtalo de nuevo.'),
      findsOneWidget,
    );
  });
  testWidgets('fallo de conteo nunca permite borrar', (tester) async {
    final dao = DaoFalso([curso('a', 'Base')])..fallaConteo = true;
    await abrir(tester, dao);
    await borrar(tester);
    expect(dao.cursos, hasLength(1));
    expect(find.text('Eliminar'), findsNothing);
  });
  testWidgets('fallo al archivar conserva el registro activo', (tester) async {
    final dao = DaoFalso([curso('a', 'Base')], tareas: {'a': 1})
      ..fallaArchivar = true;
    await abrir(tester, dao);
    await borrar(tester);
    await tester.tap(find.text('Archivar'));
    await tester.pumpAndSettle();
    expect(dao.cursos.single.archivado, isFalse);
    expect(
      find.text('No se pudo archivar el curso. Inténtalo de nuevo.'),
      findsOneWidget,
    );
  });
  testWidgets('dependencia nueva durante borrado ofrece archivar', (
    tester,
  ) async {
    final dao = DaoFalso([curso('a', 'Base')])..carrera = true;
    await abrir(tester, dao);
    await borrar(tester);
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();
    expect(
      find.text('Tiene 2 tareas. Archívalo para dejar de verlo.'),
      findsOneWidget,
    );
    expect(dao.cursos, hasLength(1));
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
  });
  testWidgets('pantalla móvil conserva tema y no desborda', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final boundary = GlobalKey();
    await tester.pumpWidget(
      ProviderScope(
        child: RepaintBoundary(key: boundary, child: const MyApp()),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Cursos'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final render =
        boundary.currentContext!.findRenderObject() as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final image = await render.toImage();
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      await Directory('build/evidencias').create(recursive: true);
      await File(
        'build/evidencias/cursos.png',
      ).writeAsBytes(bytes!.buffer.asUint8List());
      image.dispose();
    });
    await tester.tap(find.byTooltip('Agregar curso'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.runAsync(() async {
      final image = await render.toImage();
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      await File(
        'build/evidencias/formulario.png',
      ).writeAsBytes(bytes!.buffer.asUint8List());
      image.dispose();
    });
  });
}
