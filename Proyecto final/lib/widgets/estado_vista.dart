import 'package:flutter/material.dart';

import '../theme.dart';

class EstadoVista extends StatelessWidget {
  const EstadoVista({
    super.key,
    required this.icono,
    required this.mensaje,
    required this.etiquetaBoton,
    required this.onPressed,
  });

  final IconData icono;
  final String mensaje;
  final String etiquetaBoton;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 46, color: const Color(0xFFCBD5E1)),
            const SizedBox(height: 14),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.5,
                color: kMuted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton(onPressed: onPressed, child: Text(etiquetaBoton)),
          ],
        ),
      ),
    );
  }
}
