import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/demo_data.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/task.dart';
import 'package:pdm2026e_equipo_05_unitasks/screens/task_form_screen.dart';

/// Pantalla anfitriona: abre el formulario y muestra la tarea devuelta por
/// Navigator.pop, para verificar los datos que llegan al guardar.
class _Anfitrion extends StatefulWidget {
  const _Anfitrion();

  @override
  State<_Anfitrion> createState() => _AnfitrionState();
}

class _AnfitrionState extends State<_Anfitrion> {
  Task? _guardada;

  @override
  Widget build(BuildContext context) {
    final tarea = _guardada;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              onPressed: () async {
                final resultado = await Navigator.of(context).push<Task>(
                  MaterialPageRoute(builder: (_) => const TaskFormScreen()),
                );
                if (resultado != null) setState(() => _guardada = resultado);
              },
              child: const Text('abrir'),
            ),
            if (tarea != null)
              Text(
                'guardada: ${tarea.titulo} · ${tarea.tipo} · '
                '${tarea.prioridad}',
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  testWidgets('guardar sin título muestra el aviso y no cierra el formulario', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: TaskFormScreen()));

    await tester.tap(find.text('Guardar tarea'));
    await tester.pumpAndSettle();

    expect(find.text('Escribe el título de la tarea'), findsOneWidget);
    expect(find.text('Nueva tarea'), findsOneWidget);
  });

  testWidgets('guarda la tarea con los datos elegidos y la devuelve', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: _Anfitrion()));
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Preparar exposición');
    await tester.tap(find.text('Proyecto'));
    await tester.pump();
    await tester.tap(find.text('Alta'));
    await tester.pump();
    await tester.tap(find.text('Guardar tarea'));
    await tester.pumpAndSettle();

    expect(
      find.text('guardada: Preparar exposición · Proyecto · Alta'),
      findsOneWidget,
    );
  });

  testWidgets('en modo edición prellena el título y guarda los cambios', (
    tester,
  ) async {
    final tarea = Task(titulo: 'Tarea de ejemplo', curso: cursosDemo.first);
    await tester.pumpWidget(MaterialApp(home: TaskFormScreen(tarea: tarea)));

    expect(find.text('Editar tarea'), findsOneWidget);
    expect(find.text('Tarea de ejemplo'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Tarea editada');
    await tester.tap(find.text('Guardar cambios'));
    await tester.pumpAndSettle();

    expect(find.text('Editar tarea'), findsNothing);
  });
}
