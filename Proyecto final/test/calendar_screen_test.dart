import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_equipo_05_unitasks/screens/calendar_screen.dart';
import 'package:pdm2026e_equipo_05_unitasks/utils/fechas.dart';

import 'support/fakes.dart';

Widget _pantalla({
  required TareaRepoMemoria tareas,
  required CursoRepoMemoria cursos,
}) => MaterialApp(
  home: CalendarScreen(
    repositorio: tareas,
    cursosRepositorio: cursos,
    ajustes: AjustesRepoMemoria(),
  ),
);

/// La agenda queda debajo del calendario; una vista alta evita que el
/// `ListView` no construya las filas que se van a comprobar.
void _vistaAlta(WidgetTester tester) {
  tester.view.physicalSize = const Size(900, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('muestra el mes y la entrega del día seleccionado', (
    tester,
  ) async {
    _vistaAlta(tester);
    final hoy = soloDia(DateTime.now());
    final curso = cursoPrueba(nombre: 'Dispositivos Móviles');
    final tareas = TareaRepoMemoria([
      tareaPrueba(
        titulo: 'Entrega de hoy',
        cursoId: curso.id,
        fechaEntrega: DateTime(hoy.year, hoy.month, hoy.day, 18),
      ),
    ]);
    final cursos = CursoRepoMemoria([curso]);

    await tester.pumpWidget(_pantalla(tareas: tareas, cursos: cursos));
    await tester.pumpAndSettle();

    expect(find.text('Calendario'), findsOneWidget);
    expect(find.text(formatearMes(hoy)), findsOneWidget);
    expect(find.text('Entrega de hoy'), findsOneWidget);
    expect(find.textContaining('Dispositivos Móviles'), findsOneWidget);
    expect(find.text('Sin entregas para este día.'), findsNothing);
  });

  testWidgets('muestra el estado vacío cuando no hay entregas', (tester) async {
    _vistaAlta(tester);
    await tester.pumpWidget(
      _pantalla(tareas: TareaRepoMemoria(), cursos: CursoRepoMemoria()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Todavía no hay entregas con fecha.'), findsOneWidget);
  });

  testWidgets('navega al mes anterior y regresa al actual', (tester) async {
    _vistaAlta(tester);
    final hoy = soloDia(DateTime.now());

    await tester.pumpWidget(
      _pantalla(tareas: TareaRepoMemoria(), cursos: CursoRepoMemoria()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Mes anterior'));
    await tester.pumpAndSettle();
    expect(
      find.text(formatearMes(DateTime(hoy.year, hoy.month - 1))),
      findsOneWidget,
    );

    await tester.tap(find.byTooltip('Mes siguiente'));
    await tester.pumpAndSettle();
    expect(find.text(formatearMes(hoy)), findsOneWidget);
  });

  testWidgets('muestra error y permite reintentar la carga', (tester) async {
    _vistaAlta(tester);
    final curso = cursoPrueba(nombre: 'Redes');
    final tareas = TareaRepoMemoria()..fallaAlCargar = true;
    final cursos = CursoRepoMemoria([curso]);

    await tester.pumpWidget(_pantalla(tareas: tareas, cursos: cursos));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('No pudimos cargar el calendario.'),
      findsOneWidget,
    );
    expect(find.text('Reintentar'), findsOneWidget);

    tareas.fallaAlCargar = false;
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();

    expect(find.text(formatearMes(soloDia(DateTime.now()))), findsOneWidget);
    expect(find.text('Todavía no hay entregas con fecha.'), findsOneWidget);
  });
}
