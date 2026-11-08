import 'dart:async';

import 'package:pdm2026e_equipo_05_unitasks/auth/servicio_autenticacion.dart';
import 'package:pdm2026e_equipo_05_unitasks/auth/usuario_app.dart';

/// Sesión falsa en memoria para las pruebas de la pantalla de login y del
/// gate, sin Firebase.
class FakeAutenticacion implements ServicioAutenticacion {
  FakeAutenticacion({UsuarioApp? usuario}) : _actual = usuario;

  final StreamController<UsuarioApp?> _cambios =
      StreamController<UsuarioApp?>.broadcast();
  UsuarioApp? _actual;

  /// Si no es `null`, el siguiente intento de login/registro falla con esto.
  ErrorAutenticacion? error;

  int intentosInicio = 0;
  int intentosRegistro = 0;
  int cierres = 0;

  @override
  Stream<UsuarioApp?> get cambiosDeSesion async* {
    yield _actual;
    yield* _cambios.stream;
  }

  @override
  UsuarioApp? get usuarioActual => _actual;

  @override
  Future<void> iniciarSesion(String correo, String contrasena) async {
    intentosInicio++;
    if (error != null) throw error!;
    _empezar(correo);
  }

  @override
  Future<void> registrar(String correo, String contrasena) async {
    intentosRegistro++;
    if (error != null) throw error!;
    _empezar(correo);
  }

  @override
  Future<void> cerrarSesion() async {
    cierres++;
    _actual = null;
    _cambios.add(null);
  }

  void _empezar(String correo) {
    _actual = UsuarioApp(uid: 'uid-1', correo: correo.trim());
    _cambios.add(_actual);
  }

  Future<void> cerrar() => _cambios.close();
}
