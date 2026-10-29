import 'package:flutter/material.dart';

import '../data/course_repository.dart';
import '../data/task_repository.dart';
import '../models/task.dart';
import '../theme.dart';
import '../utils/fechas.dart';
import '../widgets/estado_vista.dart';
import '../widgets/info_chip.dart';
import 'task_detail_screen.dart';

/// Pantalla 3 · Calendario.
///
/// Muestra un mes con las entregas que tienen fecha y la agenda del día
/// seleccionado. Se alimenta de las tareas reales del repositorio.
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    super.key,
    required this.repositorio,
    required this.cursosRepositorio,
  });

  final TaskRepository repositorio;
  final CourseRepository cursosRepositorio;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<Task> _tareas = <Task>[];
  bool _cargando = true;
  bool _hayError = false;
  late DateTime _mes;
  late DateTime _seleccionado;

  @override
  void initState() {
    super.initState();
    final hoy = soloDia(DateTime.now());
    _mes = DateTime(hoy.year, hoy.month);
    _seleccionado = hoy;
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
      _hayError = false;
    });
    try {
      final tareas = await widget.repositorio.obtenerTareas();
      if (!mounted) return;
      setState(() {
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

  List<Task> get _conFecha =>
      _tareas.where((tarea) => tarea.fechaEntrega != null).toList();

  List<Task> _delDia(DateTime dia) {
    final tareas = _conFecha
        .where((tarea) => mismoDia(tarea.fechaEntrega, dia))
        .toList();
    tareas.sort((a, b) => a.fechaEntrega!.compareTo(b.fechaEntrega!));
    return tareas;
  }

  int _cantidadEn(int dia) {
    final fecha = DateTime(_mes.year, _mes.month, dia);
    return _conFecha
        .where((tarea) => mismoDia(tarea.fechaEntrega, fecha))
        .length;
  }

  void _cambiarMes(int delta) {
    final nuevo = DateTime(_mes.year, _mes.month + delta);
    setState(() {
      _mes = nuevo;
      _seleccionado = DateTime(nuevo.year, nuevo.month, 1);
    });
  }

  Future<void> _abrirDetalle(Task tarea) async {
    final cursos = await widget.cursosRepositorio.obtenerCursos();
    if (!mounted) return;
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => TaskDetailScreen(
          tarea: tarea,
          repositorio: widget.repositorio,
          cursos: cursos,
        ),
      ),
    );
    if (mounted) await _cargar();
  }

  Widget _contenido() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_hayError) {
      return EstadoVista(
        icono: Icons.error_outline,
        mensaje:
            'No pudimos cargar el calendario.\n'
            'Inténtalo de nuevo.',
        etiquetaBoton: 'Reintentar',
        onPressed: _cargar,
      );
    }

    final tareasDelDia = _delDia(_seleccionado);
    final sinFecha = _tareas.length - _conFecha.length;
    return RefreshIndicator(
      onRefresh: _cargar,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => _cambiarMes(-1),
                tooltip: 'Mes anterior',
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  formatearMes(_mes),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: kInk,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _cambiarMes(1),
                tooltip: 'Mes siguiente',
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                final hoy = soloDia(DateTime.now());
                setState(() {
                  _mes = DateTime(hoy.year, hoy.month);
                  _seleccionado = hoy;
                });
              },
              icon: const Icon(Icons.today, size: 16),
              label: const Text('Hoy'),
            ),
          ),
          Row(
            children: [
              for (final dia in const [
                'Lun',
                'Mar',
                'Mié',
                'Jue',
                'Vie',
                'Sáb',
                'Dom',
              ])
                Expanded(
                  child: Text(
                    dia,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: kMuted,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          _CuadriculaMes(
            mes: _mes,
            seleccionado: _seleccionado,
            hoy: soloDia(DateTime.now()),
            cantidadEn: _cantidadEn,
            onSeleccionar: (dia) => setState(() => _seleccionado = dia),
          ),
          const SizedBox(height: 18),
          Text(
            formatearFecha(_seleccionado),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: kInk,
            ),
          ),
          const SizedBox(height: 8),
          if (tareasDelDia.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Text(
                _conFecha.isEmpty
                    ? 'Todavía no hay entregas con fecha.'
                    : 'Sin entregas para este día.',
                style: const TextStyle(color: kMuted, fontSize: 13.5),
              ),
            ),
          for (final tarea in tareasDelDia) ...[
            _TarjetaEntrega(tarea: tarea, onTap: () => _abrirDetalle(tarea)),
            const SizedBox(height: 8),
          ],
          if (sinFecha > 0)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                sinFecha == 1
                    ? '1 tarea sin fecha no aparece en el calendario.'
                    : '$sinFecha tareas sin fecha no aparecen en el calendario.',
                style: const TextStyle(fontSize: 12, color: kMuted),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendario')),
      body: _contenido(),
    );
  }
}

class _CuadriculaMes extends StatelessWidget {
  const _CuadriculaMes({
    required this.mes,
    required this.seleccionado,
    required this.hoy,
    required this.cantidadEn,
    required this.onSeleccionar,
  });

  final DateTime mes;
  final DateTime seleccionado;
  final DateTime hoy;
  final int Function(int dia) cantidadEn;
  final ValueChanged<DateTime> onSeleccionar;

  @override
  Widget build(BuildContext context) {
    final primerDia = DateTime(mes.year, mes.month, 1);
    final desplazamiento = primerDia.weekday - 1; // lunes = 0
    final totalDias = diasEnMes(mes.year, mes.month);
    final celdas = desplazamiento + totalDias;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: celdas,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
        childAspectRatio: 1,
      ),
      itemBuilder: (contexto, indice) {
        if (indice < desplazamiento) return const SizedBox.shrink();
        final dia = indice - desplazamiento + 1;
        final fecha = DateTime(mes.year, mes.month, dia);
        final esSeleccionado = mismoDia(fecha, seleccionado);
        final esHoy = mismoDia(fecha, hoy);
        final cantidad = cantidadEn(dia);
        return InkWell(
          onTap: () => onSeleccionar(fecha),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              color: esSeleccionado
                  ? kIndigo
                  : esHoy
                  ? kIndigoSoft
                  : null,
              borderRadius: BorderRadius.circular(10),
              border: esHoy && !esSeleccionado
                  ? Border.all(color: kIndigo, width: 1.2)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$dia',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: esSeleccionado
                        ? Colors.white
                        : esHoy
                        ? kIndigoDark
                        : kInk,
                  ),
                ),
                const SizedBox(height: 2),
                if (cantidad > 0)
                  Container(
                    width: cantidad > 3 ? 8 : 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: esSeleccionado ? Colors.white : kIndigo,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TarjetaEntrega extends StatelessWidget {
  const _TarjetaEntrega({required this.tarea, required this.onTap});

  final Task tarea;
  final VoidCallback onTap;

  Color get _colorPrioridad => switch (tarea.prioridad) {
    Prioridad.alta => kRed,
    Prioridad.baja => kGreen,
    Prioridad.media => kAmber,
  };

  @override
  Widget build(BuildContext context) {
    final fecha = tarea.fechaEntrega!;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: kLine),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 38,
                decoration: BoxDecoration(
                  color: tarea.curso.color,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tarea.titulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: tarea.completada
                            ? const Color(0xFF94A3B8)
                            : kInk,
                        decoration: tarea.completada
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${formatearHora(fecha)} · ${tarea.curso.nombre}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11.5, color: kMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              InfoChip(texto: tarea.tipo.etiqueta, color: _colorPrioridad),
            ],
          ),
        ),
      ),
    );
  }
}
