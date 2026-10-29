import 'package:flutter/material.dart';

import '../data/course_repository.dart';
import '../data/task_repository.dart';
import '../models/course.dart';
import '../models/course_filter.dart';
import '../models/course_summary.dart';
import '../models/task.dart';
import '../theme.dart';
import '../widgets/estado_vista.dart';
import '../widgets/info_chip.dart';
import 'course_form_screen.dart';

/// 4B · Gestión de cursos (listado).
/// Cada curso agrupa sus tareas y exámenes; desde aquí se registran, editan y
/// eliminan, y se ve el resumen del semestre. Los pendientes y el avance se
/// calculan desde el repositorio de tareas, no son valores escritos a mano.
class CourseListScreen extends StatefulWidget {
  const CourseListScreen({
    super.key,
    required this.repositorio,
    required this.tareasRepositorio,
  });

  final CourseRepository repositorio;
  final TaskRepository tareasRepositorio;

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final TextEditingController _busqueda = TextEditingController();
  CourseFilter _filtro = const CourseFilter();
  List<CourseSummary> _resumenes = <CourseSummary>[];
  bool _cargando = true;
  bool _hayError = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
      _hayError = false;
    });
    try {
      final cursos = await widget.repositorio.obtenerCursos();
      final tareas = await widget.tareasRepositorio.obtenerTareas();

      final tareasPorCurso = <String, List<Task>>{};
      for (final tarea in tareas) {
        tareasPorCurso.putIfAbsent(tarea.cursoId, () => <Task>[]).add(tarea);
      }

      final resumenes = [
        for (final curso in cursos)
          CourseSummary(
            curso: curso,
            totalTareas: tareasPorCurso[curso.id]?.length ?? 0,
            pendientes:
                tareasPorCurso[curso.id]
                    ?.where((tarea) => !tarea.completada)
                    .length ??
                0,
          ),
      ];

      if (!mounted) return;
      setState(() {
        _resumenes = resumenes;
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

  Widget _contenido() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_hayError) {
      return EstadoVista(
        icono: Icons.error_outline,
        mensaje:
            'No pudimos cargar tus cursos.\n'
            'Revisa tu conexión e inténtalo de nuevo.',
        etiquetaBoton: 'Reintentar',
        onPressed: _cargar,
      );
    }
    if (_resumenes.isEmpty) {
      return EstadoVista(
        icono: Icons.school_outlined,
        mensaje: 'Aún no hay cursos.',
        etiquetaBoton: '+ Agregar curso',
        onPressed: () => _abrirFormulario(),
      );
    }
    final visibles = _visibles;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final etiqueta in const ['Todos', '2026-2', 'Con pendientes'])
              _ChipFiltro(
                texto: etiqueta,
                activo: _etiquetaFiltro == etiqueta,
                onTap: () => _cambiarFiltro(
                  _filtro.copyWith(
                    periodo: etiqueta == '2026-2' ? '2026-2' : 'Todos',
                    soloPendientes: etiqueta == 'Con pendientes',
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _busqueda,
          onChanged: (texto) => _cambiarFiltro(_filtro.copyWith(texto: texto)),
          decoration: InputDecoration(
            hintText: 'Buscar curso o docente',
            prefixIcon: const Icon(Icons.search, size: 20),
            suffixIcon: _filtro.texto.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Limpiar búsqueda',
                    onPressed: () {
                      _busqueda.clear();
                      _cambiarFiltro(_filtro.copyWith(texto: ''));
                    },
                    icon: const Icon(Icons.close, size: 18),
                  ),
          ),
        ),
        const SizedBox(height: 13),
        _ResumenSemestre(
          cursos: _resumenes.length,
          pendientes: _totalPendientes,
          avance: _avance,
        ),
        const SizedBox(height: 12),
        if (visibles.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Text(
              'No hay cursos con este filtro.',
              textAlign: TextAlign.center,
              style: TextStyle(color: kMuted, fontSize: 13),
            ),
          ),
        for (final resumen in visibles) ...[
          Dismissible(
            key: ValueKey(resumen.curso.id),
            direction: DismissDirection.endToStart,
            confirmDismiss: (_) => _eliminarConGesto(resumen),
            onDismissed: (_) {
              final indice = _resumenes.indexWhere(
                (actual) => actual.curso.id == resumen.curso.id,
              );
              setState(
                () => _resumenes.removeWhere(
                  (actual) => actual.curso.id == resumen.curso.id,
                ),
              );
              _mostrarDeshacer(resumen, indice);
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: kRedSoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.delete_outline, color: kRed),
            ),
            child: _TarjetaCurso(
              resumen: resumen,
              onEditar: () => _abrirFormulario(curso: resumen.curso),
              onEliminar: () => _confirmarEliminar(resumen),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  String get _etiquetaFiltro {
    if (_filtro.soloPendientes) return 'Con pendientes';
    if (_filtro.periodo == '2026-2') return '2026-2';
    return 'Todos';
  }

  List<CourseSummary> get _visibles =>
      _resumenes.where(_filtro.acepta).toList();

  void _cambiarFiltro(CourseFilter filtro) {
    if (filtro == _filtro) return;
    setState(() => _filtro = filtro);
  }

  int get _totalPendientes =>
      _resumenes.fold(0, (suma, resumen) => suma + resumen.pendientes);

  /// Avance general del semestre (tareas completadas / tareas totales).
  double get _avance {
    final total = _resumenes.fold(
      0,
      (suma, resumen) => suma + resumen.totalTareas,
    );
    if (total == 0) return 0;
    return (total - _totalPendientes) / total;
  }

  Future<void> _abrirFormulario({Course? curso}) async {
    final resultado = await Navigator.of(context).push<Course>(
      MaterialPageRoute(builder: (_) => CourseFormScreen(curso: curso)),
    );
    if (!mounted || resultado == null) return;
    try {
      await widget.repositorio.guardarCurso(resultado);
      await _cargar();
      if (!mounted) return;
      _avisar(curso == null ? 'Curso agregado' : 'Curso actualizado');
    } catch (_) {
      if (mounted) _avisar('No se pudo guardar el curso');
    }
  }

  void _avisar(String mensaje) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<void> _explicarCursoConTareas(CourseSummary resumen) {
    final cantidad = resumen.totalTareas;
    final texto = cantidad == 1
        ? 'Este curso tiene 1 tarea asociada.'
        : 'Este curso tiene $cantidad tareas asociadas.';
    return showDialog<void>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: const Text('No se puede eliminar'),
        content: Text(
          '$texto Elimina o reasigna esas tareas antes de borrar el curso.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contexto),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  Future<bool> _eliminarConGesto(CourseSummary resumen) async {
    if (resumen.totalTareas > 0) {
      await _explicarCursoConTareas(resumen);
      return false;
    }
    try {
      await widget.repositorio.eliminarCurso(resumen.curso.id);
      return true;
    } on CursoConTareasException {
      if (mounted) await _explicarCursoConTareas(resumen);
      return false;
    } catch (_) {
      if (mounted) _avisar('No se pudo eliminar el curso');
      return false;
    }
  }

  Future<void> _confirmarEliminar(CourseSummary resumen) async {
    if (resumen.totalTareas > 0) {
      await _explicarCursoConTareas(resumen);
      return;
    }
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: Text('¿Eliminar «${resumen.curso.nombre}»?'),
        content: const Text('El curso y su horario se quitarán de la lista.'),
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
    final indice = _resumenes.indexWhere(
      (actual) => actual.curso.id == resumen.curso.id,
    );
    try {
      await widget.repositorio.eliminarCurso(resumen.curso.id);
      if (!mounted) return;
      setState(
        () => _resumenes.removeWhere(
          (actual) => actual.curso.id == resumen.curso.id,
        ),
      );
      _mostrarDeshacer(resumen, indice);
    } on CursoConTareasException {
      if (mounted) await _explicarCursoConTareas(resumen);
    } catch (_) {
      if (mounted) _avisar('No se pudo eliminar el curso');
    }
  }

  void _mostrarDeshacer(CourseSummary resumen, int indice) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text('Curso «${resumen.curso.nombre}» eliminado'),
          action: SnackBarAction(
            label: 'Deshacer',
            onPressed: () => _deshacer(resumen, indice),
          ),
        ),
      );
  }

  Future<void> _deshacer(CourseSummary resumen, int indice) async {
    try {
      await widget.repositorio.restaurarCurso(resumen.curso, indice: indice);
      if (!mounted) return;
      setState(
        () => _resumenes.insert(indice.clamp(0, _resumenes.length), resumen),
      );
    } catch (_) {
      if (mounted) _avisar('No se pudo restaurar el curso');
    }
  }

  void _ordenarPorPendientes() {
    setState(
      () => _resumenes.sort((a, b) => b.pendientes.compareTo(a.pendientes)),
    );
    _avisar('Cursos ordenados por pendientes');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis cursos'),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Opciones',
            icon: const Icon(Icons.more_vert, size: 22),
            onSelected: (opcion) {
              if (opcion == 'ordenar') _ordenarPorPendientes();
            },
            itemBuilder: (contexto) => const [
              PopupMenuItem(
                value: 'ordenar',
                child: Row(
                  children: [
                    Icon(Icons.sort, size: 18, color: kMuted),
                    SizedBox(width: 10),
                    Text('Ordenar por pendientes'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _contenido(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        tooltip: 'Agregar curso',
        backgroundColor: kIndigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add, size: 26),
      ),
    );
  }
}

/// Chip de filtro del listado («Todos», «2026-2», «Con pendientes»).
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

/// Tarjeta con el resumen del semestre: cursos, pendientes y avance.
class _ResumenSemestre extends StatelessWidget {
  const _ResumenSemestre({
    required this.cursos,
    required this.pendientes,
    required this.avance,
  });

  final int cursos;
  final int pendientes;
  final double avance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kLine),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kInk.withValues(alpha: .04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          _Estadistica(valor: '$cursos', etiqueta: 'cursos'),
          Container(
            width: 1,
            height: 34,
            color: kLine,
            margin: const EdgeInsets.symmetric(horizontal: 14),
          ),
          _Estadistica(valor: '$pendientes', etiqueta: 'tareas pendientes'),
          const Spacer(),
          SizedBox(
            width: 48,
            height: 48,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: avance,
                  strokeWidth: 5,
                  backgroundColor: const Color(0xFFE2E8F0),
                  color: kIndigo,
                ),
                Center(
                  child: Text(
                    '${(avance * 100).round()} %',
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: kIndigoDark,
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

class _Estadistica extends StatelessWidget {
  const _Estadistica({required this.valor, required this.etiqueta});

  final String valor;
  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          valor,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: kInk,
            letterSpacing: -.4,
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
    );
  }
}

/// Tarjeta de un curso: color, docente, horario, pendientes y menú ⋮.
class _TarjetaCurso extends StatelessWidget {
  const _TarjetaCurso({
    required this.resumen,
    required this.onEditar,
    required this.onEliminar,
  });

  final CourseSummary resumen;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  @override
  Widget build(BuildContext context) {
    final curso = resumen.curso;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kLine),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: curso.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.school, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  curso.nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.8,
                    fontWeight: FontWeight.w700,
                    color: kInk,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  curso.docente,
                  style: const TextStyle(fontSize: 12, color: kMuted),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 13,
                      color: Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        curso.horario,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: kMuted),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InfoChip(
                texto: resumen.pendientes == 1
                    ? '1 pendiente'
                    : '${resumen.pendientes} pendientes',
                color: curso.color,
              ),
              PopupMenuButton<String>(
                tooltip: 'Opciones del curso',
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.more_vert,
                  size: 18,
                  color: Color(0xFF94A3B8),
                ),
                onSelected: (opcion) {
                  if (opcion == 'editar') {
                    onEditar();
                  } else if (opcion == 'eliminar') {
                    onEliminar();
                  }
                },
                itemBuilder: (contexto) => const [
                  PopupMenuItem(
                    value: 'editar',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 18, color: kMuted),
                        SizedBox(width: 10),
                        Text('Editar curso'),
                      ],
                    ),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'eliminar',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 18, color: kRed),
                        SizedBox(width: 10),
                        Text('Eliminar curso', style: TextStyle(color: kRed)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
