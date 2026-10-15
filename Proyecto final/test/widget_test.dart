import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/course_repository.dart';
import 'package:pdm2026e_equipo_05_unitasks/data/demo_data.dart';
import 'package:pdm2026e_equipo_05_unitasks/main.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/course.dart';
import 'package:pdm2026e_equipo_05_unitasks/screens/course_list_screen.dart';

class _RepositorioFallido implements CourseRepository {
  @override
  Future<List<Course>> obtenerCursos() async {
    throw Exception('sin conexion');
  }
}

class _RepositorioIntermitente implements CourseRepository {
  int _llamadas = 0;

  @override
  Future<List<Course>> obtenerCursos() async {
    _llamadas++;
    if (_llamadas == 1) throw Exception('sin conexion');
    return cursosDemo;
  }
}

void main() {
  testWidgets('TaskU abre en la pestaña de cursos con los datos de demo', (
    tester,
  ) async {
    await tester.pumpWidget(const TaskUApp());
    await tester.pumpAndSettle();
    expect(find.text('Mis cursos'), findsOneWidget);
    expect(find.text('Dispositivos Móviles'), findsWidgets);
    expect(find.text('4 pendientes'), findsOneWidget);
  });

  testWidgets('muestra el error y el botón Reintentar si falla la carga', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: CourseListScreen(repositorio: _RepositorioFallido())),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('No pudimos cargar'), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);
  });

  testWidgets('Reintentar vuelve a cargar y muestra los datos', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CourseListScreen(repositorio: _RepositorioIntermitente()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.text('Reintentar'), findsNothing);
    expect(find.text('Dispositivos Móviles'), findsWidgets);
  });
}
