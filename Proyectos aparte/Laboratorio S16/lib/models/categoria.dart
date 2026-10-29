/// Tipo de categoría: separa lo que sale de lo que entra.
enum TipoCategoria {
  gasto,
  ingreso;

  /// Reconstruye el tipo desde el JSON guardado; si el valor no existe se
  /// asume gasto para no perder el registro.
  static TipoCategoria desdeNombre(String? nombre) {
    for (final tipo in values) {
      if (tipo.name == nombre) return tipo;
    }
    return TipoCategoria.gasto;
  }

  String get etiqueta => this == TipoCategoria.gasto ? 'Gasto' : 'Ingreso';
}

/// Categoría de movimientos (por ejemplo «Súper y comida»).
///
/// El número de movimientos no se guarda en la categoría: se cuenta desde la
/// caja de movimientos para que nunca quede desincronizado.
class Categoria {
  const Categoria({
    required this.id,
    required this.nombre,
    required this.tipo,
    this.archivado = false,
  });

  final String id;
  final String nombre;
  final TipoCategoria tipo;

  /// `true` cuando la categoría se archivó para dejar de verla en la lista.
  ///
  /// Es la salida cuando la categoría tiene movimientos y no se puede borrar:
  /// el histórico se conserva y la lista principal queda limpia.
  final bool archivado;

  Categoria copyWith({String? nombre, TipoCategoria? tipo, bool? archivado}) {
    return Categoria(
      id: id,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      archivado: archivado ?? this.archivado,
    );
  }

  @override
  bool operator ==(Object other) => other is Categoria && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
