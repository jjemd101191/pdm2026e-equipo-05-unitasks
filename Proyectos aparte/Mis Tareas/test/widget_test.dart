// Prueba de humo de la pantalla existente; no requiere funcionalidades de la Parte B.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Mis Tareas muestra la pantalla y las tareas existentes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Mis Tareas'), findsOneWidget);
    expect(find.text('¡Hola, Demy! 👋'), findsOneWidget);
    expect(find.text('Tienes 3 tareas pendientes'), findsOneWidget);
    expect(find.text('Todas'), findsOneWidget);
    expect(find.text('Próximas tareas'), findsOneWidget);
    expect(find.text('Reporte de lectura'), findsOneWidget);
    expect(find.text('Comunicación Oral'), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Tareas'), findsOneWidget);
    expect(find.text('Calendario'), findsOneWidget);
    expect(find.text('Agregar'), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Comprueba el contenido inferior mediante el desplazamiento real de la lista.
    await tester.scrollUntilVisible(
      find.text('Investigación de campo'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Investigación de campo'), findsOneWidget);
    expect(find.text('Sociología'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
