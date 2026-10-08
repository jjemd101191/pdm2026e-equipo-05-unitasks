import '../models/course.dart';
import '../models/task.dart';
import '../theme.dart';

/// Datos de demostración en memoria, alineados al mockup y al user persona
/// (Diego Morales). En la versión final se reemplazan por la base de datos
/// local (SQLite/Hive) definida en el proyecto.
final List<Course> cursosDemo = <Course>[
  const Course(
    nombre: 'Dispositivos Móviles',
    docente: 'Ing. Mario Castillo',
    color: kIndigo,
    dias: ['Lun', 'Mié'],
    horaInicio: '10:00',
    horaFin: '12:00',
    pendientes: 4,
    totalTareas: 12,
  ),
  const Course(
    nombre: 'Base de Datos',
    docente: 'Ing. Laura Pérez',
    color: kSky,
    dias: ['Mar', 'Jue'],
    horaInicio: '8:00',
    horaFin: '10:00',
    pendientes: 3,
    totalTareas: 10,
  ),
  const Course(
    nombre: 'Ingeniería de Software',
    docente: 'Lic. Ana Gómez',
    color: kGreen,
    dias: ['Vie'],
    horaInicio: '14:00',
    horaFin: '16:00',
    pendientes: 2,
    totalTareas: 8,
  ),
  const Course(
    nombre: 'Redes de Computadoras',
    docente: 'Ing. Carlos Ruiz',
    color: kAmber,
    dias: ['Lun'],
    horaInicio: '16:00',
    horaFin: '18:00',
    pendientes: 2,
    totalTareas: 6,
  ),
];

/// Tarea de ejemplo para la pantalla 4A (detalle de tarea).
final Task tareaDemo = Task(
  titulo: 'Entregar avance del proyecto TaskU',
  curso: cursosDemo.first,
  prioridad: 'Alta',
  tipo: 'Proyecto',
  estado: 'En progreso',
  descripcion:
      'Subir al aula virtual el PDF con el resumen del proyecto, el user '
      'persona y el lienzo de propuesta de valor, según la rúbrica.',
  fechaEntrega: 'Vie 10 oct 2026 · 23:59',
  recordatorio: '1 día antes · 8:00 a. m.',
  subtareas: [
    Subtask('Resumen del proyecto', hecha: true),
    Subtask('User Persona', hecha: true),
    Subtask('Lienzo de propuesta de valor', hecha: true),
    Subtask('Business Model Canvas'),
  ],
);
