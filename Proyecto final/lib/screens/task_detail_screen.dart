import 'package:flutter/material.dart';

import '../data/task_repository.dart';
import '../models/course.dart';
import '../models/task.dart';
import '../theme.dart';
import '../utils/fechas.dart';
import '../utils/id.dart';
import '../widgets/info_chip.dart';
import '../widgets/primary_button.dart';
import 'task_form_screen.dart';

/// 4A · Detalle de tarea.
/// Concentra toda la información y acciones de una tarea: completar, editar,
/// eliminar y gestionar subtareas. Cada cambio se guarda de inmediato en el
/// repositorio local.
class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({
    super.key,
    required this.tarea,
    required this.repositorio,
    required this.cursos,
  });

  final Task tarea;
  final TaskRepository repositorio;

  /// Cursos disponibles para el formulario de edición.
  final List<Course> cursos;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Task _tarea = widget.tarea;

  Color get _colorPrioridad => switch (_tarea.prioridad) {
    Prioridad.alta => kRed,
    Prioridad.baja => kGreen,
    Prioridad.media => kAmber,
  };

  void _avisar(String mensaje) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(mensaje)));
  }

  /// Persiste [nueva] y solo actualiza la pantalla si el guardado funcionó.
  Future<bool> _guardar(Task nueva, {String? mensaje}) async {
    try {
      await widget.repositorio.actualizar(nueva);
      if (!mounted) return true;
      setState(() => _tarea = nueva);
      if (mensaje != null) _avisar(mensaje);
      return true;
    } catch (_) {
      if (mounted) _avisar('No se pudo guardar el cambio');
      return false;
    }
  }

  Future<void> _alternarCompletada() async {
    final nueva = _tarea.alternarCompletada();
    final guardada = await _guardar(nueva);
    if (!guardada) return;
    _avisar(
      nueva.completada ? 'Tarea marcada como completada' : 'Tarea reabierta',
    );
  }

  Future<void> _alternarSubtarea(String id) async {
    await _guardar(_tarea.alternarSubtarea(id));
  }

  Future<void> _agregarSubtarea() async {
    final controlador = TextEditingController();
    final agregar = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: const Text('Nueva subtarea'),
        content: TextField(
          controller: controlador,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Ej.: Armar la presentación',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contexto, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(contexto, true),
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
    final texto = controlador.text.trim();
    controlador.dispose();
    if (!mounted || agregar != true || texto.isEmpty) return;
    await _guardar(
      _tarea.agregarSubtarea(Subtask(id: nuevoId('subtarea'), titulo: texto)),
    );
  }

  Future<void> _editar() async {
    final actualizada = await Navigator.of(context).push<Task>(
      MaterialPageRoute(
        builder: (_) => TaskFormScreen(tarea: _tarea, cursos: widget.cursos),
      ),
    );
    if (!mounted || actualizada == null) return;
    await _guardar(actualizada, mensaje: 'Cambios guardados');
  }

  Future<void> _confirmarEliminar() async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: const Text('¿Eliminar tarea?'),
        content: const Text(
          'La tarea y sus subtareas se quitarán de tu lista de pendientes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contexto, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(contexto, true),
            child: const Text('Eliminar', style: TextStyle(color: kRed)),
          ),
        ],
      ),
    );
    if (!mounted || confirmado != true) return;
    try {
      await widget.repositorio.eliminar(_tarea.id);
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) _avisar('No se pudo eliminar la tarea');
    }
  }

  @override
  Widget build(BuildContext context) {
    final recordatorioActivo = _tarea.recordatorioMinutos != null;
    final curso = widget.cursos.porId(_tarea.cursoId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de tarea'),
        actions: [
          IconButton(
            onPressed: _editar,
            tooltip: 'Editar tarea',
            icon: const Icon(Icons.edit_outlined, size: 22),
          ),
          PopupMenuButton<String>(
            tooltip: 'Más opciones',
            icon: const Icon(Icons.more_vert, size: 22),
            onSelected: (opcion) {
              if (opcion == 'eliminar') _confirmarEliminar();
            },
            itemBuilder: (contexto) => [
              const PopupMenuItem(
                value: 'eliminar',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 18, color: kRed),
                    SizedBox(width: 10),
                    Text('Eliminar tarea', style: TextStyle(color: kRed)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              InfoChip(
                texto: curso.nombre,
                color: curso.color,
                mostrarPunto: true,
              ),
              InfoChip(
                texto: 'Prioridad ${_tarea.prioridad.etiqueta.toLowerCase()}',
                color: _colorPrioridad,
                mostrarPunto: true,
              ),
              InfoChip(texto: _tarea.tipo.etiqueta, color: kSky),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _tarea.titulo,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w800,
              color: kInk,
              height: 1.24,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              color: kSoftBg,
              border: Border.all(color: kLine),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                _MetaFila(
                  icono: Icons.event_outlined,
                  colorIcono: kIndigo,
                  etiqueta: 'Fecha de entrega',
                  valor: formatearFechaHora(_tarea.fechaEntrega),
                  colorValor: _tarea.vencida ? kRed : null,
                  badge: _tarea.vencida
                      ? const _Badge(
                          texto: 'Vencida',
                          fondo: kRedSoft,
                          colorTexto: kRed,
                        )
                      : null,
                ),
                const Divider(height: 1, color: Color(0xFFEEF2F7)),
                _MetaFila(
                  icono: Icons.notifications_outlined,
                  colorIcono: kAmber,
                  etiqueta: 'Recordatorio',
                  valor: recordatorioActivo
                      ? _tarea.etiquetaRecordatorio
                      : 'Sin recordatorio',
                  badge: recordatorioActivo
                      ? const _Badge(
                          texto: 'Configurado',
                          fondo: kGreenSoft,
                          colorTexto: kGreenDark,
                        )
                      : null,
                ),
                const Divider(height: 1, color: Color(0xFFEEF2F7)),
                _MetaFila(
                  icono: Icons.schedule,
                  colorIcono: kSky,
                  etiqueta: 'Estado',
                  valor: _tarea.estado.etiqueta,
                  colorValor: _tarea.completada ? kGreenDark : null,
                  badge: _Badge(
                    texto: '${(_tarea.progreso * 100).round()} %',
                    fondo: _tarea.completada ? kGreenSoft : kAmberSoft,
                    colorTexto: _tarea.completada ? kGreenDark : kAmberDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 17),
          const _TituloSeccion('Descripción'),
          const SizedBox(height: 8),
          Text(
            _tarea.descripcion.isEmpty
                ? 'Sin descripción.'
                : _tarea.descripcion,
            style: TextStyle(
              fontSize: 13.3,
              color: _tarea.descripcion.isEmpty
                  ? const Color(0xFF94A3B8)
                  : const Color(0xFF475569),
              height: 1.52,
            ),
          ),
          const SizedBox(height: 17),
          _TituloSeccion(
            'Subtareas',
            extra:
                '${_tarea.completadas} de ${_tarea.subtareas.length} completadas',
          ),
          const SizedBox(height: 9),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: _tarea.progreso,
              minHeight: 6,
              backgroundColor: const Color(0xFFE2E8F0),
              color: kIndigo,
            ),
          ),
          const SizedBox(height: 6),
          for (final subtarea in _tarea.subtareas)
            _FilaSubtarea(
              subtarea: subtarea,
              onTap: () => _alternarSubtarea(subtarea.id),
            ),
          InkWell(
            onTap: _agregarSubtarea,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.add, size: 20, color: kIndigo),
                  SizedBox(width: 8),
                  Text(
                    'Agregar subtarea',
                    style: TextStyle(
                      color: kIndigo,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
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
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PrimaryButton(
                  onPressed: _alternarCompletada,
                  icon: _tarea.completada ? Icons.undo : Icons.done_all,
                  label: _tarea.completada
                      ? 'Reabrir tarea'
                      : 'Marcar como completada',
                  color: _tarea.completada ? kGreen : null,
                ),
                const SizedBox(height: 2),
                TextButton.icon(
                  onPressed: _confirmarEliminar,
                  icon: const Icon(Icons.delete_outline, size: 18, color: kRed),
                  label: const Text(
                    'Eliminar tarea',
                    style: TextStyle(
                      color: kRed,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Fila de la tarjeta de metadatos (fecha de entrega, recordatorio, estado).
class _MetaFila extends StatelessWidget {
  const _MetaFila({
    required this.icono,
    required this.colorIcono,
    required this.etiqueta,
    required this.valor,
    this.colorValor,
    this.badge,
  });

  final IconData icono;
  final Color colorIcono;
  final String etiqueta;
  final String valor;
  final Color? colorValor;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: kLine),
            ),
            child: Icon(icono, size: 17, color: colorIcono),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  etiqueta,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: kMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  valor,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: colorValor ?? kInk,
                  ),
                ),
              ],
            ),
          ),
          ?badge,
        ],
      ),
    );
  }
}

/// Etiqueta pequeña («Activo», «75 %») de la tarjeta de metadatos.
class _Badge extends StatelessWidget {
  const _Badge({
    required this.texto,
    required this.fondo,
    required this.colorTexto,
  });

  final String texto;
  final Color fondo;
  final Color colorTexto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: colorTexto,
        ),
      ),
    );
  }
}

/// Encabezado de sección («Descripción», «Subtareas») con texto opcional
/// a la derecha, p. ej. «3 de 4 completadas».
class _TituloSeccion extends StatelessWidget {
  const _TituloSeccion(this.titulo, {this.extra});

  final String titulo;
  final String? extra;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF334155),
          ),
        ),
        const Spacer(),
        if (extra != null)
          Text(
            extra!,
            style: const TextStyle(
              fontSize: 12,
              color: kMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}

/// Fila de una subtarea con su círculo de verificación.
class _FilaSubtarea extends StatelessWidget {
  const _FilaSubtarea({required this.subtarea, required this.onTap});

  final Subtask subtarea;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hecha = subtarea.hecha;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7.5),
        child: Row(
          children: [
            Icon(
              hecha ? Icons.check_circle : Icons.circle_outlined,
              size: 22,
              color: hecha ? kIndigo : const Color(0xFFCBD5E1),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Text(
                subtarea.titulo,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: hecha
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF334155),
                  decoration: hecha ? TextDecoration.lineThrough : null,
                  decorationColor: const Color(0xFF94A3B8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
