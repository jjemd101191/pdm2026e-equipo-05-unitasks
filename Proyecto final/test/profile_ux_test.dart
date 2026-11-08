import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/course.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/task.dart';
import 'package:pdm2026e_equipo_05_unitasks/screens/profile_screen.dart';
import 'support/fakes.dart';

class CursosPendientes extends CursoRepoMemoria {
  final respuesta = Completer<List<Course>>();
  @override
  Stream<List<Course>> watchCursos() => Stream.fromFuture(respuesta.future);
}

Future<void> abrir(
  WidgetTester tester,
  CursoRepoMemoria cursos,
  TareaRepoMemoria tareas,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: ProfileScreen(
        repositorio: tareas,
        cursosRepositorio: cursos,
        ajustes: AjustesRepoMemoria(),
      ),
    ),
  );
}

void main() {
  testWidgets('perfil neutro, conteos reales y sin identidad ficticia', (
    tester,
  ) async {
    await abrir(
      tester,
      CursoRepoMemoria([cursoPrueba()]),
      TareaRepoMemoria([
        tareaPrueba(),
        tareaPrueba(id: 'fin', estado: EstadoTarea.completada),
      ]),
    );
    await tester.pumpAndSettle();
    expect(find.text('Perfil local'), findsOneWidget);
    expect(find.text('Diego Morales'), findsNothing);
    expect(find.text('DM'), findsNothing);
    expect(find.text('1'), findsNWidgets(3));
    expect(find.text('Reintentar'), findsNothing);
  });
  testWidgets('perfil muestra carga y luego vacío con orientación', (
    tester,
  ) async {
    final cursos = CursosPendientes();
    await abrir(tester, cursos, TareaRepoMemoria());
    await tester.pump();
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    cursos.respuesta.complete([]);
    await tester.pumpAndSettle();
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(
      find.textContaining('Aún no tienes cursos ni tareas'),
      findsOneWidget,
    );
    expect(find.text('0'), findsNWidgets(3));
  });
  for (final fallaCurso in [true, false]) {
    testWidgets(
      'error de ${fallaCurso ? 'cursos' : 'tareas'} permite recuperar resumen',
      (tester) async {
        final cursos = CursoRepoMemoria([cursoPrueba()])
          ..fallaAlCargar = fallaCurso;
        final tareas = TareaRepoMemoria([tareaPrueba()])
          ..fallaAlCargar = !fallaCurso;
        await abrir(tester, cursos, tareas);
        await tester.pumpAndSettle();
        expect(find.text('Reintentar'), findsOneWidget);
        expect(find.text('0'), findsNothing);
        expect(
          find.textContaining('No pudimos cargar tu resumen'),
          findsOneWidget,
        );
        cursos.fallaAlCargar = false;
        tareas.fallaAlCargar = false;
        await tester.tap(find.text('Reintentar'));
        await tester.pumpAndSettle();
        expect(find.text('Reintentar'), findsNothing);
        expect(find.text('1'), findsNWidgets(2));
      },
    );
  }
  testWidgets('fallo repetido sigue ofreciendo reintentar', (tester) async {
    await abrir(
      tester,
      CursoRepoMemoria()..fallaAlCargar = true,
      TareaRepoMemoria(),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.text('Reintentar'), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });
  testWidgets('salir durante la carga no modifica estado desmontado', (
    tester,
  ) async {
    final cursos = CursosPendientes();
    await abrir(tester, cursos, TareaRepoMemoria());
    await tester.pump();
    await tester.pumpWidget(const SizedBox());
    cursos.respuesta.complete([]);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
