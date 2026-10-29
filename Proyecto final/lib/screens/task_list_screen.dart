import 'package:flutter/material.dart';

import '../data/course_repository.dart';
import '../data/task_repository.dart';
import '../models/course.dart';
import '../models/task.dart';
import '../theme.dart';
import '../utils/fechas.dart';
import '../widgets/estado_vista.dart';
import '../widgets/info_chip.dart';
import 'task_detail_screen.dart';
import 'task_form_screen.dart';

/// Pantalla 1 · Pendientes.
///
/// Es la pantalla de entrada de TaskU: muestra las tareas reales guardadas en
/// el dispositivo, permite completarlas, abrir su detalle y registrar nuevas.
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({
    super.key,
    required this.repositorio,
    required this.cursosRepositorio,
  });

  final TaskRepository repositorio;
  final CourseRepository cursosRepositorio;

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

enum _FiltroTareas { pendientes, todas, completadas }

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> _tareas = <Task>[];
  List<Course> _cursos = <Course>[];
  _FiltroTareas _filtro = _FiltroTareas.pendientes;
  bool _cargando = true;
  bool _hayError = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
      _hayError = false;
    });
    try {
      final cursosFuturo = widget.cursosRepositorio.obtenerCursos();
      final tareasFuturo = widget.repositorio.obtenerTareas();
      final cursos = await cursosFuturo;
      final tareas = await tareasFuturo;
      if (!mounted) return;
      setState(() {
        _cursos = cursos;
        _tareas = tareas;
        _cargando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _hayError = true;
        _cargando = false;
      });
    }
  }

  List<Task> get _visibles {
    final filtradas = switch (_filtro) {
      _FiltroTareas.pendientes => _tareas.where((t) => !t.completada),
      _FiltroTareas.completadas => _tareas.where((t) => t.completada),
      _FiltroTareas.todas => _tareas,
    };
    final lista = filtradas.toList();
    lista.sort(_compararTareas);
    return lista;
  }

  int get _pendientes => _tareas.where((t) => !t.completada).length;

  int get _completadas => _tareas.length - _pendientes;

  /// Tareas cuyo recordatorio ya llegó pero cuya entrega sigue pendiente.
  ///
  /// Es el aviso dentro de la app. Las notificaciones del sistema quedan
  /// pendientes de una versión futura.
  List<Task> get _recordatoriosPendientes {
    final ahora = DateTime.now();
    final lista = _tareas.where((tarea) {
      final programado = tarea.recordatorio.programadoPara(tarea.fechaEntrega);
      return !tarea.completada &&
          programado != null &&
          !programado.isAfter(ahora) &&
          tarea.fechaEntrega!.isAfter(ahora);
    }).toList();
    lista.sort(_compararTareas);
    return lista;
  }

  /// Primero las que tienen fecha (más próxima), luego por prioridad.
  int _compararTareas(Task a, Task b) {
    final fechaA = a.fechaEntrega;
    final fechaB = b.fechaEntrega;
    if (fechaA != null && fechaB != null) {
      final porFecha = fechaA.compareTo(fechaB);
      if (porFecha != 0) return porFecha;
    } else if (fechaA != null) {
      return -1;
    } else if (fechaB != null) {
      return 1;
    }
    final porPrioridad = a.prioridad.index.compareTo(b.prioridad.index);
    if (porPrioridad != 0) return porPrioridad;
    return a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase());
  }

  void _avisar(String mensaje) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<void> _nuevaTarea() async {
    if (_cursos.isEmpty) {
      await showDialog<void>(
        context: context,
        builder: (contexto) => AlertDialog(
          title: const Text('Primero crea un curso'),
          content: const Text(
            'Cada tarea se asocia a un curso. Agrega uno desde la pestaña '
            '«Cursos» y vuelve a intentarlo.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(contexto),
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
      return;
    }

    final tarea = await Navigator.of(context).push<Task>(
      MaterialPageRoute(builder: (_) => TaskFormScreen(cursos: _cursos)),
    );
    if (!mounted || tarea == null) return;
    await _guardar(tarea, mensaje: 'Tarea registrada');
  }

  Future<void> _guardar(Task tarea, {String? mensaje}) async {
    try {
      await widget.repositorio.guardarTarea(tarea);
      await _cargar();
      if (mounted && mensaje != null) _avisar(mensaje);
    } catch (_) {
      if (mounted) _avisar('No se pudo guardar la tarea');
    }
  }

  Future<void> _abrirDetalle(Task tarea) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => TaskDetailScreen(
          tarea: tarea,
          repositorio: widget.repositorio,
          cursos: _cursos,
        ),
      ),
    );
    if (mounted) await _cargar();
  }

  Future<void> _alternar(Task tarea) async {
    final nueva = tarea.alternarCompletada();
    await _guardar(
      nueva,
      mensaje: nueva.completada ? 'Tarea completada' : 'Tarea reabierta',
    );
  }

  Widget _contenido() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_hayError) {
      return EstadoVista(
        icono: Icons.error_outline,
        mensaje:
            'No pudimos cargar tus tareas.\n'
            'Inténtalo de nuevo.',
        etiquetaBoton: 'Reintentar',
        onPressed: _cargar,
      );
    }

    final visibles = _visibles;
    final recordatorios = _recordatoriosPendientes;
    return RefreshIndicator(
      onRefresh: _cargar,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
        children: [
          _ResumenPendientes(
            pendientes: _pendientes,
            completadas: _completadas,
          ),
          if (recordatorios.isNotEmpty) ...[
            const SizedBox(height: 12),
            _Recordatorios(
              tareas: recordatorios.take(2).toList(),
              total: recordatorios.length,
              onTap: _abrirDetalle,
            ),
          ],
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final filtro in _FiltroTareas.values)
                _ChipFiltro(
                  texto: switch (filtro) {
                    _FiltroTareas.pendientes => 'Pendientes',
                    _FiltroTareas.completadas => 'Completadas',
                    _FiltroTareas.todas => 'Todas',
                  },
                  activo: _filtro == filtro,
                  onTap: () => setState(() => _filtro = filtro),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (visibles.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 42),
              child: Column(
                children: [
                  Icon(
                    _filtro == _FiltroTareas.completadas
                        ? Icons.task_alt
                        : Icons.inbox_outlined,
                    size: 44,
                    color: const Color(0xFFCBD5E1),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _filtro == _FiltroTareas.pendientes
                        ? 'No tienes tareas pendientes.'
                        : _filtro == _FiltroTareas.completadas
                        ? 'Todavía no has completado tareas.'
                        : 'Aún no hay tareas.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: kMuted, fontSize: 13.5),
                  ),
                ],
              ),
            ),
          for (final tarea in visibles) ...[
            _TarjetaTarea(
              tarea: tarea,
              onTap: () => _abrirDetalle(tarea),
              onAlternar: () => _alternar(tarea),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      floatingActionButton: FloatingActionButton(
        onPressed: _nuevaTarea,
        tooltip: 'Nueva tarea',
        backgroundColor: kIndigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: _contenido(),
    );
  }
}

/// Encabezado con el saludo y el conteo real de tareas.
class _ResumenPendientes extends StatelessWidget {
  const _ResumenPendientes({
    required this.pendientes,
    required this.completadas,
  });

  final int pendientes;
  final int completadas;

  @override
  Widget build(BuildContext context) {
    final total = pendientes + completadas;
    final avance = total == 0 ? 0.0 : completadas / total;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kIndigo,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hola, Diego',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  pendientes == 1
                      ? 'Tienes 1 tarea pendiente'
                      : 'Tienes $pendientes tareas pendientes',
                  style: const TextStyle(
                    color: Color(0xFFE0E7FF),
                    fontSize: 12.8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: avance,
                    minHeight: 6,
                    backgroundColor: Colors.white24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$completadas de $total completadas',
                  style: const TextStyle(
                    color: Color(0xFFE0E7FF),
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          SizedBox(
            width: 54,
            height: 54,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: avance,
                  strokeWidth: 5,
                  backgroundColor: Colors.white24,
                  color: Colors.white,
                ),
                Center(
                  child: Text(
                    '${(avance * 100).round()} %',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Avisos que ya vencieron y siguen con la tarea pendiente.
class _Recordatorios extends StatelessWidget {
  const _Recordatorios({
    required this.tareas,
    required this.total,
    required this.onTap,
  });

  final List<Task> tareas;
  final int total;
  final ValueChanged<Task> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 11, 13, 9),
      decoration: BoxDecoration(
        color: kAmberSoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.notifications_active_outlined,
                size: 17,
                color: kAmberDark,
              ),
              SizedBox(width: 8),
              Text(
                'Recordatorios',
                style: TextStyle(
                  fontSize: 12.8,
                  fontWeight: FontWeight.w800,
                  color: kAmberDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          for (final tarea in tareas)
            InkWell(
              onTap: () => onTap(tarea),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: tarea.curso.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tarea.titulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Vence ${formatearDiaMes(tarea.fechaEntrega!)}',
                      style: const TextStyle(fontSize: 11.5, color: kAmberDark),
                    ),
                  ],
                ),
              ),
            ),
          if (total > tareas.length)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'y ${total - tareas.length} más',
                style: const TextStyle(fontSize: 11.5, color: kAmberDark),
              ),
            ),
          const SizedBox(height: 3),
          const Text(
            'Avisos dentro de la app · las notificaciones del sistema llegarán '
            'en una próxima versión.',
            style: TextStyle(fontSize: 10.8, color: Color(0xFFB45309)),
          ),
        ],
      ),
    );
  }
}

/// Chip de filtro de la lista de tareas.
class _ChipFiltro extends StatelessWidget {
  const _ChipFiltro({
    required this.texto,
    required this.activo,
    required this.onTap,
  });

  final String texto;
  final bool activo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
        decoration: BoxDecoration(
          color: activo ? kInk : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: activo ? kInk : kLine, width: 1.5),
        ),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: activo ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }
}

/// Tarjeta de una tarea en la lista de pendientes.
class _TarjetaTarea extends StatelessWidget {
  const _TarjetaTarea({
    required this.tarea,
    required this.onTap,
    required this.onAlternar,
  });

  final Task tarea;
  final VoidCallback onTap;
  final VoidCallback onAlternar;

  Color get _colorPrioridad => switch (tarea.prioridad) {
    Prioridad.alta => kRed,
    Prioridad.baja => kGreen,
    Prioridad.media => kAmber,
  };

  @override
  Widget build(BuildContext context) {
    final completada = tarea.completada;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: kLine),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InfoChip(
                    texto: tarea.curso.nombre,
                    color: tarea.curso.color,
                    mostrarPunto: true,
                  ),
                  const SizedBox(width: 7),
                  InfoChip(
                    texto: tarea.prioridad.etiqueta,
                    color: _colorPrioridad,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: onAlternar,
                    tooltip: completada
                        ? 'Reabrir tarea'
                        : 'Marcar como completada',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 34,
                      minHeight: 34,
                    ),
                    icon: Icon(
                      completada ? Icons.check_circle : Icons.circle_outlined,
                      size: 24,
                      color: completada ? kGreen : const Color(0xFFCBD5E1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Text(
                tarea.titulo,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: completada ? const Color(0xFF94A3B8) : kInk,
                  decoration: completada ? TextDecoration.lineThrough : null,
                  decorationColor: const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 14,
                    color: tarea.vencida ? kRed : const Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      formatearFechaHora(tarea.fechaEntrega),
                      style: TextStyle(
                        fontSize: 12.5,
                        color: tarea.vencida ? kRed : kMuted,
                        fontWeight: tarea.vencida
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (tarea.subtareas.isNotEmpty)
                    Text(
                      '${tarea.completadas}/${tarea.subtareas.length} subtareas',
                      style: const TextStyle(fontSize: 11.5, color: kMuted),
                    ),
                ],
              ),
              if (tarea.subtareas.isNotEmpty) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: tarea.progreso,
                    minHeight: 5,
                    backgroundColor: const Color(0xFFE2E8F0),
                    color: tarea.curso.color,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
