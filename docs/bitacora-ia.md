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
