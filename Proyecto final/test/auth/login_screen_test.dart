import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_equipo_05_unitasks/auth/proveedores_auth.dart';
import 'package:pdm2026e_equipo_05_unitasks/auth/servicio_autenticacion.dart';
import 'package:pdm2026e_equipo_05_unitasks/screens/login_screen.dart';

import '../support/fake_autenticacion.dart';

void main() {
  Widget montar(FakeAutenticacion auth) => ProviderScope(
    overrides: [autenticacionProvider.overrideWithValue(auth)],
    child: const MaterialApp(home: LoginScreen()),
  );

  Future<void> escribirCredenciales(
    WidgetTester tester, {
    String correo = 'ana@ejemplo.com',
    String contrasena = 'secreto1',
  }) async {
    await tester.enterText(find.byType(TextFormField).at(0), correo);
    await tester.enterText(find.byType(TextFormField).at(1), contrasena);
  }

  testWidgets('valida el correo y la contraseña antes de llamar a Firebase', (
    tester,
  ) async {
    final auth = FakeAutenticacion();
    addTearDown(auth.cerrar);
    await tester.pumpWidget(montar(auth));

    await escribirCredenciales(tester, correo: 'sin-arroba', contrasena: '123');
    await tester.tap(find.widgetWithText(FilledButton, 'Iniciar sesión'));
    await tester.pump();

    expect(find.text('Escribe un correo válido.'), findsOneWidget);
    expect(find.text('Usa al menos 6 caracteres.'), findsOneWidget);
    expect(auth.intentosInicio, 0);
  });

  testWidgets('credenciales incorrectas muestran un mensaje genérico', (
    tester,
  ) async {
    final auth = FakeAutenticacion()
      ..error = const ErrorAutenticacion(CodigoErrorAuth.credencialesInvalidas);
    addTearDown(auth.cerrar);
    await tester.pumpWidget(montar(auth));

    await escribirCredenciales(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Iniciar sesión'));
    await tester.pumpAndSettle();

    expect(find.text('Correo o contraseña incorrectos.'), findsOneWidget);
    expect(auth.intentosInicio, 1);
  });

  testWidgets(
    'el registro llama a registrar y muestra el error de correo en uso',
    (tester) async {
      final auth = FakeAutenticacion()
        ..error = const ErrorAutenticacion(CodigoErrorAuth.correoEnUso);
      addTearDown(auth.cerrar);
      await tester.pumpWidget(montar(auth));

      await tester.tap(find.text('¿No tienes cuenta? Regístrate'));
      await tester.pump();
      await escribirCredenciales(tester);
      await tester.tap(find.widgetWithText(FilledButton, 'Crear cuenta'));
      await tester.pumpAndSettle();

      expect(auth.intentosRegistro, 1);
      expect(
        find.text('Ya existe una cuenta con ese correo. Inicia sesión.'),
        findsOneWidget,
      );
    },
  );

  testWidgets('un alta correcta inicia sesión sin navegar a mano', (
    tester,
  ) async {
    final auth = FakeAutenticacion();
    addTearDown(auth.cerrar);
    await tester.pumpWidget(montar(auth));

    await escribirCredenciales(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Iniciar sesión'));
    await tester.pumpAndSettle();

    expect(auth.intentosInicio, 1);
    expect(auth.usuarioActual?.correo, 'ana@ejemplo.com');
  });
}
