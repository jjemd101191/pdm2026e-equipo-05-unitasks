# Bitácora de uso de IA

Cada uso de IA que termina en el repo se registra aquí (el más reciente arriba).
El objetivo no es justificar el uso, sino demostrar **criterio**:
qué especificaste, qué revisaste y qué rechazaste.

| Campo | Qué escribir |
|---|---|
| Fecha / autor | `2026-10-15 · @usuario` |
| Herramienta | Claude, Copilot, ChatGPT… |
| Especificación | Qué pediste y con qué restricciones (pegar el prompt o resumirlo) |
| Resultado | Qué devolvió, en una frase |
| Aceptado | Qué quedó en el código y por qué |
| Rechazado / corregido | Qué cambiaste y por qué. **Esta es la columna más importante.** |
| Verificación | Cómo comprobaste que funciona (pruebas, dispositivo) |
| Commit / PR | Enlace |

---

## 2026-11-01 · @jjemd101191 — corrección de la verificación UX y estado del equipo

- **Herramienta:** Claude Code.
- **Especificación:** «Revisar el estado de `main` después de fusionar el PR #25 y corregir la documentación de verificación que quedó desactualizada: rama y base del PR, conteo de pruebas y ubicación de la entrada en la bitácora. No inventar sesiones de usuarios ni cambiar el código de la app.»
- **Resultado:** `docs/validacion-ux-pablo.md`, `docs/usuarios.md`, `docs/guion-ux-pablo.md`, `README.md` y esta bitácora actualizados a la rama y base reales; entrada de Pablo reordenada y con el conteo correcto; auditoría del estado del equipo frente a la rúbrica.
- **Aceptado:**
  - Se corrigió el conteo de 80 a 84 pruebas (76 de la base tras el PR #23 + 8 del PR #25).
  - Se enlazó el PR #25 (`3962af4`) y se retiró la afirmación de que no hubo push ni PR.
  - Se mantiene 0/3 en `usuarios.md`: no se simularon entrevistas.
- **Rechazado / corregido:**
  - Se descartó completar `usuarios.md` con perfiles sintéticos o resultados inventados; el requisito de tres personas reales sigue pendiente.
  - No se modificó el código, el esquema ni las pruebas del PR #25.
- **Verificación:** `dart analyze lib test` sin observaciones; `flutter test --no-pub` → 84 pruebas en verde sobre `main` en `3962af4`.
- **Commit / PR:** rama `docs/corregir-verificacion-ux`; PR por abrir (actualizar esta línea con el enlace).

---

## 2026-11-01 · @PabloFranco777 — UX: Perfil y recuperación del arranque

- **Herramienta:** Codex.
- **Especificación:** actualizar la base del repositorio y realizar solo la parte UX de Adrián Pablo Girón Franco conforme al plan v3 y la exposición; conservar el diseño y no hacer push ni cambiar el trabajo de los demás.
- **Resultado:** Perfil local neutro, carga, vacío orientado, error con Reintentar; arranque con apertura recuperable sin borrar datos; pruebas UX, capturas, protocolo de usuarios y guion individual.
- **Aceptado:** reutilizar tema, EstadoVista y repositorios existentes; probar fallos con fábricas y fakes; conservar el esquema y migración de JM. Se actualizó origin mediante fetch y se abrió una rama local desde main.
- **Rechazado / corregido:** no inventar tres usuarios, entrevistas o resultados. Se descartó ampliar a búsqueda, base de datos o QA de otros integrantes. Se corrigieron callbacks de setState y el fallo asíncrono previo a la suscripción de FutureBuilder detectados por pruebas; la prueba de arranque usa una base `NativeDatabase.memory()` y una fábrica controlada, no aísla la UI de SQLite nativo. No se desactivaron pruebas.
- **Verificación:** `dart analyze lib test` sin observaciones; `flutter test --no-pub` → 84 pruebas aprobadas sobre la rama rebasada a `8e25eec`. No se cambió Developer Mode pese al aviso de symlinks del entorno. Pruebas reales con tres personas y Android pendientes.
- **Commit / PR:** PR #25, commit `dfe5079`, merge `3962af4`.

---

## 2026-11-01 · @jjemd101191 — correcciones de la revisión del PR #22

- **Herramienta:** Claude Code.
- **Especificación:** «Corregir las observaciones que quedaron en la revisión del PR #22: ordenar y completar el formato de las entradas de la bitácora, extraer el diálogo de confirmación duplicado a un helper compartido y añadir al diálogo el título y el nombre de la tarea. No cambiar el esquema ni la persistencia.»
- **Resultado:** `lib/widgets/confirmacion_estado.dart` con `confirmarCambioEstado(...)`; Inicio y el detalle usan el mismo diálogo, que ahora indica el nombre de la tarea y qué pasará con sus subtareas; entradas del 1 de noviembre reordenadas y con el formato de la tabla; cuatro pruebas nuevas del helper.
- **Aceptado:**
  - El helper recibe el número de subtareas para avisar cuántas se marcarán al completar y que siguen marcadas al reabrir.
  - «Cancelar», cerrar el diálogo o tocar fuera devuelven `false`; solo «Confirmar» devuelve `true`.
  - Se conservan las etiquetas «Cancelar» y «Confirmar» de los flujos ya probados.
- **Rechazado / corregido:**
  - Se descartó mantener el diálogo duplicado en cada pantalla con textos propios: cualquier cambio habría que hacerlo dos veces.
  - Tocar una subtarea de una tarea completada sigue reabriéndola sin un segundo diálogo: es la regla del checklist (desmarcar una subtarea reabre la tarea) y pedir confirmación en cada toque haría más lento el flujo; el aviso se da en el diálogo de reapertura.
  - No se modificaron el esquema, los DAO ni los repositorios: las pruebas de migración y de datos siguen igual.
- **Verificación:** `dart format` sin cambios pendientes; `dart analyze` sin observaciones; `flutter test` → 76 pruebas en verde.
- **Commit / PR:** PR #23 (issue #21); commits `b8d7c6f` y `e3321b8`.

---

## 2026-11-01 · @Demybrictany — confirmación del cambio de estado de tareas

- **Herramienta:** Codex.
- **Especificación:** Implementar diálogos de confirmación para completar y reabrir tareas desde Inicio y desde la pantalla de detalle, y cubrirlos con pruebas automatizadas.
- **Resultado:** confirmación con «Cancelar» y «Confirmar» en `task_list_screen.dart` y `task_detail_screen.dart`; pruebas en `task_list_completion_confirmation_test.dart` y `task_detail_completion_confirmation_test.dart`.
- **Aceptado:** se pide confirmación antes de guardar el cambio de estado, para evitar modificaciones accidentales.
- **Rechazado / corregido:** el diálogo quedó duplicado en las dos pantallas y sin título; la revisión del PR lo señaló y se corrigió en la entrada del 2026-11-01 de `@jjemd101191`.
- **Verificación:** `flutter analyze` sin errores; `flutter test` → 72 pruebas; `dart format` sin cambios pendientes en los cinco archivos revisados.
- **Commit / PR:** PR #22 (issue #21), merge `4263e6b`.

---

## 2026-11-01 · @Demybrictany — búsqueda de tareas y soporte SQLite Web

- **Herramienta:** ChatGPT y OpenAI Codex.
- **Especificación:** Analizar la arquitectura de TaskU e implementar una búsqueda de tareas por título, descripción y nombre del curso en la pantalla Inicio, sin distinguir mayúsculas y minúsculas. Conservar los filtros existentes y evitar modificaciones innecesarias en la base de datos y otros módulos. Posteriormente, solucionar los errores de inicialización de Drift/SQLite en Chrome.
- **Resultado:** Se implementó el buscador en `lib/screens/task_list_screen.dart`, se agregaron seis pruebas automatizadas en `test/task_list_search_test.dart` y se incorporaron los archivos `web/sqlite3.wasm` y `web/drift_worker.js` para permitir el funcionamiento de SQLite en Flutter Web.
- **Aceptado:**
  - Búsqueda dinámica por título, descripción y curso.
  - Compatibilidad con los filtros Pendientes, Todas y Completadas.
  - Mensaje cuando no existen coincidencias y opción para limpiar la búsqueda.
  - Archivos de soporte necesarios para ejecutar SQLite en Chrome.
- **Rechazado / corregido:**
  - Se descartó modificar la base de datos y los repositorios porque la búsqueda podía implementarse utilizando los datos disponibles en la pantalla.
  - Se restauraron siete archivos generados de Flutter para Linux, macOS y Windows, después de verificar que sus diferencias correspondían únicamente a finales de línea.
  - Se corrigió la falta de recursos de SQLite Web, que impedía inicializar la base de datos en Chrome.
- **Verificación:** `dart format` correcto, `flutter analyze` sin problemas y 64 pruebas automatizadas aprobadas, según el reporte de Codex. Se realizaron 10 pruebas manuales en Chrome, todas aprobadas, incluyendo búsquedas, filtros combinados y creación de tareas.
- **Commit / PR:** PR #20 (issue #19), merge `af97b4b`.

---

## 2026-10-31 · @jjemd101191 — migración v2 y flujo de datos

- **Herramienta:** Claude Code.
- **Especificación:** «Implementar la migración v2 del esquema de TaskU: agregar `courses.archivado`, subir `schemaVersion`, escribir el paso en `onUpgrade`, agregar una prueba que abra una base v1 y verifique que los datos sobreviven, documentar el flujo de datos en una ADR y corregir la sección técnica del README.»
- **Resultado:** columna `archivado`, `schemaVersion = 2`, migración v1 → v2, prueba en `test/data/migracion_test.dart`, ADR 0003, README actualizado y una guía de explicación para la demo.
- **Aceptado:**
  - Booleano con valor por defecto `false`, para que los cursos existentes sigan visibles después de actualizar.
  - La prueba crea una base con el esquema nuevo, quita la columna, baja `user_version` a 1 y reabre la base para ejecutar la migración real.
  - La deuda de Riverpod (pantallas con repositorios por constructor) quedó documentada en la ADR 0003 en lugar de migrar todas las pantallas antes del 5 de noviembre.
- **Rechazado / corregido:**
  - Se descartó usar `SchemaVerifier` de `drift_dev` para no agregar otro paso de generación; la prueba usa una base SQLite real.
  - `build_runner` y `flutter analyze` fallan en Windows por la ruta con acentos del proyecto; `build_runner` se ejecutó en una copia con ruta ASCII y se usó `dart analyze`. El CI corre `flutter analyze` en Linux.
  - El bump de versión, el changelog y la etiqueta quedan para el cierre de QA (Marco); el README mantiene 1.1.0 hasta ese momento.
- **Verificación:** `dart format` sin cambios; `dart analyze` sin observaciones; `flutter test` → 58 pruebas en verde; `flutter build web --release` compila.
- **Commit / PR:** rama `feat/migracion-v2-archivado`.

---

## 2026-10-29 · Integrante 1 — núcleo de datos con Drift y Riverpod

- **Herramienta:** Claude Code (asistente de código).
- **Especificación:** "Me toca la parte del Integrante 1: reemplazar la capa de
  datos por Drift con esquema `courses/tasks/subtasks/reminders` (FKs, índices,
  migración v1), modelos según el contrato (`cursoId`, `DateTime fechaEntrega`,
  `int? recordatorioMinutos`), repositorios con streams, providers de Riverpod y
  pruebas. Que el código no se vea robótico."
- **Resultado:** Drift + `drift_flutter`, 4 tablas con FKs (RESTRICT para
  cursos, CASCADE para subtareas y recordatorios), DAOs, repositorios
  `Drift*Repository` con `watchTareas`/`watchCursos`, providers en
  `lib/providers/providers.dart`, ADR 0002 y pruebas de modelos, DAOs,
  repositorios y providers.
- **Aceptado:**
  - Una sola consulta con JOIN para `watchTareas`, así el stream se dispara
    también cuando cambia una subtarea o un recordatorio.
  - `reminders.id` entero estable (upsert por `tarea_id`) para usarlo como id
    de la notificación del Integrante 2.
  - Semillas en `onCreate` en lugar de la marca `sembrado`.
- **Rechazado / corregido:**
  - Antes de empezar, se revisó `main` y ya existía persistencia con Hive
    (ADR 0001) y los defectos de "lista compartida por referencia" y "edición
    descartada" ya estaban corregidos. Se decidió igual migrar a Drift porque
    el reparto pide FKs, migraciones y streams; la ADR 0001 quedó marcada como
    reemplazada.
  - Se descartó `riverpod_generator`: con Drift ya hay un paso de codegen y
    para 8 providers no hace falta otro.
  - Las pantallas de los Integrantes 2 y 3 solo recibieron los cambios mínimos
    para compilar con el contrato nuevo (buscar el curso con `porId`, `crear`
    vs `actualizar`). Pasarlas a `ref.watch` queda para ellos.
  - El formulario ya no permite tareas sin fecha (el contrato la hace
    obligatoria); una tarea nueva propone mañana 23:59.
  - Una prueba de "cerrar y reabrir" tenía una comprobación redundante con
    código muerto que `dart analyze` marcó; se quitó.
  - Las pruebas destaparon que `Course ==` fallaba cuando el color era un
    `MaterialColor` (al leerlo de la base vuelve como `Color`). Se cambió la
    igualdad para comparar el valor ARGB.
  - Riverpod 3 pausa los providers sin oyentes: las pruebas de providers se
    reescribieron para escucharlos antes de leer, como hace una pantalla.
- **Verificación:** `dart format` sin cambios; `dart analyze` → sin
  observaciones; `flutter test` → 56 pruebas en verde (modelos, DAOs con
  SQLite en memoria, repositorios, cerrar/reabrir con archivo real, providers
  y las pruebas de widgets existentes); `flutter build web --release` compila.
- **Commit / PR:** PR #<!-- número -->

---

## 2026-10-29 · @jjemd101191 — persistencia local y flujo completo de tareas

- **Herramienta:** Claude Code (asistente de código).
- **Especificación:** "Diagnostica `Proyecto final` y después implementa la base
  de datos y todo lo que falta para que la app funcione: persistencia, modelo de
  tareas, conexión de pantallas, pantalla de pendientes, calendario y perfil.
  Documenta el trabajo y prepara el commit como pide el curso."
- **Resultado:** `Task` con id y `DateTime`; persistencia Hive CE con repositorios
  de cursos y tareas; Inicio con tareas reales; edición/borrado que sí guardan;
  conteos de cursos calculados desde las tareas; Calendario y Perfil funcionales;
  branding TaskU; 25 pruebas y una compilación web en verde.
- **Aceptado:**
  - `hive_ce` + `hive_ce_flutter` con cajas `cursos_v1`, `tareas_v1` y
    `meta_v1`, registros JSON y fechas ISO 8601 (ver ADR 0001).
  - Repositorios detrás de interfaces para poder probar con dobles en memoria.
  - Semilla de 4 cursos y 8 tareas solo en la primera apertura (`sembrado`).
  - Regla: un curso con tareas no se elimina; se avisa cuántas tiene.
  - `CourseSummary` calcula pendientes/total/avance; `Course` ya no guarda
    contadores escritos a mano.
  - Recordatorios calculados desde la entrega y mostrados dentro de la app.
- **Rechazado / corregido:**
  - `hive` 2.2.3: **rechazado** porque exige `sdk <3.0.0` y el proyecto usa Dart
    3.12. Se usó Hive CE, su continuación mantenida.
  - `sqflite`: **rechazado** para esta iteración; no funciona en web sin
    `sqflite_common_ffi_web` y la máquina no tiene Android SDK para verificar la
    app nativa. La interfaz de repositorio deja abierta la migración a SQLite.
  - Borrar tareas en cascada al eliminar un curso: **rechazado**; se bloquea el
    borrado y se explica el motivo para no perder trabajo.
  - Notificaciones del sistema, freemium real, sincronización en la nube y PDF:
    **fuera de esta entrega**. Se documentan como pendientes; la UI no simula
    compras ni avisos que no existen.
  - El primer test del flujo usaba `pageBack()`, que no reconoce el botón con
    localización española; se cambió a `find.byType(BackButton)`.
- **Verificación:** `dart format --output=none --set-exit-if-changed .` → sin
  cambios; `flutter analyze` → **No issues found**; `flutter test` → **25
  pruebas en verde**; `flutter build web` → **Built build\web**.
- **Versión:** MINOR → `1.1.0+2` (funcionalidad nueva compatible: persistencia y
  pantallas conectadas).
- **Commit:** rama `feature/v1.1.0-persistencia-tareas`;
  `feat(app): persistir tareas y conectar el flujo completo`.
- **Pendiente / siguiente paso:** notificaciones locales, límite freemium con
  Premium real, sync/PDF, icono definitivo y prueba en dispositivo físico.

---

## 2026-10-28 · @jjemd101191 — completar el Laboratorio S15

- **Herramienta:** Claude Code (asistente de código).
- **Especificación:** "Verifica qué falta del Laboratorio S15 y completa la carpeta
  del laboratorio con filtro inmutable, estados de UI, borrar con Deshacer y sus
  pruebas, con commits atómicos y un PR con la plantilla."
- **Resultado:** `MovementFilter` inmutable, `MovementFilterNotifier`,
  `filteredMovementsProvider` con `ref.watch`, estados de carga/error/vacío/datos,
  `Dismissible` con `key = id` y `SnackBar` de Deshacer, diez pruebas y un job de
  CI para la carpeta del laboratorio.
- **Aceptado:** repositorio en memoria con `Future.delayed` (la S15 lo permite);
  borrar primero en el repositorio y devolver `false` desde `confirmDismiss` si
  falla; restaurar el mismo objeto con el mismo `id` en su posición original.
- **Rechazado / corregido:** duplicar el trabajo en `Proyecto final`, que ya tiene
  su propio filtro y borrado; añadir una base de datos nueva, porque la
  persistencia entre cierres completos queda fuera del alcance y se documenta
  como limitación.
- **Verificación:** `dart format lib test` sin cambios pendientes; `flutter analyze`
  sin observaciones; `flutter test` con 10 pruebas en verde.
- **Commit / PR:** rama `feat/s15-filtro-estados-borrado` con cuatro commits
  (estados, filtro, borrado/Deshacer y CI) más el de documentación.

---

## 2026-10-24 · @usuario (Pareja B) — filtro de cursos y borrar/deshacer

- **Herramienta:** Codex.
- **Especificación:** aplicar los roles 3 y 4 del laboratorio al proyecto UniTasks, conservar la estructura y el estilo actual, limitar los cambios al trabajo de la pareja y no crear commits ni operar GitHub.
- **Resultado:** filtro de búsqueda por curso/docente con estado inmutable; cursos con id estable; borrado por deslizamiento y desde el menú con restauración del mismo registro mediante «Deshacer».
- **Aceptado:** borrar en el repositorio antes de retirar la fila; `confirmDismiss` devuelve la fila si el repositorio falla; `ValueKey(curso.id)` identifica cada fila.
- **Rechazado / corregido:** no se añadió una base de datos nueva; el laboratorio permite usar una lista en memoria si la app todavía no tiene base local. Por eso el borrado se conserva mientras vive el repositorio, pero no sobrevive al cierre completo del proceso.
- **Verificación:** `dart format .` completado; `flutter test --no-pub` → 10 pruebas en verde. `dart analyze` mostró “No issues found!”, aunque devolvió código 1; `flutter analyze` no concluyó porque el servidor de análisis salió con código `-1073741816`.
- **Commit / PR:** pendientes para el estudiante; no se creó commit ni PR.

---

## 2026-10-18 · @usuario (Integrante X) — pantalla 2 · formulario de registro/edición de tarea

- **Herramienta:** OpenCode (agente de código, GLM).
- **Especificación:** "Implementa mi parte del proyecto: la pantalla 2 (formulario de registro /
  nueva tarea) del Proyecto final, con el estilo de los módulos ya hechos y la paleta Lagoon
  (26798E, 63CAA7, FFC172, FFE3B3) solo en mi pantalla. No rompas nada: agrega lo mío, verifica
  con formato/análisis/pruebas y prepáralo para pull request."
- **Resultado:** `lib/screens/task_form_screen.dart` con modo crear y editar (siguiendo el patrón
  del 4C), constantes Lagoon en `theme.dart`, FAB «+» en la pestaña Inicio, lápiz del detalle 4A
  conectado al modo edición, pruebas nuevas en `test/task_form_screen_test.dart` y sección en el
  README.
- **Aceptado:** validación de título obligatorio igual que en el formulario de cursos; el
  formulario devuelve la `Task` por `Navigator.pop`; la paleta Lagoon se agregó como constantes
  nuevas sin modificar el tema global.
- **Rechazado / corregido:**
  - Cambiar el tema global a Lagoon: **rechazado**, repintaría las pantallas del módulo 4 de otros
    compañeros; queda como decisión pendiente del equipo.
  - Agregar el paquete `intl` para formatear fechas: **rechazado**, el pubspec no depende de él;
    se hizo un helper propio con días y meses en español.
  - Incluir subtareas en el formulario: **rechazado** de común acuerdo; el detalle 4A ya permite
    gestionarlas y el formulario queda enfocado en registrar la tarea.
  - El agente dejó un parámetro sin usar en la pantalla anfitriona de la prueba; `dart analyze` lo
    marcó y se corrigió antes del commit.
- **Verificación:** `dart format --output=none --set-exit-if-changed .` → 16 archivos, 0 cambios;
  `dart analyze` → sin observaciones; `flutter test` → 6 pruebas en verde (3 existentes + 3
  nuevas).
- **Commit / PR:** PR #<!-- número -->

---

## 2026-10-15 · @jjemd101191 (Integrante 2) — verificación de la Parte A y revisión del PR de estados

- **Herramienta:** Claude Code (asistente de código).
- **Especificación:** "Verifica si los entregables ya están realmente en `main` y si `main` está
  protegida; revisa el PR de la pareja (pantalla de cursos con estados) y dime qué se rompería
  antes de mergear. **No cambies el comportamiento de la pantalla.**"
- **Resultado:** confirmó por la API de GitHub que los runs del CI están en verde, encontró que
  `main` acepta pushes directos (no hay ruleset configurado) y señaló dos defectos en el PR.
- **Aceptado:** el hallazgo de que `DemoCourseRepository` devuelve la lista global `cursosDemo`
  **por referencia** y que la pantalla la muta con `add`, `remove` y `sort`.
- **Rechazado / corregido durante la revisión:**
  - Se propuso editar `course_list_screen.dart` para copiar la lista al recibirla. **Rechazado:**
    el laboratorio no pide cambios de comportamiento en esa pantalla y es código de otra pareja.
    El hallazgo quedó como comentario de revisión para que lo corrija quien lo escribió.
  - `flutter analyze` **falla en Windows** (`FormatException` en el cliente LSP, `exit 255`),
    mientras `dart analyze` responde `No issues found!` y el CI en Ubuntu pasa en verde. Se
    rechazó la conclusión "el análisis está roto": el código está limpio, lo que está roto es
    el comando local. Se usó `dart analyze` como reemplazo para verificar en la máquina.
  - Se descartó automatizar la configuración del ruleset y la edición de PRs por API: habría
    requerido credenciales de la cuenta. Se hizo a mano en el navegador, que además deja la
    captura que pide la rúbrica.
- **Verificación:** `dart format --output=none --set-exit-if-changed .` → 12 archivos, 0
  cambios; `flutter test` → 3 pruebas en verde; runs del CI #1 a #8 en `success`.
- **Commit / PR:** PR #3 (Parte A) y comentario de revisión en el PR #4 (Parte B).

---

## 2026-10-15 · @jjemd101191 (Integrante 2) — plantillas de PR, CODEOWNERS y bitácora

- **Herramienta:** Claude Code (asistente de código).
- **Especificación:** "Traer desde `saulecch/inkash` (tag `s14-06-ci`) la plantilla de Pull
  Request, el `CODEOWNERS` y el formato de `docs/bitacora-ia.md`, y adaptarlos a UniTasks:
  cambiar los usuarios de ejemplo por los del equipo, quitar lo específico de inkash y no
  inventar archivos que el laboratorio no pide."
- **Resultado:** los tres archivos quedaron en `.github/` y `docs/`, con el checklist ajustado
  al stack de UniTasks (Flutter) y los usuarios reales del equipo.
- **Aceptado:** la estructura de la plantilla (Qué cambia · Cómo probarlo · Capturas ·
  Checklist · Para quien revisa), la tabla de campos de la bitácora y la idea de que la
  columna "Rechazado / corregido" es la que demuestra criterio.
- **Rechazado / corregido durante la revisión:**
  - El checklist original pedía "Dinero en centavos `int`, nunca `double`" y advertía que
    sqflite no funciona en Web: son reglas de inkash (app de finanzas), no de UniTasks.
    Se reemplazaron por verificaciones propias del proyecto.
  - El `CODEOWNERS` de referencia apuntaba a `@saulecch` y a rutas (`/lib/core/`, `/docs/adr/`)
    que en este repo todavía no existen; se cambió a los usuarios del equipo.
  - La entrada de ejemplo de la bitácora era del docente y no del equipo: se eliminó para no
    presentar trabajo ajeno como propio y se dejó el formato vacío más la entrada real.
- **Verificación:** revisión de los tres archivos contra lo que pide la Parte A del
  laboratorio; el workflow lo valida el CI con `flutter analyze` y `flutter test`.
- **Commit / PR:** commit `b43b9fa`, integrado en `main` con Squash and merge en el PR #3.

---
