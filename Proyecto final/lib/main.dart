import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/course_repository.dart';
import 'data/hive_course_repository.dart';
import 'data/hive_task_repository.dart';
import 'data/local_store.dart';
import 'data/seed_data.dart';
import 'data/task_repository.dart';
import 'screens/home_shell.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final store = await LocalStore.abrir();
    await sembrarDatosIniciales(store);
    runApp(
      TaskUApp(
        courseRepository: HiveCourseRepository(store),
        taskRepository: HiveTaskRepository(store),
      ),
    );
  } catch (error, stackTrace) {
    debugPrint('No se pudo abrir el almacenamiento local: $error');
    debugPrintStack(stackTrace: stackTrace);
    runApp(const _ArranqueFallido());
  }
}

/// TaskU · compromisos académicos bajo control (PDM 2026 · Equipo 05).
class TaskUApp extends StatelessWidget {
  const TaskUApp({
    super.key,
    required this.courseRepository,
    required this.taskRepository,
  });

  final CourseRepository courseRepository;
  final TaskRepository taskRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskU',
      debugShowCheckedModeBanner: false,
      theme: buildTaskuTheme(),
      locale: const Locale('es'),
      supportedLocales: const [Locale('es')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: HomeShell(
        courseRepository: courseRepository,
        taskRepository: taskRepository,
      ),
    );
  }
}

/// Pantalla mínima si la base local no se puede abrir al arrancar.
class _ArranqueFallido extends StatelessWidget {
  const _ArranqueFallido();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildTaskuTheme(),
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.storage_outlined,
                  size: 48,
                  color: Color(0xFFCBD5E1),
                ),
                const SizedBox(height: 14),
                const Text(
                  'No pudimos abrir tus datos locales.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: kInk,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Cierra y vuelve a abrir TaskU. Si el problema continúa, '
                  'revisa el espacio libre del dispositivo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: kMuted, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
