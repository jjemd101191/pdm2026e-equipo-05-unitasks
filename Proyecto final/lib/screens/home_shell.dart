import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../theme.dart';
import '../widgets/info_chip.dart';
import 'course_list_screen.dart';
import 'task_detail_screen.dart';

/// Esqueleto de la app con las cuatro pestañas principales del mockup.
/// «Cursos» (4B) es la pantalla de este módulo; «Inicio» y «Calendario»
/// son marcadores de posición mientras el equipo desarrolla las suyas.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  // Se abre en «Cursos» para la demostración del módulo 4;
  // en la integración final lo normal es iniciar en «Inicio» (índice 0).
  int _indice = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indice,
        children: const [
          _InicioTab(),
          _PlaceholderTab(
            titulo: 'Calendario',
            icono: Icons.calendar_today_outlined,
            mensaje:
                'Calendario y cronograma de entregas.\n'
                'Pantalla 3 · a cargo del resto del equipo.',
          ),
          CourseListScreen(),
          _PlaceholderTab(
            titulo: 'Perfil',
            icono: Icons.person_outline,
            mensaje:
                'Perfil del estudiante y pase Premium.\n'
                'Por definir por el equipo.',
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (indice) => setState(() => _indice = indice),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Calendario',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Cursos',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

/// Pestaña «Inicio» de demostración: muestra una tarjeta de tarea de ejemplo
/// que abre el detalle (4A), igual que lo hará la lista de pendientes real.
class _InicioTab extends StatelessWidget {
  const _InicioTab();

  Future<void> _abrirDetalle(BuildContext context) async {
    final eliminada = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => TaskDetailScreen(tarea: tareaDemo)),
    );
    if (!context.mounted) return;
    if (eliminada == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarea eliminada (demostración)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kIndigoSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'La lista de pendientes completa es la pantalla 1 del equipo. '
              'Esta tarjeta de ejemplo abre el detalle de tarea (4A).',
              style: TextStyle(
                fontSize: 12.3,
                color: Color(0xFF3730A3),
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 14),
          _TarjetaTareaDemo(onTap: () => _abrirDetalle(context)),
        ],
      ),
    );
  }
}

/// Tarjeta de tarea de ejemplo de la pestaña «Inicio».
class _TarjetaTareaDemo extends StatelessWidget {
  const _TarjetaTareaDemo({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tarea = tareaDemo;
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
              InfoChip(
                texto: tarea.curso.nombre,
                color: tarea.curso.color,
                mostrarPunto: true,
              ),
              const SizedBox(height: 9),
              Text(
                tarea.titulo,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: kInk,
                ),
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  const Icon(
                    Icons.schedule,
                    size: 14,
                    color: Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    tarea.fechaEntrega,
                    style: const TextStyle(fontSize: 12.5, color: kMuted),
                  ),
                  const Spacer(),
                  const InfoChip(texto: 'Alta', color: kRed),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pantalla provisional para las pestañas que aún no desarrolla este módulo.
class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({
    required this.titulo,
    required this.icono,
    required this.mensaje,
  });

  final String titulo;
  final IconData icono;
  final String mensaje;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icono, size: 46, color: const Color(0xFFCBD5E1)),
              const SizedBox(height: 14),
              Text(
                mensaje,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: kMuted,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
