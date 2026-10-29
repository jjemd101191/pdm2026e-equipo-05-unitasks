import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_equipo_05_unitasks/main.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/task.dart';

import 'support/fakes.dart';

void main() {
  testWidgets(
    'crear, completar, editar y eliminar una tarea persiste el flujo',
    (tester) async {
      final curso = cursoPrueba(nombre: 'Dispositivos Móviles');
      final cursos = CursoRepoMemoria([curso]);
      final tareas = TareaRepoMemoria();

      await tester.pumpWidget(
        TaskUApp(courseRepository: cursos, taskRepository: tareas),
      );
      await tester.pumpAndSettle();

      // Crear.
      await tester.tap(find.byTooltip('Nueva tarea'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextField).first,
        'Preparar exposición',
      );
      await tester.tap(find.text('Guardar tarea'));
      await tester.pumpAndSettle();

      expect(find.text('Preparar exposición'), findsOneWidget);
      expect(find.textContaining('1 tarea pendiente'), findsOneWidget);
      expect(tareas.tareas, hasLength(1));

      // Abrir detalle y completar.
      await tester.tap(find.text('Preparar exposición'));
      await tester.pumpAndSettle();
      expect(find.text('Detalle de tarea'), findsOneWidget);

      await tester.tap(find.text('Marcar como completada'));
      await tester.pumpAndSettle();
      expect(tareas.tareas.single.completada, isTrue);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // En «Pendientes» ya no aparece.
      expect(find.text('Preparar exposición'), findsNothing);

      // En «Completadas» sí, y se puede editar.
      await tester.tap(find.text('Completadas'));
      await tester.pumpAndSettle();
      expect(find.text('Preparar exposición'), findsOneWidget);

      await tester.tap(find.text('Preparar exposición'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Editar tarea'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextField).first,
        'Exposición editada',
      );
      await tester.tap(find.text('Guardar cambios'));
      await tester.pumpAndSettle();

      expect(find.text('Exposición editada'), findsOneWidget);
      expect(tareas.tareas.single.titulo, 'Exposición editada');

      // Eliminar desde el detalle.
      await tester.tap(find.text('Eliminar tarea'));
      await tester.pumpAndSettle();
      expect(find.text('¿Eliminar tarea?'), findsOneWidget);
      await tester.tap(find.widgetWithText(TextButton, 'Eliminar'));
      await tester.pumpAndSettle();

      expect(tareas.tareas, isEmpty);
      expect(find.text('Exposición editada'), findsNothing);
      expect(find.text('Todavía no has completado tareas.'), findsOneWidget);
    },
  );

  testWidgets('muestra el recordatorio vencido dentro de la app', (
    tester,
  ) async {
    final curso = cursoPrueba();
    final tarea = tareaPrueba(
      titulo: 'Entrega con aviso',
      curso: curso,
      fechaEntrega: DateTime.now().add(const Duration(minutes: 30)),
      recordatorio: RecordatorioOpcion.unaHora,
    );

    await tester.pumpWidget(
      TaskUApp(
        courseRepository: CursoRepoMemoria([curso]),
        taskRepository: TareaRepoMemoria([tarea]),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Recordatorios'), findsOneWidget);
    expect(find.text('Entrega con aviso'), findsWidgets);
    expect(find.textContaining('Avisos dentro de la app'), findsOneWidget);
  });

  testWidgets('sin cursos, crear tarea explica qué hacer primero', (
    tester,
  ) async {
    await tester.pumpWidget(
      TaskUApp(
        courseRepository: CursoRepoMemoria(),
        taskRepository: TareaRepoMemoria(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Nueva tarea'));
    await tester.pumpAndSettle();

    expect(find.text('Primero crea un curso'), findsOneWidget);
    expect(find.textContaining('pestaña'), findsWidgets);
  });
}
