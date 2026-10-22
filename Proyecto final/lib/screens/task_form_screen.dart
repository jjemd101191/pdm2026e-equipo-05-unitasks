import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../models/course.dart';
import '../models/task.dart';
import '../theme.dart';
import '../widgets/primary_button.dart';

/// 2 · Registro / edición de tarea.
/// El mismo formulario sirve para registrar una tarea nueva (botón + de la
/// pestaña «Inicio») y para editar una existente (lápiz del detalle, 4A).
/// Valida el título y devuelve la [Task] resultante al guardar.
class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key, this.tarea});

  /// Tarea a editar; `null` cuando se registra una nueva.
  final Task? tarea;

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  static const List<String> _tipos = ['Tarea', 'Examen', 'Proyecto'];
  static const List<String> _prioridades = ['Alta', 'Media', 'Baja'];
  static const List<String> _recordatorios = [
    'Sin recordatorio',
    '1 hora antes',
    'El mismo día · 8:00 a. m.',
    '1 día antes · 8:00 a. m.',
    '2 días antes · 8:00 a. m.',
  ];
  static const String _recordatorioPorDefecto = '1 día antes · 8:00 a. m.';
  static const List<String> _nombresDias = [
    'Lun',
    'Mar',
    'Mié',
    'Jue',
    'Vie',
    'Sáb',
    'Dom',
  ];
  static const List<String> _nombresMeses = [
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

  late final TextEditingController _titulo = TextEditingController(
    text: widget.tarea?.titulo ?? '',
  );
  late final TextEditingController _descripcion = TextEditingController(
    text: widget.tarea?.descripcion ?? '',
  );
  late Course _curso = widget.tarea?.curso ?? cursosDemo.first;
  late String _tipo = widget.tarea?.tipo ?? 'Tarea';
  late String _prioridad = widget.tarea?.prioridad ?? 'Media';
  late DateTime? _fecha = _parsearFecha(widget.tarea?.fechaEntrega ?? '');
  late String _hora = _parsearHora(widget.tarea?.fechaEntrega ?? '') ?? '23:59';
  late String _recordatorio = (widget.tarea?.recordatorio.isEmpty ?? true)
      ? _recordatorioPorDefecto
      : widget.tarea!.recordatorio;

  @override
  void dispose() {
    _titulo.dispose();
    _descripcion.dispose();
    super.dispose();
  }

  /// Color de la prioridad, igual que en el detalle de tarea (4A).
  Color _colorPrioridad(String prioridad) => switch (prioridad) {
    'Alta' => kRed,
    'Baja' => kGreen,
    _ => kAmber,
  };

  /// Formatea la fecha como en el mockup: «Vie 10 oct 2026».
  static String _formatearFecha(DateTime fecha) =>
      '${_nombresDias[fecha.weekday - 1]} ${fecha.day} '
      '${_nombresMeses[fecha.month - 1]} ${fecha.year}';

  /// Interpreta «Vie 10 oct 2026 · 23:59» (formato de este formulario y de
  /// los datos demo). Devuelve null si el texto está vacío o no se entiende.
  static DateTime? _parsearFecha(String texto) {
    if (texto.isEmpty) return null;
    final partes = texto.split('·').first.trim().split(' ');
    if (partes.length < 4) return null;
    final dia = int.tryParse(partes[1]);
    final mes = _nombresMeses.indexOf(partes[2].toLowerCase()) + 1;
    final anio = int.tryParse(partes[3]);
    if (dia == null || mes == 0 || anio == null) return null;
    return DateTime(anio, mes, dia);
  }

  /// Interpreta la hora de «Vie 10 oct 2026 · 23:59».
  static String? _parsearHora(String texto) {
    final partes = texto.split('·');
    if (partes.length < 2) return null;
    final trozos = partes[1].trim().split(':');
    final hora = int.tryParse(trozos[0]);
    final minuto = trozos.length > 1 ? int.tryParse(trozos[1]) : null;
    if (hora == null || minuto == null) return null;
    return '$hora:${minuto.toString().padLeft(2, '0')}';
  }

  static TimeOfDay? _parsearHoraDelDia(String texto) {
    final trozos = texto.split(':');
    final hora = int.tryParse(trozos[0]);
    final minuto = trozos.length > 1 ? int.tryParse(trozos[1]) : null;
    if (hora == null || minuto == null) return null;
    return TimeOfDay(hour: hora, minute: minuto);
  }

  Future<void> _elegirFecha() async {
    final hoy = DateTime.now();
    final elegida = await showDatePicker(
      context: context,
      initialDate: _fecha ?? hoy,
      firstDate: DateTime(hoy.year - 1),
      lastDate: DateTime(hoy.year + 3),
      helpText: 'Fecha de entrega',
    );
    if (!mounted || elegida == null) return;
    setState(() => _fecha = elegida);
  }

  Future<void> _elegirHora() async {
    final actual =
        _parsearHoraDelDia(_hora) ?? const TimeOfDay(hour: 23, minute: 59);
    final elegida = await showTimePicker(
      context: context,
      initialTime: actual,
      helpText: 'Hora de entrega',
    );
    if (!mounted || elegida == null) return;
    setState(
      () => _hora =
          '${elegida.hour}:${elegida.minute.toString().padLeft(2, '0')}',
    );
  }

  void _guardar() {
    final titulo = _titulo.text.trim();
    if (titulo.isEmpty) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(content: Text('Escribe el título de la tarea')),
        );
      return;
    }
    final conRecordatorio = _recordatorio != 'Sin recordatorio';
    final fechaTexto = _fecha == null
        ? ''
        : '${_formatearFecha(_fecha!)} · $_hora';
    Navigator.of(context).pop(
      Task(
        titulo: titulo,
        curso: _curso,
        prioridad: _prioridad,
        tipo: _tipo,
        estado: widget.tarea?.estado ?? 'Pendiente',
        descripcion: _descripcion.text.trim(),
        fechaEntrega: fechaTexto,
        recordatorio: conRecordatorio ? _recordatorio : '',
        recordatorioActivo: conRecordatorio,
        subtareas: widget.tarea?.subtareas,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final esNueva = widget.tarea == null;
    // Si la tarea editada trae un curso o recordatorio fuera del catálogo
    // demo, se incluye como opción para no perder el dato.
    final opcionesCurso = [
      ...cursosDemo,
      if (!cursosDemo.contains(_curso)) _curso,
    ];
    final opcionesRecordatorio = [
      ..._recordatorios,
      if (!_recordatorios.contains(_recordatorio)) _recordatorio,
    ];
    return Scaffold(
      appBar: AppBar(title: Text(esNueva ? 'Nueva tarea' : 'Editar tarea')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        children: [
          TextField(
            controller: _titulo,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Título de la tarea',
              hintText: 'Ej.: Entregar avance del proyecto',
            ),
          ),
          const SizedBox(height: 18),
          InputDecorator(
            decoration: const InputDecoration(labelText: 'Curso'),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Course>(
                value: _curso,
                isDense: true,
                isExpanded: true,
                items: [
                  for (final curso in opcionesCurso)
                    DropdownMenuItem(
                      value: curso,
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: curso.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 9),
                          Text(
                            curso.nombre,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
                onChanged: (curso) => setState(() => _curso = curso ?? _curso),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const _Etiqueta('Tipo de compromiso'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 7,
            runSpacing: 8,
            children: [
              for (final tipo in _tipos)
                _ChipOpcion(
                  texto: tipo,
                  seleccionado: _tipo == tipo,
                  color: kLagoon,
                  onTap: () => setState(() => _tipo = tipo),
                ),
            ],
          ),
          const SizedBox(height: 18),
          const _Etiqueta('Prioridad'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 7,
            runSpacing: 8,
            children: [
              for (final prioridad in _prioridades)
                _ChipOpcion(
                  texto: prioridad,
                  seleccionado: _prioridad == prioridad,
                  color: _colorPrioridad(prioridad),
                  onTap: () => setState(() => _prioridad = prioridad),
                ),
            ],
          ),
          const SizedBox(height: 18),
          const _Etiqueta('Fecha de entrega'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _CampoSelector(
                  icono: Icons.event_outlined,
                  valor: _fecha == null
                      ? 'Elegir fecha'
                      : _formatearFecha(_fecha!),
                  onTap: _elegirFecha,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '·',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: _CampoSelector(
                  icono: Icons.schedule,
                  valor: _hora,
                  onTap: _elegirHora,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          InputDecorator(
            decoration: const InputDecoration(labelText: 'Recordatorio'),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _recordatorio,
                isDense: true,
                isExpanded: true,
                items: [
                  for (final recordatorio in opcionesRecordatorio)
                    DropdownMenuItem(
                      value: recordatorio,
                      child: Text(
                        recordatorio,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
                onChanged: (valor) =>
                    setState(() => _recordatorio = valor ?? _recordatorio),
              ),
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _descripcion,
            textCapitalization: TextCapitalization.sentences,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Descripción',
              hintText: 'Detalles de la entrega, rúbrica, indicaciones…',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kLagoonSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.notifications_active_outlined,
                  size: 18,
                  color: kLagoon,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _recordatorio == 'Sin recordatorio'
                        ? 'Sin recordatorio: la tarea aparecerá en la lista de '
                              'pendientes sin avisos previos. Puedes activarlo '
                              'después desde el detalle de la tarea.'
                        : 'Con recordatorio «$_recordatorio»: aparecerá como '
                              '«Activo» en el detalle de la tarea.',
                    style: const TextStyle(
                      fontSize: 12.3,
                      color: Color(0xFF1D5461),
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
              label: esNueva ? 'Guardar tarea' : 'Guardar cambios',
              color: kLagoon,
            ),
          ),
        ),
      ),
    );
  }
}

/// Etiqueta de sección del formulario («Tipo», «Prioridad», «Fecha»).
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

/// Opción seleccionable del formulario (tipo y prioridad de la tarea).
class _ChipOpcion extends StatelessWidget {
  const _ChipOpcion({
    required this.texto,
    required this.seleccionado,
    required this.color,
    required this.onTap,
  });

  final String texto;
  final bool seleccionado;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 41,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: seleccionado ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: seleccionado ? color : const Color(0xFFCBD5E1),
            width: 1.6,
          ),
        ),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: 12.8,
            fontWeight: FontWeight.w600,
            color: seleccionado ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }
}

/// Campo que abre un selector (fecha u hora) al tocarlo.
class _CampoSelector extends StatelessWidget {
  const _CampoSelector({
    required this.icono,
    required this.valor,
    required this.onTap,
  });

  final IconData icono;
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
            Icon(icono, size: 18, color: const Color(0xFF94A3B8)),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                valor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
