import 'package:flutter/material.dart';

import '../models/task.dart';
import '../theme.dart';
import '../widgets/info_chip.dart';
import '../widgets/primary_button.dart';

/// 4A · Detalle de tarea.
/// Se abre al tocar una tarea en la lista de pendientes y concentra toda su
/// información y acciones: completar, editar, eliminar y gestionar subtareas.
class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key, required this.tarea});

  final Task tarea;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  Task get tarea => widget.tarea;

  Color get _colorPrioridad => switch (tarea.prioridad) {
    'Alta' => kRed,
    'Baja' => kGreen,
    _ => kAmber,
  };

  void _alternarCompletada() {
    setState(tarea.alternarCompletada);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            tarea.completada
                ? 'Tarea marcada como completada'
                : 'Tarea reabierta',
          ),
        ),
      );
  }

  Future<void> _confirmarEliminar() async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: const Text('¿Eliminar tarea?'),
        content: const Text(
          'La tarea y sus subtareas se quitarán de la lista de pendientes.',
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
    Navigator.of(context).pop(true);
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
    setState(() => tarea.subtareas.add(Subtask(texto)));
  }

  void _avisoEditar() {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'La edición se conectará con el formulario de tareas '
            '(pantalla 2 del equipo).',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de tarea'),
        actions: [
          IconButton(
            onPressed: _avisoEditar,
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
                texto: tarea.curso.nombre,
                color: tarea.curso.color,
                mostrarPunto: true,
              ),
              InfoChip(
                texto: 'Prioridad ${tarea.prioridad.toLowerCase()}',
                color: _colorPrioridad,
                mostrarPunto: true,
              ),
              InfoChip(texto: tarea.tipo, color: kSky),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            tarea.titulo,
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
                  valor: tarea.fechaEntrega,
                ),
                const Divider(height: 1, color: Color(0xFFEEF2F7)),
                _MetaFila(
                  icono: Icons.notifications_outlined,
                  colorIcono: kAmber,
                  etiqueta: 'Recordatorio',
                  valor: tarea.recordatorio,
                  badge: tarea.recordatorioActivo
                      ? const _Badge(
                          texto: 'Activo',
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
                  valor: tarea.estado,
                  colorValor: tarea.completada ? kGreenDark : null,
                  badge: _Badge(
                    texto: '${(tarea.progreso * 100).round()} %',
                    fondo: tarea.completada ? kGreenSoft : kAmberSoft,
                    colorTexto: tarea.completada ? kGreenDark : kAmberDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 17),
          const _TituloSeccion('Descripción'),
          const SizedBox(height: 8),
          Text(
            tarea.descripcion.isEmpty ? 'Sin descripción.' : tarea.descripcion,
            style: TextStyle(
              fontSize: 13.3,
              color: tarea.descripcion.isEmpty
                  ? const Color(0xFF94A3B8)
                  : const Color(0xFF475569),
              height: 1.52,
            ),
          ),
          const SizedBox(height: 17),
          _TituloSeccion(
            'Subtareas',
            extra:
                '${tarea.completadas} de ${tarea.subtareas.length} completadas',
          ),
          const SizedBox(height: 9),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: tarea.progreso,
              minHeight: 6,
              backgroundColor: const Color(0xFFE2E8F0),
              color: kIndigo,
            ),
          ),
          const SizedBox(height: 6),
          for (final subtarea in tarea.subtareas)
            _FilaSubtarea(
              subtarea: subtarea,
              onTap: () => setState(() => subtarea.hecha = !subtarea.hecha),
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
                  icon: tarea.completada ? Icons.undo : Icons.done_all,
                  label: tarea.completada
                      ? 'Reabrir tarea'
                      : 'Marcar como completada',
                  color: tarea.completada ? kGreen : null,
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
