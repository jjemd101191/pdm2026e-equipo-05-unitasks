# Explicación de arquitectura para la demo

**TaskU · Equipo 05 · PDM 2026**  
Guion corto para responder «¿de dónde salen los datos, dónde se guardan y qué pasa si algo falla?».

---

## Versión de 30 segundos

> «La app está separada en cuatro capas: **pantallas**, **estado**, **repositorios** y **datos**. La pantalla nunca escribe SQL: llama a un repositorio, el repositorio aplica las reglas y el DAO habla con SQLite mediante Drift. Cuando la base cambia, un stream vuelve a emitir y la pantalla se actualiza. Las decisiones están en las ADR 0002 y 0003.»

---

## Recorrido de un dato (crear una tarea)

1. El estudiante llena `TaskFormScreen` y toca **Guardar**.
2. El formulario valida el título y devuelve una `Task` por `Navigator.pop`.
3. `TaskListScreen` recibe la tarea y llama a `repositorio.crear(tarea)`.
4. `DriftTaskRepository` convierte la `Task` en `TasksCompanion`.
5. `TareasDao` guarda tarea, subtareas y recordatorio en **una transacción**.
6. SQLite deja los datos en `tasku.sqlite`.
7. Drift emite de nuevo el stream de `watchTareas`; el repositorio mapea las filas a `Task` y la pantalla muestra la lista actualizada.

Archivos para señalar:

| Paso | Archivo |
|---|---|
| Pantalla | `lib/screens/task_form_screen.dart`, `lib/screens/task_list_screen.dart` |
| Repositorio | `lib/data/drift_task_repository.dart` |
| DAO | `lib/data/db/tareas_dao.dart` |
| Esquema y migraciones | `lib/data/db/app_database.dart`, `lib/data/db/tablas.dart` |
| Decisión | `docs/adr/0002-persistencia-drift-riverpod.md`, `docs/adr/0003-flujo-de-datos-y-migraciones.md` |

---

## Preguntas probables y respuestas

### ¿De dónde salen los datos?

- En una instalación nueva, de `lib/data/seed_data.dart`: 4 cursos y 8 tareas de ejemplo que se cargan una sola vez en `onCreate`.
- Después, todo lo que el estudiante crea se guarda en la base local. No hay backend ni cuentas.

### ¿Dónde se guardan?

- En SQLite, archivo `tasku.sqlite`, a través de Drift. En web se usa SQLite compilado a WASM.
- La app funciona sin conexión y no envía datos a ningún servidor.

### ¿Qué pasa si falla algo?

| Falla | Respuesta |
|---|---|
| Borrar un curso con tareas | El repositorio lanza `CursoConTareasException` con el número de tareas; la clave foránea `RESTRICT` lo impide también en la base. |
| Actualizar una tarea que ya no existe | `TareaNoEncontradaException`. |
| La base no abre al arrancar | `main.dart` muestra la pantalla «No pudimos abrir tus datos locales». |
| Falla una carga | La pantalla muestra `EstadoVista` con «Reintentar». |
| Falla un guardado | `SnackBar` con el error y el formulario conserva lo escrito. |

### ¿Por qué Drift y no Hive?

- Hive guardaba JSON en cajas y no tenía relaciones reales entre curso, tarea y subtarea.
- Drift da claves foráneas, índices, consultas SQL y streams reactivos.
- Además permite versionar el esquema y probar migraciones.
- La ADR 0001 (Hive) quedó reemplazada por la ADR 0002.

### ¿Cómo se aplican los cambios de esquema?

- `schemaVersion = 2`.
- La migración v1 → v2 agrega `courses.archivado` con valor `false` en `onUpgrade`.
- `test/data/migracion_test.dart` crea una base v1, la abre con v2 y comprueba que los datos sobreviven y que `PRAGMA user_version` termina en 2.
- Para el próximo cambio: subir la versión, agregar el paso en `onUpgrade`, regenerar con `dart run build_runner build` y agregar su prueba.

### ¿Por qué no MVVM?

- Es una arquitectura por capas: pantalla → repositorio → DAO → base.
- El estado compartido vive en Riverpod (`lib/providers/providers.dart`), pero no hay una capa de ViewModel separada.
- La ventaja es que la pantalla no conoce SQL y el repositorio se puede probar sin interfaz.

### ¿Qué falta o qué cambiarías?

- Migrar las pantallas a `ref.watch` para que todas compartan un único origen de verdad (hoy reciben los repositorios por constructor).
- Agregar `sqlite3.wasm` y `drift_worker.js` para que la web abra la base.
- Notificaciones del sistema (hoy los recordatorios se muestran dentro de la app).
- Si lo rehiciera, mantendría Drift desde el inicio y usaría Riverpod en todas las pantallas desde el primer módulo.

---

## Demo en 1 minuto (solo arquitectura)

1. Abrir **Inicio** y mostrar que las tareas vienen de la base, no de una lista fija.
2. Crear una tarea y señalar: formulario → repositorio → DAO → SQLite.
3. Cerrar la app por completo y volver a abrir: la tarea sigue ahí.
4. Abrir **Cursos**, intentar borrar un curso con tareas y mostrar el mensaje.
5. Cerrar con: «Las decisiones están en las ADR 0002 y 0003; la migración v1 → v2 está probada en `test/data/migracion_test.dart`.»
