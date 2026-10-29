import '../models/course.dart';
import '../models/task.dart';
import '../theme.dart';
import 'db/app_database.dart';
import 'drift_course_repository.dart';
import 'drift_task_repository.dart';

/// Datos de ejemplo que se cargan una sola vez, en la primera apertura.
///
/// El estudiante puede editarlos o eliminarlos como cualquier otro registro.
/// Como se cargan en `onCreate` de la base, no reaparecen si borra todo.
List<Course> get cursosSemilla => const [
  Course(
    id: 'dispositivos-moviles',
    nombre: 'Dispositivos Móviles',
    docente: 'Ing. Mario Castillo',
    color: kIndigo,
    dias: ['Lun', 'Mié'],
    horaInicio: '10:00',
    horaFin: '12:00',
  ),
  Course(
    id: 'base-de-datos',
    nombre: 'Base de Datos',
    docente: 'Ing. Laura Pérez',
    color: kSky,
    dias: ['Mar', 'Jue'],
    horaInicio: '8:00',
    horaFin: '10:00',
  ),
  Course(
    id: 'ingenieria-software',
    nombre: 'Ingeniería de Software',
    docente: 'Lic. Ana Gómez',
    color: kGreen,
    dias: ['Vie'],
    horaInicio: '14:00',
    horaFin: '16:00',
  ),
  Course(
    id: 'redes-computadoras',
    nombre: 'Redes de Computadoras',
    docente: 'Ing. Carlos Ruiz',
    color: kAmber,
    dias: ['Lun'],
    horaInicio: '16:00',
    horaFin: '18:00',
  ),
];

/// Tareas de ejemplo con fechas relativas al día de la primera apertura.
List<Task> tareasSemilla() {
  final hoy = DateTime.now();

  DateTime enDias(int dias, {int hora = 23, int minuto = 59}) {
    final base = DateTime(hoy.year, hoy.month, hoy.day);
    return base.add(Duration(days: dias, hours: hora, minutes: minuto));
  }

  return [
    Task(
      id: 'demo-avance-proyecto',
      titulo: 'Entregar avance del proyecto TaskU',
      cursoId: 'dispositivos-moviles',
      prioridad: Prioridad.alta,
      tipo: TipoTarea.proyecto,
      estado: EstadoTarea.enProgreso,
      descripcion:
          'Subir al aula virtual el PDF con el resumen del proyecto, el user '
          'persona y el lienzo de propuesta de valor, según la rúbrica.',
      fechaEntrega: enDias(1),
      recordatorioMinutos: 24 * 60,
      subtareas: const [
        Subtask(
          id: 'demo-avance-1',
          titulo: 'Resumen del proyecto',
          hecha: true,
        ),
        Subtask(id: 'demo-avance-2', titulo: 'User Persona', hecha: true),
        Subtask(
          id: 'demo-avance-3',
          titulo: 'Lienzo de propuesta de valor',
          hecha: true,
        ),
        Subtask(id: 'demo-avance-4', titulo: 'Business Model Canvas'),
      ],
    ),
    Task(
      id: 'demo-laboratorio-sql',
      titulo: 'Laboratorio de SQL: consultas avanzadas',
      cursoId: 'base-de-datos',
      prioridad: Prioridad.media,
      estado: EstadoTarea.pendiente,
      descripcion: 'Resolver los ejercicios 3 al 8 del laboratorio.',
      fechaEntrega: enDias(2),
      recordatorioMinutos: 24 * 60,
      subtareas: const [
        Subtask(id: 'demo-sql-1', titulo: 'Ejercicios de JOIN'),
        Subtask(id: 'demo-sql-2', titulo: 'Subconsultas'),
        Subtask(id: 'demo-sql-3', titulo: 'Capturas de resultados'),
      ],
    ),
    Task(
      id: 'demo-examen-software',
      titulo: 'Examen parcial de Ingeniería de Software',
      cursoId: 'ingenieria-software',
      prioridad: Prioridad.alta,
      tipo: TipoTarea.examen,
      descripcion: 'Unidades 1 a 4. Incluye preguntas de arquitectura.',
      fechaEntrega: enDias(5, hora: 8, minuto: 0),
      recordatorioMinutos: 2 * 24 * 60,
    ),
    Task(
      id: 'demo-lectura-redes',
      titulo: 'Lectura: capítulo 4 de Redes',
      cursoId: 'redes-computadoras',
      prioridad: Prioridad.baja,
      descripcion: 'Capas de transporte y control de congestión.',
      fechaEntrega: enDias(3),
    ),
    Task(
      id: 'demo-practica-flutter',
      titulo: 'Práctica de widgets en Flutter',
      cursoId: 'dispositivos-moviles',
      prioridad: Prioridad.media,
      estado: EstadoTarea.completada,
      descripcion: 'Repaso de StatelessWidget y StatefulWidget.',
      fechaEntrega: enDias(-2),
      subtareas: const [
        Subtask(id: 'demo-flutter-1', titulo: 'Contador', hecha: true),
        Subtask(id: 'demo-flutter-2', titulo: 'Formulario', hecha: true),
      ],
    ),
    Task(
      id: 'demo-modelo-er',
      titulo: 'Modelo entidad-relación',
      cursoId: 'base-de-datos',
      prioridad: Prioridad.baja,
      estado: EstadoTarea.completada,
      fechaEntrega: enDias(-4),
    ),
    Task(
      id: 'demo-presentacion-arquitectura',
      titulo: 'Presentación de arquitectura',
      cursoId: 'ingenieria-software',
      prioridad: Prioridad.alta,
      tipo: TipoTarea.proyecto,
      descripcion: 'Explicar la arquitectura por capas del sistema.',
      fechaEntrega: enDias(7),
      recordatorioMinutos: 24 * 60,
    ),
    Task(
      id: 'demo-cuestionario-ip',
      titulo: 'Cuestionario de direccionamiento IP',
      cursoId: 'redes-computadoras',
      prioridad: Prioridad.media,
      tipo: TipoTarea.examen,
      fechaEntrega: enDias(9),
      recordatorioMinutos: 24 * 60,
    ),
  ];
}

/// Carga los cursos y tareas de ejemplo. Se llama desde
/// `AppDatabase.alCrear`, es decir, solo en una instalación nueva.
Future<void> sembrarDatosIniciales(AppDatabase db) async {
  final cursos = DriftCourseRepository(db);
  final tareas = DriftTaskRepository(db);
  for (final curso in cursosSemilla) {
    await cursos.crear(curso);
  }
  for (final tarea in tareasSemilla()) {
    await tareas.crear(tarea);
  }
}
