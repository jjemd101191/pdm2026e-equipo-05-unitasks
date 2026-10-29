import 'package:flutter/material.dart';

import '../models/course.dart';
import '../models/task.dart';
import '../theme.dart';
import '../utils/fechas.dart';
import '../utils/id.dart';
import '../widgets/primary_button.dart';

/// 2 · Registro / edición de tarea.
/// El mismo formulario sirve para registrar una tarea nueva (botón + de
/// Inicio) y para editar una existente (lápiz del detalle, 4A).
/// Valida el título y devuelve la [Task] resultante al guardar; no escribe en
/// la base de datos: eso lo hace la pantalla que lo abrió, para que el
/// formulario siga siendo fácil de probar.
class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key, required this.cursos, this.tarea})
    : assert(cursos.length > 0, 'Se necesita al menos un curso');

  /// Cursos disponibles para asociar la tarea.
  final List<Course> cursos;

  /// Tarea a editar; `null` cuando se registra una nueva.
  final Task? tarea;

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  late final TextEditingController _titulo;
  late final TextEditingController _descripcion;
  late final List<Course> _cursosDisponibles;
  late Course _curso;
  late TipoTarea _tipo;
  late Prioridad _prioridad;
  late DateTime _fecha;
  late TimeOfDay _hora;
  late RecordatorioOpcion _recordatorio;

  @override
  void initState() {
    super.initState();
    final tarea = widget.tarea;
    _titulo = TextEditingController(text: tarea?.titulo ?? '');
    _descripcion = TextEditingController(text: tarea?.descripcion ?? '');
    _cursosDisponibles = [...widget.cursos];
    final cursoActual = tarea == null
        ? null
        : _cursosDisponibles.porId(tarea.cursoId);
    if (cursoActual != null && !_cursosDisponibles.contains(cursoActual)) {
      _cursosDisponibles.add(cursoActual);
    }
    _curso = cursoActual ?? _cursosDisponibles.first;
    _tipo = tarea?.tipo ?? TipoTarea.tarea;
    _prioridad = tarea?.prioridad ?? Prioridad.media;
    // Una tarea nueva propone entregar mañana a las 23:59.
    final entrega = tarea?.fechaEntrega;
    _fecha = soloDia(entrega ?? DateTime.now().add(const Duration(days: 1)));
    _hora = entrega == null
        ? const TimeOfDay(hour: 23, minute: 59)
        : TimeOfDay(hour: entrega.hour, minute: entrega.minute);
    _recordatorio = tarea == null
        ? RecordatorioOpcion.unDia
        : RecordatorioOpcion.desdeMinutos(tarea.recordatorioMinutos) ??
              RecordatorioOpcion.sinRecordatorio;
  }

  @override
  void dispose() {
    _titulo.dispose();
    _descripcion.dispose();
    super.dispose();
  }

  /// Color de la prioridad, igual que en el detalle de tarea (4A).
  Color _colorPrioridad(Prioridad prioridad) => switch (prioridad) {
    Prioridad.alta => kRed,
    Prioridad.baja => kGreen,
    Prioridad.media => kAmber,
  };

  String get _horaTexto =>
      '${_hora.hour}:${_hora.minute.toString().padLeft(2, '0')}';

  DateTime get _fechaHora =>
      DateTime(_fecha.year, _fecha.month, _fecha.day, _hora.hour, _hora.minute);

  Future<void> _elegirFecha() async {
    final hoy = DateTime.now();
    final elegida = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(hoy.year - 1),
      lastDate: DateTime(hoy.year + 5),
      helpText: 'Fecha de entrega',
    );
    if (!mounted || elegida == null) return;
    setState(() => _fecha = elegida);
  }

  Future<void> _elegirHora() async {
    final elegida = await showTimePicker(
      context: context,
      initialTime: _hora,
      helpText: 'Hora de entrega',
    );
    if (!mounted || elegida == null) return;
    setState(() => _hora = elegida);
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

    Navigator.of(context).pop(
      Task(
        id: widget.tarea?.id ?? nuevoId('tarea'),
        titulo: titulo,
        cursoId: _curso.id,
        prioridad: _prioridad,
        tipo: _tipo,
        estado: widget.tarea?.estado ?? EstadoTarea.pendiente,
        descripcion: _descripcion.text.trim(),
        fechaEntrega: _fechaHora,
        recordatorioMinutos: _recordatorio.minutos,
        subtareas: widget.tarea?.subtareas ?? const <Subtask>[],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final esNueva = widget.tarea == null;
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
                  for (final curso in _cursosDisponibles)
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
              for (final tipo in TipoTarea.values)
                _ChipOpcion(
                  texto: tipo.etiqueta,
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
              for (final prioridad in Prioridad.values)
                _ChipOpcion(
                  texto: prioridad.etiqueta,
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
                  valor: formatearFecha(_fecha),
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
                  valor: _horaTexto,
                  onTap: _elegirHora,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          InputDecorator(
            decoration: const InputDecoration(labelText: 'Recordatorio'),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<RecordatorioOpcion>(
                value: _recordatorio,
                isDense: true,
                isExpanded: true,
                onChanged: (valor) => setState(
                  () => _recordatorio =
                      valor ?? RecordatorioOpcion.sinRecordatorio,
                ),
                items: [
                  for (final opcion in RecordatorioOpcion.values)
                    DropdownMenuItem(
                      value: opcion,
                      child: Text(
                        opcion.etiqueta,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
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
                    _recordatorio == RecordatorioOpcion.sinRecordatorio
                        ? 'Sin recordatorio: la tarea solo aparecerá en tu '
                              'lista de pendientes y en el calendario.'
                        : 'Con recordatorio «${_recordatorio.etiqueta}». '
                              'El aviso aparecerá en la lista de pendientes; '
                              'las notificaciones del sistema llegarán en una '
                              'próxima versión.',
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
  final VoidCallback? onTap;

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
