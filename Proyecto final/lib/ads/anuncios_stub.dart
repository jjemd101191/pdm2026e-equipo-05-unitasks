import 'anuncios_base.dart';

/// Implementación para web y plataformas sin AdMob: no hace nada.
AnunciosBase crearAnuncios() => const _AnunciosNulo();

class _AnunciosNulo implements AnunciosBase {
  const _AnunciosNulo();

  @override
  bool get disponible => false;

  @override
  void preparar() {}

  @override
  Future<bool> mostrarIntersticial() async => false;
}
