import 'package:flutter/material.dart';

/// Etiqueta suave (fondo del color con transparencia + texto oscurecido).
/// Se usa para el curso, la prioridad y el tipo de tarea, y para los
/// pendientes de cada curso.
class InfoChip extends StatelessWidget {
  const InfoChip({
    super.key,
    required this.texto,
    required this.color,
    this.mostrarPunto = false,
  });

  final String texto;
  final Color color;
  final bool mostrarPunto;

  @override
  Widget build(BuildContext context) {
    final colorTexto = Color.lerp(color, Colors.black, .25)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (mostrarPunto) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 7),
          ],
          Text(
            texto,
            style: TextStyle(
              color: colorTexto,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
