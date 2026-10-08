import 'package:flutter_test/flutter_test.dart';

import 'package:pdm2026e_equipo_05_unitasks/main.dart';

void main() {
  testWidgets('TaskU abre en la pestaña de cursos con los datos de demo', (
    tester,
  ) async {
    await tester.pumpWidget(const TaskUApp());
    expect(find.text('Mis cursos'), findsOneWidget);
    expect(find.text('Dispositivos Móviles'), findsWidgets);
    expect(find.text('4 pendientes'), findsOneWidget);
  });
}
