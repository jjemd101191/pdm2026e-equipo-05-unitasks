import '../models/categoria.dart';
import '../models/movimiento.dart';

/// Convierte los modelos a mapas JSON y de vuelta.
///
/// El JSON se guarda como texto en Hive para que el esquema sea legible. Las
/// fechas van en ISO 8601 y los enums por su nombre.
Map<String, dynamic> categoriaAJson(Categoria categoria) => {
  'id': categoria.id,
  'nombre': categoria.nombre,
  'tipo': categoria.tipo.name,
  'archivado': categoria.archivado,
};

Categoria categoriaDesdeJson(Map<String, dynamic> json) => Categoria(
  id: json['id'] as String,
  nombre: json['nombre'] as String? ?? 'Categoría sin nombre',
  tipo: TipoCategoria.desdeNombre(json['tipo'] as String?),
  // Tolerante a propósito: un registro de la versión 1 no trae el campo.
  archivado: json['archivado'] as bool? ?? false,
);

Map<String, dynamic> movimientoAJson(Movimiento movimiento) => {
  'id': movimiento.id,
  'categoriaId': movimiento.categoriaId,
  'descripcion': movimiento.descripcion,
  'monto': movimiento.monto,
  'fecha': movimiento.fecha.toIso8601String(),
};

Movimiento movimientoDesdeJson(Map<String, dynamic> json) => Movimiento(
  id: json['id'] as String,
  categoriaId: json['categoriaId'] as String? ?? '',
  descripcion: json['descripcion'] as String? ?? '',
  monto: (json['monto'] as num?)?.toDouble() ?? 0,
  fecha: DateTime.tryParse(json['fecha'] as String? ?? '') ?? DateTime.now(),
);
