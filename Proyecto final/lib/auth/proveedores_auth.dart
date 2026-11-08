import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'servicio_autenticacion.dart';
import 'usuario_app.dart';

/// `main` la sobrescribe con la implementación de Firebase; en pruebas se
/// reemplaza por un servicio en memoria.
final autenticacionProvider = Provider<ServicioAutenticacion>(
  (ref) => throw UnimplementedError(
    'autenticacionProvider debe sobrescribirse (ver main.dart)',
  ),
);

/// La sesión actual. `null` significa «hay que mostrar el login».
final usuarioProvider = StreamProvider<UsuarioApp?>(
  (ref) => ref.watch(autenticacionProvider).cambiosDeSesion,
);

/// uid de la cuenta activa. Vale `''` cuando no hay sesión o en pruebas.
/// El gate lo sobrescribe con el uid real dentro de su propio `ProviderScope`.
final usuarioIdProvider = Provider<String>((ref) => '');
