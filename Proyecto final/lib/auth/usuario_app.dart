import 'package:flutter/foundation.dart';

/// La cuenta que tiene la sesión abierta.
@immutable
class UsuarioApp {
  const UsuarioApp({required this.uid, required this.correo});

  final String uid;
  final String correo;

  @override
  bool operator ==(Object other) =>
      other is UsuarioApp && other.uid == uid && other.correo == correo;

  @override
  int get hashCode => Object.hash(uid, correo);
}
