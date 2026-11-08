/// Contrato mínimo de anuncios para que la app compile en web y escritorio.
abstract class AnunciosBase {
  /// `true` solo en Android/iOS cuando el SDK está listo para usarse.
  bool get disponible;

  /// Inicia el SDK y precarga un intersticial. No bloquea el arranque.
  void preparar();

  /// Muestra un intersticial si hay uno cargado. Devuelve `true` si se mostró.
  Future<bool> mostrarIntersticial();
}
