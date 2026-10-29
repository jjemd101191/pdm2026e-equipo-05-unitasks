import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart';
import 'screens/course_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mis Tareas',
        theme: buildMisTareasTheme(),
        locale: const Locale('es'),
        supportedLocales: const [Locale('es')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const Inicio(),
      ),
    );
  }
}

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kFondo,

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Título
            const Center(
              child: Text(
                'Mis Tareas',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kTexto,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Saludo
            const Text(
              '¡Hola, Demy! 👋',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: kTexto,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Tienes 3 tareas pendientes',
              style: TextStyle(fontSize: 17, color: kMuted),
            ),

            const SizedBox(height: 22),

            // Filtros
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  filtro('Todas', true),
                  filtro('Hoy', false),
                  filtro('Próximas', false),
                  filtro('Completadas', false),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Título de tareas
            const Text(
              'Próximas tareas',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kTexto,
              ),
            ),

            const SizedBox(height: 12),

            // Tareas
            tarea(
              titulo: 'Reporte de lectura',
              materia: 'Comunicación Oral',
              fecha: '20 mayo',
              prioridad: 'Alta',
              color: kMorado,
            ),

            tarea(
              titulo: 'Ejercicios de matemáticas',
              materia: 'Cálculo I',
              fecha: '21 mayo',
              prioridad: 'Media',
              color: Colors.blue,
            ),

            tarea(
              titulo: 'Investigación de campo',
              materia: 'Sociología',
              fecha: '22 mayo',
              prioridad: 'Media',
              color: Colors.green,
            ),

            const SizedBox(height: 18),

            // Tarjeta motivacional
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: kMoradoClaro,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Text('🌱', style: TextStyle(fontSize: 40)),

                  SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¡Tú puedes con todo! 💪',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: kTexto,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          'Organizarte hoy es tu mejor versión del mañana.',
                          style: TextStyle(fontSize: 13, color: kMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Barra inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (indice) {
          if (indice == 3) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const CourseListScreen()),
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kMorado,
        unselectedItemColor: kMuted,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Tareas'),

          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendario',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 36),
            label: 'Agregar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            label: 'Cursos',
          ),
        ],
      ),
    );
  }
}

// Filtros
Widget filtro(String texto, bool seleccionado) {
  return Container(
    margin: const EdgeInsets.only(right: 10),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
    decoration: BoxDecoration(
      color: seleccionado ? kMoradoClaro : Colors.grey[100],
      borderRadius: BorderRadius.circular(25),
    ),
    child: Text(
      texto,
      style: TextStyle(
        fontSize: 14,
        fontWeight: seleccionado ? FontWeight.bold : FontWeight.normal,
        color: seleccionado ? kMorado : kMuted,
      ),
    ),
  );
}

// Tarjeta de tarea
Widget tarea({
  required String titulo,
  required String materia,
  required String fecha,
  required String prioridad,
  required Color color,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: kBorde),
    ),

    child: Row(
      children: [
        Container(
          width: 5,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: kTexto,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                materia,
                style: const TextStyle(fontSize: 14, color: kMuted),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 15,
                    color: kMuted,
                  ),

                  const SizedBox(width: 6),

                  Text(
                    fecha,
                    style: const TextStyle(fontSize: 13, color: kMuted),
                  ),

                  const Spacer(),

                  Text(
                    prioridad,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
