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
- **Commit / PR:** pendiente (rama `chore/ci`).
