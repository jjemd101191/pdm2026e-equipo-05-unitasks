# ADR 0001 · Persistencia local con Hive Community Edition

- **Estado:** aceptada
- **Fecha:** 2026-10-29
- **Contexto:** TaskU funcionaba con listas en memoria (`DemoCourseRepository` y
  `cursosDemo`). Al cerrar la app se perdían los cursos, las tareas nunca se
  guardaban y los flujos de crear/editar/eliminar terminaban en un aviso. El
  proyecto necesita una base local que funcione sin conexión en móvil y que
  también permita la demostración en web.

## Decisión

Usar **Hive Community Edition** (`hive_ce` 2.22.0 + `hive_ce_flutter` 2.5.0)
con tres cajas:

| Caja | Contenido |
|---|---|
| `cursos_v1` | Cursos serializados como JSON, clave = `Course.id`. |
| `tareas_v1` | Tareas serializadas como JSON, clave = `Task.id`. |
| `meta_v1` | Marca `sembrado` para cargar los datos de ejemplo una sola vez. |

Cada registro se guarda como `String` JSON (`jsonEncode`) en un
`Box<String>`. Las fechas usan ISO 8601 y los enums se guardan por `name`.

## Alternativas consideradas

| Alternativa | Por qué no se eligió |
|---|---|
| `hive` 2.2.3 (original) | Su restricción es `sdk >=2.12 <3.0`; no resuelve con Dart 3.12. |
| `sqflite` | No funciona en web sin `sqflite_common_ffi_web` + assets/worker; en esta máquina no hay Android SDK para verificar la app nativa. |
| `drift` | Buena opción SQL, pero exige `build_runner` y configuración web con WASM; más complejidad de la necesaria para el alcance actual. |
| `shared_preferences` | Guarda preferencias, no colecciones con consultas ni relaciones curso–tarea. |

## Consecuencias

**Positivas**

- Funciona en Android, iOS, escritorio y web con la misma API.
- Sin codegen ni dependencias nativas adicionales.
- Los datos son legibles: se puede inspeccionar el JSON y migrar después.
- Los repositorios quedan detrás de interfaces (`CourseRepository`,
  `TaskRepository`), así que cambiar el motor no obliga a tocar las pantallas.

**Negativas / límites**

- No hay SQL ni transacciones relacionales; la integridad curso–tarea se
  mantiene en los repositorios (por ejemplo, no se borra un curso con tareas).
- No hay cifrado: cualquiera con acceso al almacenamiento del dispositivo puede
  leer las cajas. Para datos sensibles habría que evaluar `HiveAesCipher`.
- En web los datos viven en IndexedDB del navegador y no se sincronizan entre
  dispositivos.
- Cambiar el esquema exige una nueva versión de caja (`_v2`) y una migración
  explícita.

## Reglas asociadas

1. Un curso solo se elimina si no tiene tareas; si las tiene, la UI explica
   cuántas y no permite el borrado.
2. Los pendientes, totales y el avance de un curso se calculan desde las tareas
   (`CourseSummary`), nunca se guardan como campos del curso.
3. Completar una tarea marca todas sus subtareas; desmarcar una subtarea reabre
   la tarea.
4. Los recordatorios se calculan desde la fecha de entrega
   (`RecordatorioOpcion.programadoPara`). Por ahora se muestran dentro de la
   app; las notificaciones del sistema quedan para una versión posterior.
