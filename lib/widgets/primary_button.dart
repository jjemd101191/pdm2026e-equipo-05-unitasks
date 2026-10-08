import 'package:flutter/material.dart';

import '../theme.dart';

/// Botón principal de TaskU (alto y redondeado), usado para las acciones
/// destacadas: completar tarea y guardar curso.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final estilo = FilledButton.styleFrom(
      backgroundColor: color ?? kIndigo,
      minimumSize: const Size.fromHeight(52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
    );
    final icono = icon;
    if (icono == null) {
      return FilledButton(
        onPressed: onPressed,
        style: estilo,
        child: Text(label),
      );
    }
    return FilledButton.icon(
      onPressed: onPressed,
      style: estilo,
      icon: Icon(icono, size: 20),
      label: Text(label),
    );
  }
}
