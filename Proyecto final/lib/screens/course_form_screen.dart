import 'package:flutter/material.dart';

import '../models/course.dart';
import '../theme.dart';
import '../widgets/primary_button.dart';

/// 4C · Registrar / editar curso.
/// El mismo formulario sirve para crear un curso (botón +) y para editarlo
/// (menú ⋮ → Editar curso). Devuelve el [Course] resultante al guardar.
class CourseFormScreen extends StatefulWidget {
  const CourseFormScreen({super.key, this.curso});

  /// Curso a editar; `null` cuando se registra uno nuevo.
  final Course? curso;

  @override
  State<CourseFormScreen> createState() => _CourseFormScreenState();
}

class _CourseFormScreenState extends State<CourseFormScreen> {
  static const List<String> _periodos = ['2026-1', '2026-2', '2027-1'];
  static const List<Color> _colores = [
    kIndigo,
    kSky,
    kGreen,
    kAmber,
    kPink,
    kSlate,
  ];
  static const List<String> _diasSemana = [
    'Lun',
    'Mar',
    'Mié',
    'Jue',
    'Vie',
    'Sáb',
  ];

  late final TextEditingController _nombre = TextEditingController(
    text: widget.curso?.nombre ?? '',
  );
  late final TextEditingController _docente = TextEditingController(
    text: widget.curso?.docente ?? '',
  );
  late Color _color = widget.curso?.color ?? kSky;
  late final Set<String> _dias = {
    ...?widget.curso?.dias,
    if (widget.curso == null) 'Mar',
    if (widget.curso == null) 'Jue',
  };
  late String _inicio = widget.curso?.horaInicio ?? '8:00';
  late String _fin = widget.curso?.horaFin ?? '10:00';
  late String _periodo = widget.curso?.periodo ?? '2026-2';

  @override
  void dispose() {
    _nombre.dispose();
    _docente.dispose();
    super.dispose();
  }

  Future<void> _elegirHora({required bool inicio}) async {
    final actual =
        _parsearHora(inicio ? _inicio : _fin) ??
        const TimeOfDay(hour: 8, minute: 0);
    final elegida = await showTimePicker(
      context: context,
      initialTime: actual,
      helpText: inicio ? 'Hora de inicio' : 'Hora de fin',
    );
    if (!mounted || elegida == null) return;
    final texto =
        '${elegida.hour}:${elegida.minute.toString().padLeft(2, '0')}';
    setState(() {
      if (inicio) {
        _inicio = texto;
      } else {
        _fin = texto;
      }
    });
  }

  TimeOfDay? _parsearHora(String texto) {
    final partes = texto.split(':');
    if (partes.length != 2) return null;
    final hora = int.tryParse(partes[0]);
    final minuto = int.tryParse(partes[1]);
    if (hora == null || minuto == null) return null;
    return TimeOfDay(hour: hora, minute: minuto);
  }

  void _guardar() {
    final nombre = _nombre.text.trim();
    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(content: Text('Escribe el nombre del curso')),
        );
      return;
    }
    final docente = _docente.text.trim();
    Navigator.of(context).pop(
      Course(
        nombre: nombre,
        docente: docente.isEmpty ? 'Sin docente' : docente,
        color: _color,
        dias: _diasSemana.where(_dias.contains).toList(),
        horaInicio: _inicio,
        horaFin: _fin,
        periodo: _periodo,
        pendientes: widget.curso?.pendientes ?? 0,
        totalTareas: widget.curso?.totalTareas ?? 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final esNuevo = widget.curso == null;
    return Scaffold(
      appBar: AppBar(title: Text(esNuevo ? 'Nuevo curso' : 'Editar curso')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        children: [
          TextField(
            controller: _nombre,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(labelText: 'Nombre del curso'),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _docente,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Docente'),
          ),
          const SizedBox(height: 18),
          const _Etiqueta('Color del curso'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 13,
            runSpacing: 11,
            children: [
              for (final color in _colores)
                GestureDetector(
                  onTap: () => setState(() => _color = color),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5),
                      boxShadow: _color == color
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: .55),
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          const _Etiqueta('Días de clase'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 7,
            runSpacing: 8,
            children: [
              for (final dia in _diasSemana)
                GestureDetector(
                  onTap: () => setState(() {
                    if (_dias.contains(dia)) {
                      _dias.remove(dia);
                    } else {
                      _dias.add(dia);
                    }
                  }),
                  child: Container(
                    width: 41,
                    height: 41,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _dias.contains(dia) ? kIndigo : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _dias.contains(dia)
                            ? kIndigo
                            : const Color(0xFFCBD5E1),
                        width: 1.6,
                      ),
                    ),
                    child: Text(
                      dia,
                      style: TextStyle(
                        fontSize: 12.3,
                        fontWeight: FontWeight.w600,
                        color: _dias.contains(dia)
                            ? Colors.white
                            : const Color(0xFF475569),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          const _Etiqueta('Hora de clase'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _CampoHora(
                  valor: _inicio,
                  onTap: () => _elegirHora(inicio: true),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '–',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: _CampoHora(
                  valor: _fin,
                  onTap: () => _elegirHora(inicio: false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          InputDecorator(
            decoration: const InputDecoration(labelText: 'Periodo académico'),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _periodo,
                isDense: true,
                isExpanded: true,
                items: [
                  for (final periodo in _periodos)
                    DropdownMenuItem(
                      value: periodo,
                      child: Text(
                        periodo,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
                onChanged: (valor) =>
                    setState(() => _periodo = valor ?? _periodo),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kIndigoSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.local_offer_outlined, size: 18, color: kIndigo),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Las tareas y exámenes de este curso aparecerán con este '
                    'color en la lista de pendientes y en el calendario.',
                    style: TextStyle(
                      fontSize: 12.3,
                      color: Color(0xFF3730A3),
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: kLine)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: PrimaryButton(
              onPressed: _guardar,
              icon: Icons.check,
              label: esNuevo ? 'Guardar curso' : 'Guardar cambios',
            ),
          ),
        ),
      ),
    );
  }
}

/// Etiqueta de sección del formulario («Color del curso», «Días de clase»).
class _Etiqueta extends StatelessWidget {
  const _Etiqueta(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w700,
        color: Color(0xFF334155),
      ),
    );
  }
}

/// Campo que abre el selector de hora al tocarlo.
class _CampoHora extends StatelessWidget {
  const _CampoHora({required this.valor, required this.onTap});

  final String valor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF94A3B8), width: 1.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.schedule, size: 18, color: Color(0xFF94A3B8)),
            const SizedBox(width: 9),
            Text(
              valor,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
