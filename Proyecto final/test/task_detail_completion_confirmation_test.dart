import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/task.dart';
import 'package:pdm2026e_equipo_05_unitasks/screens/task_detail_screen.dart';

import 'support/fakes.dart';

void main() {
  Future<TareaRepoMemoria> cargarDetalle(
    WidgetTester tester,
    Task tarea,
  ) async {
    final curso = cursoPrueba();
    final tareas = TareaRepoMemoria([tarea]);
    await tester.pumpWidget(
      MaterialApp(
        home: TaskDetailScreen(
          tarea: tarea,
          repositorio: tareas,
          cursos: [curso],
        ),
      ),
    );
    await tester.pumpAndSettle();
    return tareas;
  }

  testWidgets('cancelar completar deja tarea y subtareas sin cambios', (
    tester,
  ) async {
    final tarea = tareaPrueba(
      subtareas: const [Subtask(id: 'sub-1', titulo: 'Primera parte')],
    );
    final tareas = await cargarDetalle(tester, tarea);

    await tester.tap(find.text('Marcar como completada'));
    await tester.pumpAndSettle();

    expect(
      find.text('¿Estás seguro de que deseas completar esta tarea?'),
      findsOneWidget,
    );
    expect(find.text('Cancelar'), findsOneWidget);
    expect(find.text('Confirmar'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(tareas.tareas.single.completada, isFalse);
    expect(tareas.tareas.single.subtareas.single.hecha, isFalse);
  });

  testWidgets('confirmar completar conserva la regla de las subtareas', (
    tester,
  ) async {
    final tarea = tareaPrueba(
      subtareas: const [Subtask(id: 'sub-1', titulo: 'Primera parte')],
    );
    final tareas = await cargarDetalle(tester, tarea);

    await tester.tap(find.text('Marcar como completada'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();

    expect(tareas.tareas.single.completada, isTrue);
    expect(tareas.tareas.single.subtareas.single.hecha, isTrue);
  });

  testWidgets('cancelar reabrir conserva el estado completado', (tester) async {
    final tarea = tareaPrueba(
      estado: EstadoTarea.completada,
      subtareas: const [
        Subtask(id: 'sub-1', titulo: 'Primera parte', hecha: true),
      ],
    );
    final tareas = await cargarDetalle(tester, tarea);

    await tester.tap(find.text('Reabrir tarea'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        '¿Estás seguro de que deseas volver a marcarla como pendiente?',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(tareas.tareas.single.completada, isTrue);
    expect(tareas.tareas.single.subtareas.single.hecha, isTrue);
  });

  testWidgets('confirmar reabrir cambia estado sin alterar subtareas', (
    tester,
  ) async {
    final tarea = tareaPrueba(
      estado: EstadoTarea.completada,
      subtareas: const [
        Subtask(id: 'sub-1', titulo: 'Primera parte', hecha: true),
      ],
    );
    final tareas = await cargarDetalle(tester, tarea);

    await tester.tap(find.text('Reabrir tarea'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();

    expect(tareas.tareas.single.estado, EstadoTarea.enProgreso);
    expect(tareas.tareas.single.completada, isFalse);
    expect(tareas.tareas.single.subtareas.single.hecha, isTrue);
  });
}
