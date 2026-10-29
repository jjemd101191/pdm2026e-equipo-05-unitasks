import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/course_repository.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/demo_data.dart';
import 'package:pdm2026e_equipo_05_unitasks/main.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/course.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/course_filter.dart';
import 'package:pdm2026e_equipo_05_unitasks/screens/course_list_screen.dart';

Course _curso(String id, String nombre, {int pendientes = 1}) => Course(
  id: id,
  nombre: nombre,
  docente: 'Docente $nombre',
  color: Colors.indigo,
  dias: const ['Lun'],
  horaInicio: '8:00',
  horaFin: '10:00',
  pendientes: pendientes,
  totalTareas: 3,
);

class _RepositorioEnMemoria implements CourseRepository {
  _RepositorioEnMemoria(List<Course> cursos) : cursos = List.of(cursos);

  final List<Course> cursos;
  bool fallaAlEliminar = false;

  @override
  Future<List<Course>> obtenerCursos() async => List.of(cursos);

  @override
  Future<void> eliminarCurso(String id) async {
    if (fallaAlEliminar) throw StateError('fallo de almacenamiento');
    final indice = cursos.indexWhere((curso) => curso.id == id);
    if (indice < 0) throw StateError('curso inexistente');
    cursos.removeAt(indice);
  }

  @override
  Future<void> restaurarCurso(Course curso, {int? indice}) async {
    cursos.insert(indice ?? cursos.length, curso);
  }

  @override
  Future<void> guardarCurso(Course curso) async {
    final indice = cursos.indexWhere((actual) => actual.id == curso.id);
    if (indice < 0) {
      cursos.add(curso);
    } else {
      cursos[indice] = curso;
    }
  }
}

class _RepositorioFallido extends _RepositorioEnMemoria {
  _RepositorioFallido() : super(const []);

  @override
  Future<List<Course>> obtenerCursos() async => throw Exception('sin conexión');
}

class _RepositorioIntermitente extends _RepositorioEnMemoria {
  _RepositorioIntermitente() : super(cursosDemo);
  int llamadas = 0;

  @override
  Future<List<Course>> obtenerCursos() async {
    llamadas++;
    if (llamadas == 1) throw Exception('sin conexión');
    return List.of(cursosDemo);
  }
}

void main() {
  test('el filtro es inmutable y compara sus valores', () {
    const inicial = CourseFilter(periodo: '2026-2');
    final actualizado = inicial.copyWith(texto: 'móviles');
    expect(inicial.texto, isEmpty);
    expect(
      actualizado,
      const CourseFilter(periodo: '2026-2', texto: 'móviles'),
    );
    expect(
      actualizado.hashCode,
      const CourseFilter(periodo: '2026-2', texto: 'móviles').hashCode,
    );
  });

  testWidgets('TaskU abre en la pestaña de cursos con los datos de demo', (
    tester,
  ) async {
    await tester.pumpWidget(const TaskUApp());
    await tester.pumpAndSettle();
    expect(find.text('Mis cursos'), findsOneWidget);
    expect(find.text('Dispositivos Móviles'), findsWidgets);
    expect(find.text('4 pendientes'), findsOneWidget);
  });

  testWidgets('muestra el error y el botón Reintentar si falla la carga', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: CourseListScreen(repositorio: _RepositorioFallido())),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('No pudimos cargar'), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);
  });

  testWidgets('Reintentar vuelve a cargar y muestra los datos', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CourseListScreen(repositorio: _RepositorioIntermitente()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.text('Reintentar'), findsNothing);
    expect(find.text('Dispositivos Móviles'), findsWidgets);
  });

  testWidgets('la búsqueda actualiza el listado al cambiar el filtro', (
    tester,
  ) async {
    final repositorio = _RepositorioEnMemoria([
      _curso('moviles', 'Dispositivos Móviles'),
      _curso('datos', 'Base de Datos'),
    ]);
    await tester.pumpWidget(
      MaterialApp(home: CourseListScreen(repositorio: repositorio)),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'base');
    await tester.pumpAndSettle();
    expect(find.text('Base de Datos'), findsOneWidget);
    expect(find.text('Dispositivos Móviles'), findsNothing);
  });

  testWidgets('deslizar borra y Deshacer restaura el mismo curso e id', (
    tester,
  ) async {
    final original = _curso('curso-b', 'Base de Datos');
    final repositorio = _RepositorioEnMemoria([
      _curso('curso-a', 'Dispositivos Móviles'),
      original,
      _curso('curso-c', 'Redes'),
    ]);
    await tester.pumpWidget(
      MaterialApp(home: CourseListScreen(repositorio: repositorio)),
    );
    await tester.pumpAndSettle();

    await tester.drag(
      find.byKey(const ValueKey('curso-b')),
      const Offset(-600, 0),
    );
    await tester.pumpAndSettle();
    expect(
      repositorio.cursos.map((curso) => curso.id),
      isNot(contains('curso-b')),
    );
    expect(find.text('Deshacer'), findsOneWidget);

    await tester.tap(find.text('Deshacer'));
    await tester.pumpAndSettle();
    expect(repositorio.cursos[1].id, original.id);
    expect(repositorio.cursos[1].nombre, original.nombre);
    expect(repositorio.cursos[1].docente, original.docente);
  });

  testWidgets('si falla el borrado, la fila sigue visible', (tester) async {
    final repositorio = _RepositorioEnMemoria([_curso('fallido', 'Sin borrar')])
      ..fallaAlEliminar = true;
    await tester.pumpWidget(
      MaterialApp(home: CourseListScreen(repositorio: repositorio)),
    );
    await tester.pumpAndSettle();
    await tester.drag(
      find.byKey(const ValueKey('fallido')),
      const Offset(-600, 0),
    );
    await tester.pumpAndSettle();
    expect(find.text('Sin borrar'), findsOneWidget);
    expect(repositorio.cursos, hasLength(1));
  });
}
