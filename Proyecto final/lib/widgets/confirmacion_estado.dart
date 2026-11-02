import 'package:flutter/material.dart';

/// Pregunta antes de completar o reabrir una tarea.
///
/// La usan Inicio y el detalle de tarea para que el texto y las consecuencias
/// se expliquen igual en ambas pantallas. Devuelve `true` solo si la persona
/// pulsa «Confirmar»; cerrar el diálogo equivale a cancelar.
Future<bool> confirmarCambioEstado(
  BuildContext context, {
  required bool completada,
  required String tituloTarea,
  int subtareas = 0,
}) async {
  final confirmado = await showDialog<bool>(
    context: context,
    builder: (contexto) => AlertDialog(
      title: Text(completada ? '¿Reabrir tarea?' : '¿Completar tarea?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '«$tituloTarea»',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Text(_consecuencia(completada: completada, subtareas: subtareas)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(contexto, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(contexto, true),
          child: const Text('Confirmar'),
        ),
      ],
    ),
  );
  return confirmado ?? false;
}

/// Explica qué pasará con la tarea y sus subtareas.
String _consecuencia({required bool completada, required int subtareas}) {
  if (!completada) {
    if (subtareas == 0) return 'Dejará de aparecer en tus pendientes.';
    if (subtareas == 1) {
      return 'Dejará de aparecer en tus pendientes y su subtarea se marcará '
          'como completada.';
    }
    return 'Dejará de aparecer en tus pendientes y sus $subtareas subtareas se '
        'marcarán como completadas.';
  }
  if (subtareas == 0) return 'Volverá a estar en progreso.';
  if (subtareas == 1) {
    return 'Volverá a estar en progreso. Su subtarea seguirá marcada como '
        'completada.';
  }
  return 'Volverá a estar en progreso. Sus $subtareas subtareas seguirán '
      'marcadas como completadas.';
}
