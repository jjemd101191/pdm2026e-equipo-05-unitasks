import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/task.dart';
import 'package:pdm2026e_equipo_05_unitasks/screens/task_list_screen.dart';

import 'support/fakes.dart';

void main() {
  Future<void> cargarPantalla(
    WidgetTester tester, {
    List<Task> tareas = const [],
  }) async {
    final cursoA = cursoPrueba(id: 'curso-a', nombre: 'Biología Celular');
    final cursoB = cursoPrueba(id: 'curso-b', nombre: 'Álgebra Lineal');
    await tester.pumpWidget(
      MaterialApp(
        home: TaskListScreen(
          repositorio: TareaRepoMemoria(tareas),
          cursosRepositorio: CursoRepoMemoria([cursoA, cursoB]),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> buscar(WidgetTester tester, String texto) async {
    await tester.enterText(find.byType(TextField), texto);
    await tester.pumpAndSettle();
  }

  testWidgets('busca por título mientras se escribe', (tester) async {
    await cargarPantalla(
      tester,
      tareas: [
        tareaPrueba(titulo: 'Preparar informe final'),
        tareaPrueba(id: 'otra', titulo: 'Resolver ejercicios'),
      ],
    );

    await buscar(tester, 'informe');

    expect(find.text('Preparar informe final'), findsOneWidget);
    expect(find.text('Resolver ejercicios'), findsNothing);
  });

  testWidgets('busca por descripción', (tester) async {
    await cargarPantalla(
      tester,
      tareas: [
        tareaPrueba(
          titulo: 'Entrega semanal',
        ).copyWith(descripcion: 'Adjuntar el diagrama entidad relación'),
        tareaPrueba(id: 'otra', titulo: 'Lectura de capítulo'),
      ],
    );

    await buscar(tester, 'entidad relación');

    expect(find.text('Entrega semanal'), findsOneWidget);
    expect(find.text('Lectura de capítulo'), findsNothing);
  });

  testWidgets('busca por nombre del curso', (tester) async {
    await cargarPantalla(
      tester,
      tareas: [
        tareaPrueba(titulo: 'Repasar tema 1', cursoId: 'curso-a'),
        tareaPrueba(id: 'otra', titulo: 'Resolver guía', cursoId: 'curso-b'),
      ],
    );

    await buscar(tester, 'biología celular');

    expect(find.text('Repasar tema 1'), findsOneWidget);
    expect(find.text('Resolver guía'), findsNothing);
  });

  testWidgets('la búsqueda ignora mayúsculas y minúsculas', (tester) async {
    await cargarPantalla(
      tester,
      tareas: [tareaPrueba(titulo: 'Proyecto de Investigación')],
    );

    await buscar(tester, 'pRoYeCtO DE iNvEsTiGaCiÓn');

    expect(find.text('Proyecto de Investigación'), findsOneWidget);
  });

  testWidgets('muestra el mensaje cuando no hay coincidencias', (tester) async {
    await cargarPantalla(tester, tareas: [tareaPrueba()]);

    await buscar(tester, 'texto inexistente');

    expect(find.text('No hay tareas con ese texto'), findsOneWidget);
  });

  testWidgets('combina la búsqueda con los filtros de estado', (tester) async {
    await cargarPantalla(
      tester,
      tareas: [
        tareaPrueba(titulo: 'Informe pendiente'),
        tareaPrueba(
          id: 'completada',
          titulo: 'Informe completado',
          estado: EstadoTarea.completada,
        ),
      ],
    );

    await buscar(tester, 'informe');
    expect(find.text('Informe pendiente'), findsOneWidget);
    expect(find.text('Informe completado'), findsNothing);

    await tester.tap(find.text('Todas'));
    await tester.pumpAndSettle();
    expect(find.text('Informe pendiente'), findsOneWidget);
    expect(find.text('Informe completado'), findsOneWidget);

    await tester.tap(find.text('Completadas'));
    await tester.pumpAndSettle();
    expect(find.text('Informe pendiente'), findsNothing);
    expect(find.text('Informe completado'), findsOneWidget);
  });
}
