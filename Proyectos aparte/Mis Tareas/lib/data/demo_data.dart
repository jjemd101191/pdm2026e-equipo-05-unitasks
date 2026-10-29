import '../models/course.dart';
import '../theme.dart';

/// Datos de demostración en memoria, alineados al mockup y al user persona
/// (Diego Morales). En la versión final se reemplazan por la base de datos
/// local (SQLite/Hive) definida en el proyecto.
final List<Course> cursosDemo = <Course>[
  const Course(
    id: 'dispositivos-moviles',
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
    id: 'base-de-datos',
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
    id: 'ingenieria-software',
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
    id: 'redes-computadoras',
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
