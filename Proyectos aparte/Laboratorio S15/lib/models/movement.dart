class Movement {
  const Movement({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.amountInCents,
  });

  final String id;
  final String title;
  final String category;
  final DateTime date;
  // Los centavos evitan errores de precisión al representar dinero.
  final int amountInCents;

  bool get isIncome => amountInCents > 0;

  String get formattedAmount =>
      '${isIncome ? '+' : '−'}Q ${(amountInCents.abs() / 100).toStringAsFixed(2)}';

  String get formattedDate =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';
}
