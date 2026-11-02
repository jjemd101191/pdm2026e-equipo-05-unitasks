# Validación con personas reales - TaskU

Responsable: Adrián Pablo Girón Franco (@PabloFranco777), UX / Investigación.
Estado al 2026-11-01: **pendiente de ejecutar; 0 de 3 personas documentadas**.
El recorrido automatizado de Codex y la revisión técnica de JM NO se cuentan como tres participantes. Los espacios siguientes son sesiones reservadas, no personas inventadas. No publicar nombres, imágenes ni citas sin autorización; un alias acordado es suficiente.

## Protocolo breve (10 a 15 minutos por persona)

Usar la app integrada en un teléfono o emulador preparado por QA; si se usa navegador, registrarlo. Confirmar que acepta participar y tomar notas. Explicar que se evalúa la app, no a la persona. No introducir datos sensibles. Permitir que intente las tareas sin explicarle primero dónde tocar; registrar ayudas y dificultades.

1. Encontrar una tarea usando el buscador o un filtro.
2. Crear un compromiso con título y curso; intentar guardar sin título para observar la validación, después completarlo.
3. Abrir el detalle, editar un dato y regresar al listado.
4. Eliminar el compromiso de prueba y recuperarlo con Deshacer, si la acción lo ofrece.
5. Abrir Perfil y explicar qué cree que representan los conteos y dónde se guardan sus datos.
6. Preguntar qué fue confuso y qué cambiaría. Anotar sus palabras con permiso, sin inventar citas.

## Registro de sesiones (sin ejecutar)

| Sesión reservada | Alias autorizado / fecha / dispositivo | Qué intentó | Qué ocurrió / ayuda / pasos | Qué falló o confundió | Sugerencia | Cambio y PR que lo arregla | Revalidación |
|---|---|---|---|---|---|---|---|
| U01, pendiente | Pendiente | Pendiente | Pendiente | Pendiente | Pendiente | Sin PR asociado | Pendiente |
| U02, pendiente | Pendiente | Pendiente | Pendiente | Pendiente | Pendiente | Sin PR asociado | Pendiente |
| U03, pendiente | Pendiente | Pendiente | Pendiente | Pendiente | Pendiente | Sin PR asociado | Pendiente |

## Hallazgos técnicos previos (no son hallazgos de usuarios)

- Perfil presentaba Diego Morales y DM como identidad fija. Cambio UX: Perfil local y un icono neutro.
- Perfil ocultaba fallos de lectura y podía mostrar ceros engañosos. Cambio UX: mensaje de error y Reintentar; no muestra conteos como si la lectura hubiera tenido éxito.
- El arranque fallido pedía cerrar y abrir la aplicación. Cambio UX: Reintentar en la misma pantalla, con indicador de apertura y sin borrar datos.
- Perfil vacío ahora orienta a empezar por Cursos.

PR de estos cambios: pendiente de creación por el estudiante. No afirmar que provienen de entrevistas: están asignados en el plan del equipo y comprobados técnicamente.

## Para completar el requisito

Ejecutar las tres sesiones, conservar evidencia autorizada, elegir al menos una dificultad observada y corregirla en un PR propio revisado por otro integrante. Relacionar cada hallazgo con el PR real y repetir la tarea con la persona o registrar la limitación. Aunque no haya fallos en una sesión, documentar lo que intentó y el resultado real.
