import 'movement.dart';

/// Filtro inmutable del historial. Al cambiar el valor, el provider de la
/// lista vuelve a calcular los movimientos sin ningún botón de recarga.
class MovementFilter {
  const MovementFilter({
    this.category = allCategories,
    this.month = allMonths,
    this.text = '',
  });

  static const String allCategories = 'Todas';
  static const String allMonths = 'Todos';

  final String category;

  /// Clave con formato `AAAA-MM`; [allMonths] desactiva el criterio.
  final String month;
  final String text;

  bool get isActive =>
      category != allCategories || month != allMonths || text.trim().isNotEmpty;

  MovementFilter copyWith({String? category, String? month, String? text}) =>
      MovementFilter(
        category: category ?? this.category,
        month: month ?? this.month,
        text: text ?? this.text,
      );

  bool accepts(Movement movement) {
    final matchesCategory =
        category == allCategories || movement.category == category;
    final matchesMonth = month == allMonths || monthKey(movement.date) == month;
    final query = text.trim().toLowerCase();
    final matchesText =
        query.isEmpty ||
        movement.title.toLowerCase().contains(query) ||
        movement.category.toLowerCase().contains(query);
    return matchesCategory && matchesMonth && matchesText;
  }

  @override
  bool operator ==(Object other) =>
      other is MovementFilter &&
      category == other.category &&
      month == other.month &&
      text == other.text;

  @override
  int get hashCode => Object.hash(category, month, text);
}

/// Clave estable de un mes, por ejemplo `2026-10`.
String monthKey(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}';

const _monthNames = [
  '',
  'Enero',
  'Febrero',
  'Marzo',
  'Abril',
  'Mayo',
  'Junio',
  'Julio',
  'Agosto',
  'Septiembre',
  'Octubre',
  'Noviembre',
  'Diciembre',
];

/// Etiqueta legible de una clave de mes.
String monthLabel(String key) {
  if (key == MovementFilter.allMonths) return MovementFilter.allMonths;
  final parts = key.split('-');
  final month = int.tryParse(parts.last) ?? 0;
  if (month < 1 || month > 12) return key;
  return '${_monthNames[month]} ${parts.first}';
}
