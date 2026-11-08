import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'anuncios_base.dart';

/// IDs de prueba de Google. No generan ingresos ni necesitan cuenta de AdMob.
/// Para producción se reemplazan por los del bloque de anuncios real.
const _intersticialAndroid = 'ca-app-pub-3940256099942544/1033173712';
const _intersticialIos = 'ca-app-pub-3940256099942544/4411468910';

/// Implementación real para Android/iOS.
///
/// En escritorio y pruebas no se llama a `preparar()`, así que nunca toca los
/// canales nativos del SDK.
AnunciosBase crearAnuncios() => _AnunciosMovil();

class _AnunciosMovil implements AnunciosBase {
  InterstitialAd? _intersticial;
  bool _iniciado = false;
  bool _cargando = false;
  DateTime? _ultimoMostrado;

  /// Como máximo un intersticial cada 90 segundos, para no interrumpir de más.
  static const _intervalo = Duration(seconds: 90);

  @override
  bool get disponible =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  void preparar() {
    if (!disponible || _iniciado) return;
    _iniciado = true;
    MobileAds.instance.initialize().then((_) => _cargar()).catchError((_) {});
  }

  Future<void> _cargar() async {
    if (!disponible || _cargando || _intersticial != null) return;
    _cargando = true;
    final id = defaultTargetPlatform == TargetPlatform.iOS
        ? _intersticialIos
        : _intersticialAndroid;
    try {
      await InterstitialAd.load(
        adUnitId: id,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (anuncio) {
            _intersticial = anuncio;
            _cargando = false;
          },
          onAdFailedToLoad: (_) {
            _cargando = false;
          },
        ),
      );
    } catch (_) {
      _cargando = false;
    }
  }

  @override
  Future<bool> mostrarIntersticial() async {
    if (!disponible || !_iniciado) return false;

    final ultimo = _ultimoMostrado;
    if (ultimo != null && DateTime.now().difference(ultimo) < _intervalo) {
      return false;
    }

    final anuncio = _intersticial;
    if (anuncio == null) {
      _cargar();
      return false;
    }

    _intersticial = null;
    anuncio.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _ultimoMostrado = DateTime.now();
        _cargar();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _ultimoMostrado = DateTime.now();
        _cargar();
      },
    );
    try {
      await anuncio.show();
      return true;
    } catch (_) {
      anuncio.dispose();
      _cargar();
      return false;
    }
  }
}
