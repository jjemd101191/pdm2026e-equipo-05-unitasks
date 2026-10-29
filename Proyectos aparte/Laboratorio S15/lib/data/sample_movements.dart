import '../models/movement.dart';

// Datos fijos: cada ID permanece igual entre reconstrucciones.
final sampleMovements = List<Movement>.unmodifiable(
  List.generate(48, (index) {
    const titles = [
      'Supermercado',
      'Transporte',
      'Pago de proyecto',
      'Café',
      'Internet',
      'Librería',
    ];
    const categories = [
      'Alimentación',
      'Movilidad',
      'Ingresos',
      'Alimentación',
      'Servicios',
      'Estudios',
    ];
    const amounts = [-24550, -1500, 180000, -2200, -27500, -8500];
    final kind = index % titles.length;
    return Movement(
      id: 'mov-${(index + 1).toString().padLeft(3, '0')}',
      title: titles[kind],
      category: categories[kind],
      date: DateTime(2026, 10, 23).subtract(Duration(days: index)),
      amountInCents: amounts[kind],
    );
  }),
);
