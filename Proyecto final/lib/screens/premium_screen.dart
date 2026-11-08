import 'package:flutter/material.dart';

import '../data/settings_repository.dart';
import '../theme.dart';

/// Extensión Premium de TaskU.
///
/// La compra es una **demostración académica**: no hay pasarela de pago ni
/// cobro real. El único efecto es guardar el plan en el dispositivo y dejar
/// de mostrar anuncios.
class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key, required this.ajustes});

  final SettingsRepository ajustes;

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool _cargando = true;
  bool _premium = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final premium = await widget.ajustes.esPremium();
    if (!mounted) return;
    setState(() {
      _premium = premium;
      _cargando = false;
    });
  }

  Future<void> _activar() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: const Text('Activar Premium (demostración)'),
        content: const Text(
          'Esta entrega no procesa pagos reales. Al continuar se guarda el '
          'plan Premium en este dispositivo y la app deja de mostrar anuncios.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contexto, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(contexto, true),
            child: const Text('Activar'),
          ),
        ],
      ),
    );
    if (confirmar != true || !mounted) return;
    await widget.ajustes.activarPremium();
    if (!mounted) return;
    setState(() => _premium = true);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        const SnackBar(content: Text('Premium activo: sin anuncios')),
      );
  }

  Future<void> _desactivar() async {
    await widget.ajustes.desactivarPremium();
    if (!mounted) return;
    setState(() => _premium = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TaskU Premium')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: kAmberSoft,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.workspace_premium,
                        size: 42,
                        color: kAmberDark,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Menos interrupciones, más tiempo estudiando',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: kAmberDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _premium
                            ? 'Tu plan Premium está activo en este dispositivo.'
                            : 'La versión gratis se apoya en anuncios. '
                                  'Premium los quita y desbloquea las '
                                  'funciones futuras.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const _Beneficio(
                  icono: Icons.block,
                  texto: 'Sin anuncios al completar tareas.',
                ),
                const _Beneficio(
                  icono: Icons.cloud_outlined,
                  texto:
                      'Acceso anticipado a la nube y a la exportación a PDF '
                      'cuando estén disponibles.',
                ),
                const _Beneficio(
                  icono: Icons.favorite_outline,
                  texto: 'Apoyas el mantenimiento y las mejoras de TaskU.',
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: kSoftBg,
                    border: Border.all(color: kLine),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'US\$1.99 – US\$4.99 · pago único',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: kInk,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Precio de referencia del plan de monetización. '
                        'La compra es simulada: no se cobra nada.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: kMuted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (_premium) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: kGreenSoft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle, color: kGreenDark),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Premium activo: la app ya no muestra anuncios.',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: kGreenDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _desactivar,
                    child: const Text('Volver al plan gratis (demostración)'),
                  ),
                ] else
                  FilledButton.icon(
                    onPressed: _activar,
                    icon: const Icon(Icons.workspace_premium),
                    label: const Text('Activar Premium (demostración)'),
                  ),
              ],
            ),
    );
  }
}

class _Beneficio extends StatelessWidget {
  const _Beneficio({required this.icono, required this.texto});

  final IconData icono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icono, size: 20, color: kIndigo),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(fontSize: 13.5, height: 1.4, color: kInk),
            ),
          ),
        ],
      ),
    );
  }
}
