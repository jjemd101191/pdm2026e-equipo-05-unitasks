import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/course.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/task.dart';
import 'package:pdm2026e_equipo_05_unitasks/screens/task_form_screen.dart';

import 'support/fakes.dart';

/// Pantalla anfitriona: abre el formulario y muestra la tarea devuelta por
/// Navigator.pop, para verificar los datos que llegan al guardar.
class _Anfitrion extends StatefulWidget {
  const _Anfitrion({required this.cursos});

  final List<Course> cursos;

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
                  MaterialPageRoute(
                    builder: (_) => TaskFormScreen(cursos: widget.cursos),
                  ),
                );
                if (resultado != null) setState(() => _guardada = resultado);
              },
              child: const Text('abrir'),
            ),
            if (tarea != null)
              Text(
                'guardada: ${tarea.titulo} · ${tarea.tipo.etiqueta} · '
                '${tarea.prioridad.etiqueta}',
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  final cursos = [cursoPrueba(), cursoPrueba(id: 'curso-b', nombre: 'Curso B')];

  testWidgets('guardar sin título muestra el aviso y no cierra el formulario', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: TaskFormScreen(cursos: cursos)));

    await tester.tap(find.text('Guardar tarea'));
    await tester.pumpAndSettle();

    expect(find.text('Escribe el título de la tarea'), findsOneWidget);
    expect(find.text('Nueva tarea'), findsOneWidget);
  });

  testWidgets('guarda la tarea con los datos elegidos y la devuelve', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: _Anfitrion(cursos: cursos)));
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
    final tarea = Task(
      id: 'tarea-edicion',
      titulo: 'Tarea de ejemplo',
      cursoId: cursos.first.id,
      fechaEntrega: DateTime(2026, 11, 20, 18, 30),
      recordatorioMinutos: 60,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: TaskFormScreen(tarea: tarea, cursos: cursos),
      ),
    );

    expect(find.text('Editar tarea'), findsOneWidget);
    expect(find.text('Tarea de ejemplo'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Tarea editada');
    await tester.tap(find.text('Guardar cambios'));
    await tester.pumpAndSettle();

    expect(find.text('Editar tarea'), findsNothing);
  });

  testWidgets('una tarea nueva propone mañana 23:59 y avisa un día antes', (
    tester,
  ) async {
    Task? resultado;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (contexto) => Scaffold(
            body: ElevatedButton(
              onPressed: () async {
                resultado = await Navigator.of(contexto).push<Task>(
                  MaterialPageRoute(
                    builder: (_) => TaskFormScreen(cursos: cursos),
                  ),
                );
              },
              child: const Text('abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Con fecha');
    await tester.tap(find.text('Guardar tarea'));
    await tester.pumpAndSettle();

    final manana = DateTime.now().add(const Duration(days: 1));
    expect(resultado, isNotNull);
    expect(
      resultado!.fechaEntrega,
      DateTime(manana.year, manana.month, manana.day, 23, 59),
    );
    expect(resultado!.recordatorioMinutos, 24 * 60);
    expect(resultado!.cursoId, cursos.first.id);
  });
}
