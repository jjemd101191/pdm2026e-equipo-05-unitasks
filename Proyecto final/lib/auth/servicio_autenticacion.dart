import 'usuario_app.dart';

/// Qué salió mal al iniciar sesión o registrarse.
enum CodigoErrorAuth {
  correoInvalido,
  credencialesInvalidas,
  correoEnUso,
  contrasenaDebil,
  demasiadosIntentos,
  sinConexion,
  desconocido,
}

/// Error de autenticación ya traducido para mostrar en la pantalla.
class ErrorAutenticacion implements Exception {
  const ErrorAutenticacion(this.codigo);

  final CodigoErrorAuth codigo;

  String get mensaje => switch (codigo) {
    CodigoErrorAuth.correoInvalido => 'Escribe un correo válido.',
    // Genérico a propósito: no revela si el correo existe.
    CodigoErrorAuth.credencialesInvalidas => 'Correo o contraseña incorrectos.',
    CodigoErrorAuth.correoEnUso =>
      'Ya existe una cuenta con ese correo. Inicia sesión.',
    CodigoErrorAuth.contrasenaDebil =>
      'La contraseña es muy débil: usa al menos 6 caracteres.',
    CodigoErrorAuth.demasiadosIntentos =>
      'Demasiados intentos. Espera un momento y vuelve a probar.',
    CodigoErrorAuth.sinConexion =>
      'Sin conexión. Revisa tu red e inténtalo de nuevo.',
    CodigoErrorAuth.desconocido => 'No se pudo completar la operación.',
  };

  @override
  String toString() => mensaje;
}

/// Autenticación de la app. Es una interfaz para poder probar la UI y el
/// arranque sin Firebase.
abstract class ServicioAutenticacion {
  /// Emite la cuenta actual y `null` al cerrar sesión.
  Stream<UsuarioApp?> get cambiosDeSesion;

  UsuarioApp? get usuarioActual;

  Future<void> iniciarSesion(String correo, String contrasena);

  Future<void> registrar(String correo, String contrasena);

  Future<void> cerrarSesion();
}
