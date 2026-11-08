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
///
/// Se deriva de [usuarioProvider] en el mismo scope en lugar de usar un
/// `ProviderScope` anidado: en Riverpod 3 los overrides de un scope no llegan
/// a un scope hijo que declara los suyos, y eso dejaba la base fuera de
/// alcance justo al iniciar sesión.
final usuarioIdProvider = Provider<String>(
  (ref) => ref.watch(usuarioProvider).value?.uid ?? '',
);
