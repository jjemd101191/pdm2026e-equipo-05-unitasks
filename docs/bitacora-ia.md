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
