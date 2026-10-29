# Contrato provisional para integrar A y B

No se recibió todavía el contrato de la pareja A. Estas firmas permiten ejecutar y probar B de forma aislada; no son una afirmación sobre lo que A ya implementó.

## Archivos de conexión

- lib/data/curso_dao.dart: interfaz CursoDao y excepciones compartidas.
- lib/data/cursos_provider.dart: punto de inyección. Actualmente crea DemoCursoDao.
- lib/data/course_repository.dart: implementación temporal en memoria; sustituir su uso por SqliteCursoDao.
- lib/models/course.dart: modelo original más archivado y copyWith, provisionales hasta combinar con A. No reemplazar el modelo de A sin comparar campos y tipos.

```dart
abstract class CursoDao {
  Future<List<Course>> obtenerCursos();
  Future<void> guardarCurso(Course curso);
  Future<int> tareasDe(String id);
  Future<void> eliminarCurso(String id);
  Future<void> archivarCurso(String id);
  Future<void> restaurarCurso(Course curso, {int? indice});
}
```

- obtenerCursos incluye activos y archivados; la interfaz aplica filtros sobre una copia.
- guardarCurso inserta si es nuevo; actualiza la MISMA fila si el id existe. Nunca reemplazar la fila eliminándola ni cambiar su id. Los id actuales son String; confirmar con A.
- tareasDe devuelve el conteo real de tareas asociadas, incluidas completadas. totalTareas es un dato de resumen, no reemplaza esa consulta en SQLite.
- eliminarCurso verifica dependencias también en la capa de datos de forma atómica; la revisión de la interfaz no sustituye esa garantía. Si aparecieron tareas después de la consulta, lanzar CursoEnUsoException(cantidad).
- archivarCurso actualiza solo el estado de archivado; no elimina tareas.
- restaurarCurso se utiliza para Deshacer y debe conservar id y datos. indice se conserva como argumento opcional de compatibilidad, pero la demo no garantiza el orden anterior. El DAO SQL debe definir un orden de consulta estable.
- CursoDuplicadoException identifica una violación de unicidad, sin exponer SQL al usuario. La regla provisional es nombre.trim().toLowerCase() + periodo; confirmar que el índice UNIQUE de A aplica la misma regla, incluyendo archivados.
- Course.copyWith conserva id, archivado, estadísticas y los campos que no se cambian. archivado es bool en Dart (0/1 en SQLite según A).

## Estado y paquete

Se usa flutter_riverpod porque el reparto exige ref.watch(cursosProvider) y ref.invalidate(cursosProvider). No se agregó el paquete provider. Si A usa provider, acordar una sola opción antes de integrar.

CourseFormScreen recibe Course? y Future<void> Function(Course) onGuardar. No conoce SQL ni providers. Mantiene el formulario abierto y conserva los datos si guardar falla. CourseListScreen conecta el callback al DAO e invalida cursosProvider tras guardar, eliminar, archivar o deshacer.

## Integración pendiente

1. Recibir AppDatabase, SqliteCursoDao, modelo y excepciones de A; comparar firmas y usar una sola definición de cada tipo.
2. Inicializar la base en el arranque e inyectar su DAO mediante cursoDaoProvider. Si abrir la base es asíncrono, resolverlo antes de construir ProviderScope o adaptar el provider, sin cambiar el formulario.
3. Conservar las restricciones SQL y traducir únicamente los errores UNIQUE correspondientes a CursoDuplicadoException.
4. Ejecutar nuestras pruebas con DAO falso y las pruebas de migración v1 a v2 de A.
5. Probar persistencia real al cerrar/reabrir y verificar crear, editar, borrar y archivar en un dispositivo.
6. Más adelante, incluir esta carpeta en el CI del equipo. No se modificó .github.

Mientras se use DemoCursoDao, reiniciar la app pierde cambios. La demo solo simula cantidades de tareas; no implementa su CRUD ni una base de datos.
