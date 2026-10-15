import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../models/course.dart';
import '../theme.dart';
import '../widgets/info_chip.dart';
import 'course_form_screen.dart';

/// 4B · Gestión de cursos (listado).
/// Cada curso agrupa sus tareas y exámenes; desde aquí se registran,
/// editan y eliminan, y se ve el resumen del semestre.
class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  /// Lista compartida de demostración (en la versión final vendrá de SQLite/Hive).
  final List<Course> _cursos = cursosDemo;
  String _filtro = 'Todos';

  List<Course> get _visibles => switch (_filtro) {
    'Con pendientes' => _cursos.where((c) => c.pendientes > 0).toList(),
    '2026-2' => _cursos.where((c) => c.periodo == '2026-2').toList(),
    _ => List.of(_cursos),
  };

  int get _totalPendientes => _cursos.fold(0, (suma, c) => suma + c.pendientes);

  /// Avance general del semestre (tareas hechas / tareas totales).
  double get _avance {
    final total = _cursos.fold(0, (suma, c) => suma + c.totalTareas);
    if (total == 0) return 0;
    return (total - _totalPendientes) / total;
  }

  Future<void> _abrirFormulario({Course? curso}) async {
    final resultado = await Navigator.of(context).push<Course>(
      MaterialPageRoute(builder: (_) => CourseFormScreen(curso: curso)),
    );
    if (!mounted || resultado == null) return;
    setState(() {
      final indice = curso == null ? -1 : _cursos.indexOf(curso);
      if (indice == -1) {
        _cursos.add(resultado);
      } else {
        _cursos[indice] = resultado;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(curso == null ? 'Curso agregado' : 'Curso actualizado'),
      ),
    );
  }

  Future<void> _confirmarEliminar(Course curso) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: Text('¿Eliminar «${curso.nombre}»?'),
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
    setState(() => _cursos.remove(curso));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Curso eliminado')));
  }

  void _ordenarPorPendientes() {
    setState(
      () => _cursos.sort((a, b) => b.pendientes.compareTo(a.pendientes)),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cursos ordenados por pendientes')),
    );
  }

  void _avisoBuscar() {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        const SnackBar(content: Text('Búsqueda de cursos: por implementar')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final visibles = _visibles;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis cursos'),
        actions: [
          IconButton(
            tooltip: 'Buscar cursos',
            onPressed: _avisoBuscar,
            icon: const Icon(Icons.search, size: 22),
          ),
          PopupMenuButton<String>(
            tooltip: 'Opciones',
            icon: const Icon(Icons.more_vert, size: 22),
            onSelected: (opcion) {
              if (opcion == 'ordenar') _ordenarPorPendientes();
            },
            itemBuilder: (contexto) => [
              const PopupMenuItem(
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
      body: ListView(
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
              ])
                _ChipFiltro(
                  texto: etiqueta,
                  activo: _filtro == etiqueta,
                  onTap: () => setState(() => _filtro = etiqueta),
                ),
            ],
          ),
          const SizedBox(height: 13),
          _ResumenSemestre(
            cursos: _cursos.length,
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
          for (final curso in visibles) ...[
            _TarjetaCurso(
              curso: curso,
              onEditar: () => _abrirFormulario(curso: curso),
              onEliminar: () => _confirmarEliminar(curso),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
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
    required this.curso,
    required this.onEditar,
    required this.onEliminar,
  });

  final Course curso;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  @override
  Widget build(BuildContext context) {
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
