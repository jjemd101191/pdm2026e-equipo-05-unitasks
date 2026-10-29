import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/curso_dao.dart';
import '../data/cursos_provider.dart';
import '../models/course.dart';
import '../models/course_filter.dart';
import '../theme.dart';
import '../widgets/estado_vista.dart';
import '../widgets/info_chip.dart';
import 'course_form_screen.dart';

class CourseListScreen extends ConsumerStatefulWidget {
  const CourseListScreen({super.key});
  @override
  ConsumerState<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends ConsumerState<CourseListScreen> {
  CourseFilter _filtro = const CourseFilter();
  final _busqueda = TextEditingController();
  final Set<String> _ocupados = {};
  bool _archivados = false;
  bool _ordenados = false;

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  void _cambiarFiltro(CourseFilter filtro) => setState(() => _filtro = filtro);
  String get _etiquetaFiltro => _archivados
      ? 'Archivados'
      : _filtro.soloPendientes
      ? 'Con pendientes'
      : _filtro.periodo == '2026-2'
      ? '2026-2'
      : 'Todos';

  void _aviso(String texto) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> _abrirFormulario({Course? curso}) async {
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => CourseFormScreen(
          curso: curso,
          onGuardar: (resultado) async {
            await ref.read(cursoDaoProvider).guardarCurso(resultado);
            if (mounted) ref.invalidate(cursosProvider);
          },
        ),
      ),
    );
    if (mounted && guardado == true) {
      _aviso(curso == null ? 'Curso agregado' : 'Curso actualizado');
    }
  }

  Future<void> _confirmarEliminar(Course curso) async {
    if (!_ocupados.add(curso.id)) return;
    final dao = ref.read(cursoDaoProvider);
    try {
      final cantidad = await dao.tareasDe(curso.id);
      if (!mounted) return;
      if (cantidad > 0) {
        await _ofrecerArchivar(curso, cantidad);
        return;
      }
      final confirmado = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('¿Eliminar «${curso.nombre}»?'),
          content: const Text('El curso y su horario se quitarán de la lista.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Eliminar', style: TextStyle(color: kRed)),
            ),
          ],
        ),
      );
      if (!mounted || confirmado != true) return;
      await dao.eliminarCurso(curso.id);
      if (!mounted) return;
      ref.invalidate(cursosProvider);
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text('Curso «${curso.nombre}» eliminado'),
            action: SnackBarAction(
              label: 'Deshacer',
              onPressed: () => _deshacer(curso),
            ),
          ),
        );
    } on CursoEnUsoException catch (e) {
      if (mounted) await _ofrecerArchivar(curso, e.cantidad);
    } catch (_) {
      if (mounted) _aviso('No se pudo eliminar el curso. Inténtalo de nuevo.');
    } finally {
      _ocupados.remove(curso.id);
    }
  }

  Future<void> _ofrecerArchivar(Course curso, int cantidad) async {
    final archivar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Curso en uso'),
        content: Text(
          curso.archivado
              ? 'Tiene $cantidad tareas. Está archivado y conserva sus tareas.'
              : 'Tiene $cantidad tareas. Archívalo para dejar de verlo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          if (!curso.archivado)
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Archivar'),
            ),
        ],
      ),
    );
    if (!mounted || archivar != true) return;
    try {
      await ref.read(cursoDaoProvider).archivarCurso(curso.id);
      if (!mounted) return;
      ref.invalidate(cursosProvider);
      _aviso('Curso archivado. Sus tareas se conservan.');
    } catch (_) {
      if (mounted) _aviso('No se pudo archivar el curso. Inténtalo de nuevo.');
    }
  }

  Future<void> _deshacer(Course curso) async {
    try {
      await ref.read(cursoDaoProvider).restaurarCurso(curso);
      if (mounted) ref.invalidate(cursosProvider);
    } on CursoDuplicadoException {
      if (mounted) _aviso('Ya existe un curso con ese nombre en este periodo.');
    } catch (_) {
      if (mounted) _aviso('No se pudo restaurar el curso. Inténtalo de nuevo.');
    }
  }

  Widget _contenido(List<Course> cursos) {
    if (cursos.isEmpty) {
      return EstadoVista(
        icono: Icons.school_outlined,
        mensaje: 'Aún no hay cursos.',
        etiquetaBoton: '+ Agregar curso',
        onPressed: () => _abrirFormulario(),
      );
    }
    final activos = cursos.where((c) => !c.archivado).toList();
    final visibles = cursos
        .where((c) => c.archivado == _archivados && _filtro.acepta(c))
        .toList();
    if (_ordenados) {
      visibles.sort((a, b) => b.pendientes.compareTo(a.pendientes));
    }
    final pendientes = activos.fold(0, (n, c) => n + c.pendientes);
    final total = activos.fold(0, (n, c) => n + c.totalTareas);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final etiqueta in const [
              'Todos',
              '2026-2',
              'Con pendientes',
              'Archivados',
            ])
              _ChipFiltro(
                texto: etiqueta,
                activo: _etiquetaFiltro == etiqueta,
                onTap: () => setState(() {
                  _archivados = etiqueta == 'Archivados';
                  _filtro = _filtro.copyWith(
                    periodo: etiqueta == '2026-2' ? '2026-2' : 'Todos',
                    soloPendientes: etiqueta == 'Con pendientes',
                  );
                }),
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
          cursos: activos.length,
          pendientes: pendientes,
          avance: total == 0
              ? 0
              : ((total - pendientes) / total).clamp(0.0, 1.0),
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
        for (final curso in visibles) ...[
          Dismissible(
            key: ValueKey(curso.id),
            direction: DismissDirection.endToStart,
            confirmDismiss: (_) async {
              await _confirmarEliminar(curso);
              return false;
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
              curso: curso,
              onEditar: () => _abrirFormulario(curso: curso),
              onEliminar: () => _confirmarEliminar(curso),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cursos = ref.watch(cursosProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis cursos'),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Opciones',
            icon: const Icon(Icons.more_vert, size: 22),
            onSelected: (_) => setState(() => _ordenados = true),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'ordenar',
                child: Text('Ordenar por pendientes'),
              ),
            ],
          ),
        ],
      ),
      body: cursos.when(
        skipLoadingOnRefresh: false,
        data: _contenido,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => EstadoVista(
          icono: Icons.error_outline,
          mensaje: 'No pudimos cargar tus cursos.\nInténtalo de nuevo.',
          etiquetaBoton: 'Reintentar',
          onPressed: () => ref.invalidate(cursosProvider),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'agregar-curso',
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
          Expanded(
            child: _Estadistica(
              valor: '$pendientes',
              etiqueta: 'tareas pendientes',
            ),
          ),
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
    required this.curso,
    required this.onEditar,
    required this.onEliminar,
  });

  final Course curso;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Editar curso ${curso.nombre}',
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onEditar,
        child: Container(
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
                    texto: '${curso.pendientes} pendientes',
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
                    itemBuilder: (contexto) => [
                      const PopupMenuItem(
                        value: 'editar',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 18, color: kMuted),
                            SizedBox(width: 10),
                            Text('Editar curso'),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'eliminar',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, size: 18, color: kRed),
                            SizedBox(width: 10),
                            Text(
                              'Eliminar curso',
                              style: TextStyle(color: kRed),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
