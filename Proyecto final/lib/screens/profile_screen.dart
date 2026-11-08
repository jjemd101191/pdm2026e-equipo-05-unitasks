import 'package:flutter/material.dart';

import '../data/course_repository.dart';
import '../data/settings_repository.dart';
import '../data/task_repository.dart';
import '../theme.dart';
import '../widgets/estado_vista.dart';
import 'premium_screen.dart';

/// Pestaña «Perfil».
///
/// Muestra el estado real de la cuenta local y deja explícito qué funciones
/// de Premium todavía no están implementadas, sin simular compras ni planes.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.repositorio,
    required this.cursosRepositorio,
    required this.ajustes,
  });

  final TaskRepository repositorio;
  final CourseRepository cursosRepositorio;
  final SettingsRepository ajustes;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _cursos = 0;
  int _activas = 0;
  int _completadas = 0;
  bool _esPremium = false;
  bool _cargando = false;
  bool _hayError = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    if (_cargando) return;
    setState(() {
      _cargando = true;
      _hayError = false;
    });
    try {
      final cursos = await widget.cursosRepositorio.watchCursos().first;
      final tareas = await widget.repositorio.watchTareas().first;
      final premium = await widget.ajustes.esPremium();
      if (!mounted) return;
      setState(() {
        _cursos = cursos.length;
        _activas = tareas.where((tarea) => !tarea.completada).length;
        _completadas = tareas.where((tarea) => tarea.completada).length;
        _esPremium = premium;
        _cargando = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _cargando = false;
          _hayError = true;
        });
      }
    }
  }

  Future<void> _abrirPremium() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => PremiumScreen(ajustes: widget.ajustes)),
    );
    if (!mounted) return;
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          Row(
            children: [
              Container(
                width: 62,
                height: 62,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: kIndigoSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: kIndigoDark,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Perfil local',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: kInk,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Tu organización académica',
                      style: TextStyle(fontSize: 12.5, color: kMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_cargando)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: LinearProgressIndicator(
                semanticsLabel: 'Cargando resumen del perfil',
              ),
            ),
          if (_hayError)
            EstadoVista(
              icono: Icons.error_outline,
              mensaje:
                  'No pudimos cargar tu resumen. Inténtalo de nuevo para consultar tus cursos y tareas.',
              etiquetaBoton: 'Reintentar',
              onPressed: _cargar,
            )
          else
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: kLine),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  _Dato(
                    valor: _cargando ? '—' : '$_cursos',
                    etiqueta: 'cursos',
                  ),
                  const _Separador(),
                  _Dato(
                    valor: _cargando ? '—' : '$_activas',
                    etiqueta: 'activas',
                  ),
                  const _Separador(),
                  _Dato(
                    valor: _cargando ? '—' : '$_completadas',
                    etiqueta: 'completadas',
                  ),
                ],
              ),
            ),
          if (!_cargando &&
              !_hayError &&
              _cursos == 0 &&
              _activas == 0 &&
              _completadas == 0)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                'Aún no tienes cursos ni tareas. Empieza agregando un curso en Cursos.',
                style: TextStyle(fontSize: 13, color: kMuted, height: 1.5),
              ),
            ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: kAmberSoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.workspace_premium_outlined,
                      color: kAmberDark,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _esPremium ? 'Plan Premium' : 'Plan Gratis',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: kAmberDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _esPremium
                                ? 'Activo en este dispositivo: la app no '
                                      'muestra anuncios.'
                                : 'La versión gratis se apoya en un anuncio '
                                      'al completar tareas. Premium los quita '
                                      'y desbloquea las funciones futuras.',
                            style: const TextStyle(
                              fontSize: 12.3,
                              height: 1.45,
                              color: Color(0xFF92400E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: _abrirPremium,
                    style: TextButton.styleFrom(
                      foregroundColor: kAmberDark,
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      _esPremium
                          ? 'Ver mi plan Premium'
                          : 'Quitar anuncios con Premium',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: kSoftBg,
              border: Border.all(color: kLine),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lock_outline, size: 20, color: kMuted),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tus datos viven en este dispositivo',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: kInk,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Los cursos y las tareas se guardan en una base SQLite '
                        'local. Esta versión no envía información a ningún '
                        'servidor.',
                        style: TextStyle(
                          fontSize: 12.3,
                          height: 1.45,
                          color: kMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Acerca de TaskU',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Versión 1.3.0 · PDM 2026 · Equipo 05\n'
            'Seguimiento de compromisos académicos con Flutter.',
            style: TextStyle(fontSize: 12.3, height: 1.55, color: kMuted),
          ),
        ],
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  const _Dato({required this.valor, required this.etiqueta});

  final String valor;
  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            valor,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: kInk,
            ),
          ),
          Text(
            etiqueta,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: kMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _Separador extends StatelessWidget {
  const _Separador();

  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 32,
    color: kLine,
    margin: const EdgeInsets.symmetric(horizontal: 8),
  );
}
