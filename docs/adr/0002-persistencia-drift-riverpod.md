# ADR 0002 · Persistencia con Drift (SQLite) y estado con Riverpod

- **Estado:** aceptada · reemplaza a la [ADR 0001](0001-persistencia-local-hive.md)
- **Fecha:** 2026-10-29
- **Contexto:** con Hive (ADR 0001) los datos ya sobrevivían al cerrar la app,
  pero cada pantalla volvía a pedir listas con `obtenerTareas()` y guardaba su
  propia copia. No había relaciones reales entre curso, tarea y subtarea, ni
  forma de enterarse de un cambio hecho en otra pantalla. El reparto de trabajo
  del equipo pide un esquema con claves foráneas, migraciones, streams
  reactivos y un único origen de verdad para que los Integrantes 2 y 3
  programen contra un contrato fijo.

## Decisión

1. **Drift 2.35** sobre SQLite, abierto con `drift_flutter` (archivo
   `tasku.sqlite` en móvil/escritorio, WASM en web).
2. **Riverpod 3** sin generación de código para exponer repositorios y listas.
3. Las pantallas solo hablan con `CourseRepository` y `TaskRepository`; nadie
   escribe SQL fuera de `lib/data/db/`.

### Esquema v1

| Tabla | Columnas clave | Relaciones e índices |
|---|---|---|
| `courses` | `id` (PK texto), `nombre` (1–80), `color` ARGB, `dias` ("Lun,Mié") | — |
| `tasks` | `id`, `curso_id`, `titulo` (1–120), `tipo`/`prioridad`/`estado` (texto del enum), `fecha_entrega` | FK → `courses` **RESTRICT**; índices por `curso_id` y `fecha_entrega` |
| `subtasks` | `id`, `tarea_id`, `titulo`, `hecha`, `posicion` | FK → `tasks` **CASCADE**; índice por `tarea_id` |
| `reminders` | `id` (entero autoincremental), `tarea_id`, `minutos_antes` > 0 | FK → `tasks` **CASCADE**; índice **único** por `tarea_id` |

- `PRAGMA foreign_keys = ON` se activa en `beforeOpen`; sin eso SQLite ignora
  las FK.
- El `id` de `reminders` sirve como id de la notificación local y se conserva
  al editar (upsert sobre `tarea_id`), para poder cancelar/reprogramar.
- Las semillas se cargan en `onCreate`, así que solo aparecen en una
  instalación nueva (reemplaza la marca `sembrado` de Hive).

### Contrato para el resto del equipo

```dart
abstract class TaskRepository {
  Stream<List<Task>> watchTareas({String? cursoId});
  Future<Task?> obtenerTarea(String id);
  Future<void> crear(Task tarea);
  Future<void> actualizar(Task tarea);   // TareaNoEncontradaException
  Future<void> eliminar(String id);
}

abstract class CourseRepository {
  Stream<List<Course>> watchCursos();
  Future<void> crear(Course curso);
  Future<void> actualizar(Course curso);
  Future<void> eliminar(String id);      // CursoConTareasException
}
```

`Task` lleva `cursoId` (no el objeto `Course`), `DateTime fechaEntrega`
obligatoria e `int? recordatorioMinutos`. Para mostrar el curso de una tarea:
`cursos.porId(tarea.cursoId)`.

Providers en `lib/providers/providers.dart`: `databaseProvider`,
`courseRepositoryProvider`, `taskRepositoryProvider`, `cursosProvider`,
`tareasProvider`, `tareasDeCursoProvider(id)`, `tareaProvider(id)` y
`resumenCursosProvider`. En pruebas se sobrescribe el repositorio con
`TareaRepoMemoria` / `CursoRepoMemoria` (`test/support/fakes.dart`).

## Alternativas consideradas

| Alternativa | Por qué no |
|---|---|
| Seguir con Hive | Sin FKs, sin consultas ni streams por tabla; la integridad quedaba en código. |
| `sqflite` | No funciona en web sin configuración extra y no da streams ni tipos. |
| Riverpod con `riverpod_generator` | Más codegen además del de Drift; para pocos providers no compensa. |

## Consecuencias

**Positivas**

- La base garantiza las reglas: no se borra un curso con tareas y al borrar
  una tarea se van sus subtareas y su recordatorio.
- Un cambio hecho en cualquier pantalla llega a las demás por el stream.
- Las pruebas usan `NativeDatabase.memory()`, rápidas y sin archivos.

**Negativas / pendientes**

- Hay que correr `dart run build_runner build` al tocar las tablas; los
  `.g.dart` se suben al repo para que el CI no dependa de ese paso.
- **Web:** `web/` necesita `sqlite3.wasm` y `drift_worker.js` (de los releases
  de `sqlite3` y `drift`, en versiones que coincidan con `pubspec.lock`). Sin
  ellos la app compila para web pero no abre la base.
- Los datos guardados con Hive (versión 1.1.0) **no se migran**: eran datos de
  ejemplo y la app vuelve a sembrarlos.
- Los enums se guardan por `name`: renombrar un valor requiere migración.
- Cambiar el esquema exige subir `schemaVersion` y agregar el paso en
  `onUpgrade`.
