# Validación con personas reales - TaskU

Responsable: Adrián Pablo Girón Franco (@PabloFranco777), UX / Investigación.
Estado al 2026-11-04: **3 de 3 sesiones documentadas**. Las sesiones se realizaron con el APK 1.2.0 instalado en un teléfono Android del equipo. La fecha, la hora, el modelo del teléfono y el facilitador no quedaron registrados en las notas; se escriben como «no registrado».
El kit de facilitación, con guion, tareas y hoja de notas, está en [usuarios-kit.md](usuarios-kit.md).
El recorrido automatizado de Codex y la revisión técnica de JM NO se cuentan como tres participantes. Los alias son los acordados con el equipo; no se publican nombres, imágenes ni citas sin autorización.

## Protocolo breve (10 a 15 minutos por persona)

Usar la app integrada en un teléfono o emulador preparado por QA; si se usa navegador, registrarlo. Confirmar que acepta participar y tomar notas. Explicar que se evalúa la app, no a la persona. No introducir datos sensibles. Permitir que intente las tareas sin explicarle primero dónde tocar; registrar ayudas y dificultades.

1. Encontrar una tarea usando el buscador o un filtro.
2. Crear un compromiso con título y curso; intentar guardar sin título para observar la validación, después completarlo.
3. Abrir el detalle, editar un dato y regresar al listado.
4. Eliminar el compromiso de prueba y recuperarlo con Deshacer, si la acción lo ofrece.
5. Abrir Perfil y explicar qué cree que representan los conteos y dónde se guardan sus datos.
6. Preguntar qué fue confuso y qué cambiaría. Anotar sus palabras con permiso, sin inventar citas.

## Registro de sesiones (3/3)

| Sesión | Alias / fecha / dispositivo | Qué intentó | Qué ocurrió / ayuda / pasos | Qué falló o confundió | Sugerencia | Cambio y PR que lo arregla | Revalidación | Evidencia |
|---|---|---|---|---|---|---|---|---|
| U01 | Moises / fecha no registrada / teléfono Android del equipo con APK 1.2.0 | Crear curso, crear tarea, buscar y editar, completar, calendario, eliminar y recuperar, perfil | Completé las siete actividades sin ayuda; 5/5 en cada una. Reportó haber recuperado la tarea con «la opción disponible», pero no se registró el paso exacto. | Ninguna | Ninguna | Sin cambio: no hubo fricción | No aplica | `docs/evidencia/U01.md` |
| U02 | Carlitos / fecha no registrada / teléfono Android del equipo con APK 1.2.0 | Las siete actividades del kit | Completé todas sin ayuda; 5/5. Describió el Perfil con conteos, plan y versión. | Ninguna | Ninguna | Sin cambio: no hubo fricción | No aplica | `docs/evidencia/U02.md` |
| U03 | U03 (alias no proporcionado) / fecha no registrada / teléfono Android del equipo con APK 1.2.0 | Crear curso y tarea, editar, completar, eliminar y recuperar, perfil | Crear, editar, completar y eliminar: 5/5. Recuperar la tarea eliminada: 2/5; no encontró la opción. Calendario: no registrado. | Recuperar una tarea; esperaba una papelera. También pidió notificaciones del sistema. | Papelera de eliminados y notificaciones | SnackBar «Deshacer» al eliminar una tarea, con restauración del mismo id, subtareas y recordatorio. Issue [#30](https://github.com/jjemd101191/pdm2026e-equipo-05-unitasks/issues/30); PR pendiente de enlazar. | Pendiente: repetir la tarea con U03 en el APK 1.2.1; la mejora tiene prueba automatizada. | `docs/evidencia/U03.md` |

### Evidencia por sesión

Cada sesión tiene una hoja en `docs/evidencia/U01.md`, `U02.md` y `U03.md`. Se llenó con las notas reales del equipo, nunca antes de la sesión.

- La hoja registra alias, fecha, dispositivo, tareas, fricción, cita autorizada, mejora y PR.
- No se guardan nombres reales, imágenes ni audios dentro del repositorio. Si hay audio o foto, se conserva fuera y se anota «disponible con consentimiento».
- La evidencia principal para el docente es esta tabla, la hoja fechada y el PR de la mejora. La app no guarda un historial de sesiones y no lo necesita.
- Si una sesión no tuvo fallos, se documenta igual: qué intentó y qué resultado obtuvo.
- Si un dato no se registró, se escribe «no registrado». No se completa por suposición.

## Hallazgos de las sesiones

- **U01 y U02 no reportaron fricción.** Ambos calificaron la facilidad de uso con 5/5 y la app con 10/10. Sus respuestas no justifican un cambio por sí solas.
- **U03 no pudo recuperar una tarea eliminada (2/5).** Después de confirmar «Eliminar tarea», volvió al listado y no encontró una acción visible para recuperarla. Esperaba una papelera y pidió notificaciones del sistema. Calificó la app con 9.5/10.
- **Mejora aplicada:** al eliminar una tarea, Inicio muestra «Tarea eliminada» con la acción «Deshacer». La restauración conserva el id, las subtareas y el recordatorio. Está cubierta por `test/task_flow_test.dart` y registrada en la issue [#30](https://github.com/jjemd101191/pdm2026e-equipo-05-unitasks/issues/30).
- **Limitación registrada:** U03 todavía no repitió la tarea con el APK 1.2.1. No se afirma revalidación hasta que ocurra.
- **Dato inconsistente:** U01 reportó haber recuperado una tarea, pero la versión 1.2.0 solo ofrecía «Deshacer» para cursos, no para tareas. No se registró el paso exacto; se conserva la respuesta textual y no se usa como prueba de la función.

## Hallazgos técnicos previos (no son hallazgos de usuarios)

- Perfil presentaba Diego Morales y DM como identidad fija. Cambio UX: Perfil local y un icono neutro.
- Perfil ocultaba fallos de lectura y podía mostrar ceros engañosos. Cambio UX: mensaje de error y Reintentar; no muestra conteos como si la lectura hubiera tenido éxito.
- El arranque fallido pedía cerrar y abrir la aplicación. Cambio UX: Reintentar en la misma pantalla, con indicador de apertura y sin borrar datos.
- Perfil vacío ahora orienta a empezar por Cursos.

PR de estos cambios: [#25](https://github.com/jjemd101191/pdm2026e-equipo-05-unitasks/pull/25), fusionado en `main` como `3962af4`. No afirmar que provienen de entrevistas: están asignados en el plan del equipo y comprobados técnicamente.

## Estado del requisito

El requisito de tres personas reales queda cubierto con U01, U02 y U03. La mejora derivada de U03 está implementada y probada; falta enlazar el PR, fusionarlo y revalidar con U03. La papelera completa y las notificaciones del sistema quedan como trabajo futuro, no como parte de esta entrega.
