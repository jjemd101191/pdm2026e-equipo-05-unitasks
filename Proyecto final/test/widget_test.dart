import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_equipo_05_unitasks/main.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/course.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/course_filter.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/course_summary.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/task.dart';
import 'package:pdm2026e_equipo_05_unitasks/screens/course_list_screen.dart';

import 'support/fakes.dart';

class _RepositorioIntermitente extends CursoRepoMemoria {
  _RepositorioIntermitente(super.cursos);

  int intentos = 0;

  @override
  Future<List<Course>> obtenerCursos() async {
    intentos++;
    if (intentos == 1) throw Exception('sin conexión');
    return super.obtenerCursos();
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

  test('el filtro acepta resúmenes por periodo, pendientes y texto', () {
    final conPendientes = CourseSummary(
      curso: cursoPrueba(nombre: 'Dispositivos Móviles'),
      totalTareas: 3,
      pendientes: 1,
    );
    final sinPendientes = CourseSummary(
      curso: cursoPrueba(id: 'otro', nombre: 'Base de Datos'),
      totalTareas: 2,
      pendientes: 0,
    );

    expect(const CourseFilter(texto: 'móviles').acepta(conPendientes), isTrue);
    expect(const CourseFilter(texto: 'perez').acepta(conPendientes), isFalse);
    expect(
      const CourseFilter(soloPendientes: true).acepta(sinPendientes),
      isFalse,
    );
    expect(
      const CourseFilter(periodo: '2026-1').acepta(conPendientes),
      isFalse,
    );
  });

  testWidgets('TaskU abre en Inicio y muestra las tareas guardadas', (
    tester,
  ) async {
    final curso = cursoPrueba(nombre: 'Dispositivos Móviles');
    final cursos = CursoRepoMemoria([curso]);
    final tareas = TareaRepoMemoria([
      tareaPrueba(titulo: 'Entregar avance', curso: curso),
      tareaPrueba(
        id: 'completada',
        titulo: 'Práctica terminada',
        curso: curso,
        estado: EstadoTarea.completada,
      ),
    ]);

    await tester.pumpWidget(
      TaskUApp(courseRepository: cursos, taskRepository: tareas),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hola, Diego'), findsOneWidget);
    expect(find.text('Entregar avance'), findsOneWidget);
    expect(find.text('Práctica terminada'), findsNothing);
    expect(find.textContaining('1 tarea pendiente'), findsOneWidget);

    await tester.tap(find.text('Cursos'));
    await tester.pumpAndSettle();
    expect(find.text('Mis cursos'), findsOneWidget);
    expect(find.text('1 pendiente'), findsOneWidget);
  });

  testWidgets('muestra el error y el botón Reintentar si falla la carga', (
    tester,
  ) async {
    final cursos = CursoRepoMemoria()..fallaAlCargar = true;
    await tester.pumpWidget(
      MaterialApp(
        home: CourseListScreen(
          repositorio: cursos,
          tareasRepositorio: TareaRepoMemoria(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('No pudimos cargar'), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);
  });

  testWidgets('Reintentar vuelve a cargar y muestra los datos', (tester) async {
    final cursos = _RepositorioIntermitente([
      cursoPrueba(nombre: 'Dispositivos Móviles'),
    ]);
    await tester.pumpWidget(
      MaterialApp(
        home: CourseListScreen(
          repositorio: cursos,
          tareasRepositorio: TareaRepoMemoria(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.text('Reintentar'), findsNothing);
    expect(find.text('Dispositivos Móviles'), findsOneWidget);
  });

  testWidgets('la búsqueda filtra el listado sin recargar el repositorio', (
    tester,
  ) async {
    final cursos = CursoRepoMemoria([
      cursoPrueba(id: 'moviles', nombre: 'Dispositivos Móviles'),
      cursoPrueba(id: 'datos', nombre: 'Base de Datos'),
    ]);
    await tester.pumpWidget(
      MaterialApp(
        home: CourseListScreen(
          repositorio: cursos,
          tareasRepositorio: TareaRepoMemoria(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final llamadasIniciales = cursos.llamadas;

    await tester.enterText(find.byType(TextField), 'base');
    await tester.pumpAndSettle();
    expect(find.text('Base de Datos'), findsOneWidget);
    expect(find.text('Dispositivos Móviles'), findsNothing);
    expect(cursos.llamadas, llamadasIniciales);
  });

  testWidgets('deslizar borra y Deshacer restaura el mismo curso e id', (
    tester,
  ) async {
    final cursoB = cursoPrueba(id: 'curso-b', nombre: 'Base de Datos');
    final cursos = CursoRepoMemoria([
      cursoPrueba(id: 'curso-a', nombre: 'Dispositivos Móviles'),
      cursoB,
      cursoPrueba(id: 'curso-c', nombre: 'Redes'),
    ]);
    await tester.pumpWidget(
      MaterialApp(
        home: CourseListScreen(
          repositorio: cursos,
          tareasRepositorio: TareaRepoMemoria(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.drag(
      find.byKey(const ValueKey('curso-b')),
      const Offset(-600, 0),
    );
    await tester.pumpAndSettle();
    expect(cursos.cursos.map((curso) => curso.id), isNot(contains('curso-b')));
    expect(find.text('Deshacer'), findsOneWidget);

    await tester.tap(find.text('Deshacer'));
    await tester.pumpAndSettle();
    expect(cursos.cursos[1].id, cursoB.id);
    expect(cursos.cursos[1].nombre, cursoB.nombre);
  });

  testWidgets('no se puede eliminar un curso que tiene tareas', (tester) async {
    final curso = cursoPrueba(id: 'con-tareas', nombre: 'Con tareas');
    final cursos = CursoRepoMemoria([curso]);
    final tareas = TareaRepoMemoria([
      tareaPrueba(curso: curso, titulo: 'Pendiente del curso'),
    ]);
    cursos.tareas = tareas;

    await tester.pumpWidget(
      MaterialApp(
        home: CourseListScreen(repositorio: cursos, tareasRepositorio: tareas),
      ),
    );
    await tester.pumpAndSettle();

    await tester.drag(
      find.byKey(const ValueKey('con-tareas')),
      const Offset(-600, 0),
    );
    await tester.pumpAndSettle();

    expect(find.text('No se puede eliminar'), findsOneWidget);
    expect(find.textContaining('asociada'), findsOneWidget);
    expect(cursos.cursos, hasLength(1));
    expect(find.text('Con tareas'), findsOneWidget);
  });

  testWidgets('si falla el borrado, la fila sigue visible', (tester) async {
    final cursos = CursoRepoMemoria([
      cursoPrueba(id: 'fallido', nombre: 'Sin borrar'),
    ])..fallaAlEliminar = true;

    await tester.pumpWidget(
      MaterialApp(
        home: CourseListScreen(
          repositorio: cursos,
          tareasRepositorio: TareaRepoMemoria(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.drag(
      find.byKey(const ValueKey('fallido')),
      const Offset(-600, 0),
    );
    await tester.pumpAndSettle();
    expect(find.text('Sin borrar'), findsOneWidget);
    expect(cursos.cursos, hasLength(1));
  });
}
