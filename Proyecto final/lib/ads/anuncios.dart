import 'anuncios_base.dart';
import 'anuncios_stub.dart'
    if (dart.library.io) 'anuncios_movil.dart'
    as plataforma;

/// Punto único de acceso a los anuncios de TaskU.
///
/// En web y escritorio la implementación es nula; en Android/iOS usa AdMob
/// con los IDs de prueba de Google mientras el proyecto es académico.
class Anuncios {
  Anuncios._();

  static final AnunciosBase _implementacion = plataforma.crearAnuncios();

  static bool get disponible => _implementacion.disponible;

  static void preparar() => _implementacion.preparar();

  static Future<bool> mostrarIntersticial() =>
      _implementacion.mostrarIntersticial();
}
