/// Estado visible de la sincronización con la nube.
enum EstadoSync {
  /// Se está descargando o subiendo algo.
  sincronizando,

  /// Lo local y lo remoto coinciden (hasta donde se sabe).
  alDia,

  /// No se pudo contactar a Firestore; la app sigue funcionando localmente.
  sinConexion,

  /// Firestore respondió con un error (por ejemplo, reglas o permisos).
  error,
}

extension EtiquetaEstadoSync on EstadoSync {
  String get etiqueta => switch (this) {
    EstadoSync.sincronizando => 'Sincronizando…',
    EstadoSync.alDia => 'Al día',
    EstadoSync.sinConexion => 'Sin conexión',
    EstadoSync.error => 'Error al sincronizar',
  };
}
