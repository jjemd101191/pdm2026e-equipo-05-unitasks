import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_equipo_05_unitasks/widgets/confirmacion_estado.dart';

void main() {
  Future<void> abrirDialogo(
    WidgetTester tester,
    ValueNotifier<bool?> resultado, {
    required bool completada,
    int subtareas = 0,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                resultado.value = await confirmarCambioEstado(
                  context,
                  completada: completada,
                  tituloTarea: 'Entrega final',
                  subtareas: subtareas,
                );
              },
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
  }

  testWidgets('completar sin subtareas explica qué pasará', (tester) async {
    final resultado = ValueNotifier<bool?>(null);

    await abrirDialogo(tester, resultado, completada: false);

    expect(find.text('¿Completar tarea?'), findsOneWidget);
    expect(find.text('«Entrega final»'), findsOneWidget);
    expect(find.text('Dejará de aparecer en tus pendientes.'), findsOneWidget);

    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();
    expect(resultado.value, isTrue);
  });

  testWidgets('completar avisa cuántas subtareas se marcarán', (tester) async {
    final resultado = ValueNotifier<bool?>(null);

    await abrirDialogo(tester, resultado, completada: false, subtareas: 2);

    expect(
      find.text(
        'Dejará de aparecer en tus pendientes y sus 2 subtareas se marcarán '
        'como completadas.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(resultado.value, isFalse);
  });

  testWidgets('reabrir avisa que las subtareas siguen marcadas', (
    tester,
  ) async {
    final resultado = ValueNotifier<bool?>(null);

    await abrirDialogo(tester, resultado, completada: true, subtareas: 2);

    expect(find.text('¿Reabrir tarea?'), findsOneWidget);
    expect(
      find.text(
        'Volverá a estar en progreso. Sus 2 subtareas seguirán marcadas como '
        'completadas.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();
    expect(resultado.value, isTrue);
  });

  testWidgets('cerrar el diálogo sin elegir equivale a cancelar', (
    tester,
  ) async {
    final resultado = ValueNotifier<bool?>(null);

    await abrirDialogo(tester, resultado, completada: true);

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(resultado.value, isFalse);
  });
}
