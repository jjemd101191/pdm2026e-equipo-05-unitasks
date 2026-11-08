import 'package:firebase_auth/firebase_auth.dart';

import 'servicio_autenticacion.dart';
import 'usuario_app.dart';

/// [ServicioAutenticacion] sobre Firebase Auth (correo y contraseña).
class ServicioAutenticacionFirebase implements ServicioAutenticacion {
  ServicioAutenticacionFirebase({FirebaseAuth? auth})
    : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  @override
  Stream<UsuarioApp?> get cambiosDeSesion => _auth.authStateChanges().map(
    (usuario) => usuario == null
        ? null
        : UsuarioApp(uid: usuario.uid, correo: usuario.email ?? ''),
  );

  @override
  UsuarioApp? get usuarioActual {
    final usuario = _auth.currentUser;
    if (usuario == null) return null;
    return UsuarioApp(uid: usuario.uid, correo: usuario.email ?? '');
  }

  @override
  Future<void> iniciarSesion(String correo, String contrasena) => _ejecutar(
    () => _auth.signInWithEmailAndPassword(
      email: correo.trim(),
      password: contrasena,
    ),
  );

  @override
  Future<void> registrar(String correo, String contrasena) => _ejecutar(
    () => _auth.createUserWithEmailAndPassword(
      email: correo.trim(),
      password: contrasena,
    ),
  );

  @override
  Future<void> cerrarSesion() => _auth.signOut();

  Future<void> _ejecutar(Future<UserCredential> Function() accion) async {
    try {
      await accion();
    } on FirebaseAuthException catch (error) {
      throw ErrorAutenticacion(_codigo(error.code));
    }
  }

  CodigoErrorAuth _codigo(String codigo) => switch (codigo) {
    'invalid-email' => CodigoErrorAuth.correoInvalido,
    'user-not-found' ||
    'wrong-password' ||
    'invalid-credential' ||
    'invalid-login-credentials' => CodigoErrorAuth.credencialesInvalidas,
    'email-already-in-use' => CodigoErrorAuth.correoEnUso,
    'weak-password' => CodigoErrorAuth.contrasenaDebil,
    'too-many-requests' => CodigoErrorAuth.demasiadosIntentos,
    'network-request-failed' => CodigoErrorAuth.sinConexion,
    _ => CodigoErrorAuth.desconocido,
  };
}
