/// Generador de identificadores locales.
///
/// Combina la marca de tiempo en microsegundos con un contador para que dos
/// registros creados en el mismo instante no compartan id. No necesita red ni
/// paquetes externos.
int _contador = 0;

String nuevoId(String prefijo) {
  final marca = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
  final secuencia = (_contador++).toRadixString(36);
  return '$prefijo-$marca-$secuencia';
}
