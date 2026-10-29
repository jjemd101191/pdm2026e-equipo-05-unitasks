/// Utilidades de fecha en español, sin depender de la configuración regional
/// del dispositivo. Las fechas se guardan en ISO 8601 y solo se formatean al
/// mostrarlas.
const List<String> _diasCortos = [
  'Lun',
  'Mar',
  'Mié',
  'Jue',
  'Vie',
  'Sáb',
  'Dom',
];

const List<String> _mesesCortos = [
  'ene',
  'feb',
  'mar',
  'abr',
  'may',
  'jun',
  'jul',
  'ago',
  'sep',
  'oct',
  'nov',
  'dic',
];

const List<String> _mesesLargos = [
  'enero',
  'febrero',
  'marzo',
  'abril',
  'mayo',
  'junio',
  'julio',
  'agosto',
  'septiembre',
  'octubre',
  'noviembre',
  'diciembre',
];

/// Devuelve la fecha sin hora, para comparar días.
DateTime soloDia(DateTime fecha) =>
    DateTime(fecha.year, fecha.month, fecha.day);

bool mismoDia(DateTime? a, DateTime? b) =>
    a != null &&
    b != null &&
    a.year == b.year &&
    a.month == b.month &&
    a.day == b.day;

int diasEnMes(int anio, int mes) => DateTime(anio, mes + 1, 0).day;

/// Lunes = 1 … domingo = 7, igual que [DateTime.weekday].
String diaCorto(int weekday) => _diasCortos[weekday - 1];

/// «Vie 10 oct 2026».
String formatearFecha(DateTime fecha) =>
    '${_diasCortos[fecha.weekday - 1]} ${fecha.day} '
    '${_mesesCortos[fecha.month - 1]} ${fecha.year}';

/// «23:59».
String formatearHora(DateTime fecha) =>
    '${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}';

/// «Vie 10 oct 2026 · 23:59».
String formatearFechaHora(DateTime? fecha) {
  if (fecha == null) return 'Sin fecha';
  return '${formatearFecha(fecha)} · ${formatearHora(fecha)}';
}

/// «Octubre 2026», con mayúscula inicial para los encabezados.
String formatearMes(DateTime fecha) {
  final mes = _mesesLargos[fecha.month - 1];
  return '${mes[0].toUpperCase()}${mes.substring(1)} ${fecha.year}';
}

/// «10 oct» para listas compactas.
String formatearDiaMes(DateTime fecha) =>
    '${fecha.day} ${_mesesCortos[fecha.month - 1]}';
