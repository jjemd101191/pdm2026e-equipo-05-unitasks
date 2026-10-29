/// Movimiento de dinero asociado a una categoría.
///
/// En este laboratorio los movimientos solo se leen: existen para demostrar
/// que una categoría en uso no se puede borrar y que la migración conserva
/// los datos relacionados.
class Movimiento {
  const Movimiento({
    required this.id,
    required this.categoriaId,
    required this.descripcion,
    required this.monto,
    required this.fecha,
  });

  final String id;
  final String categoriaId;
  final String descripcion;
  final double monto;
  final DateTime fecha;

  bool get esGasto => monto < 0;
}
