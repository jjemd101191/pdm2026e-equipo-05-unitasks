# Guion de UX - Pablo / TaskU

Responsable: Adrián Pablo Girón Franco (@PabloFranco777).
La exposición de UniTasks está programada el jueves 5 de noviembre, 09:22-09:37, según Proyecto_Exposicion_5nov_E.pdf. Las 08:15 corresponden al parcial. El recorrido es una propuesta para coordinar con los otros integrantes; nadie está obligado a seguir tiempos no acordados.

## Propuesta de recorrido del equipo (6 minutos)

| Tiempo | Mostrar | Responsable sugerido |
|---|---|---|
| 0:00-0:40 | Problema académico y usuario; mencionar solo validaciones realmente realizadas | Pablo |
| 0:40-2:00 | Buscar tarea y crear una nueva; explicar título obligatorio y selección de curso | Demy |
| 2:00-3:00 | Abrir detalle, cambiar estado y mostrar confirmación; borrar una tarea de prueba y Deshacer | Equipo, acordar narrador |
| 3:00-4:00 | Recorrido pantalla → repositorio → DAO → SQLite y migración v2 | Juan |
| 4:00-5:00 | Persistencia, prueba de migración y pruebas Android realmente ejecutadas | Marco |
| 5:00-6:00 | Perfil local, carga/vacío/error y recuperación; cambio originado en usuarios SOLO después de completar usuarios.md | Pablo |

Preparar datos de prueba con QA antes de la exposición. No borrar información de un usuario real durante la demo. El estado de arranque fallido se demuestra con la prueba automatizada, sin corromper ni borrar la base real.

## Tu explicación individual

- Qué cambié: identidad ficticia de Perfil por un perfil local neutro; carga explícita, orientación de vacío, error recuperable en Perfil y botón de reintento al abrir los datos.
- Por qué: no atribuirle al usuario un nombre ajeno, no mostrar cero cuando la consulta falla y permitir recuperarse sin cerrar la app.
- Cómo funciona Perfil: consulta los mismos repositorios existentes; solo publica los conteos cuando ambas consultas terminan. Si fallan, muestra el estado compartido EstadoVista y Reintentar vuelve a consultar.
- Cómo funciona el arranque: TaskUStartup abre y verifica la base existente. Si falla, cierra la conexión fallida y ofrece otro intento con una conexión nueva. No elimina archivos ni cambia migraciones. Al abrir bien, entrega la misma base a los providers de JM.
- Qué pasaría si se quitara el manejo de error: un fallo de lectura parecería un perfil sin tareas; el usuario no tendría una salida directa.
- Qué protegen las pruebas: conteos, ausencia de identidad fija, carga, vacío, fallo de cursos y tareas, recuperación, fallos repetidos y salida durante una consulta; arranque fallido y reintento con instancia nueva.
- Límite: un error persistente del almacenamiento no se arregla solo por tocar Reintentar; la interfaz lo vuelve a mostrar y no borra datos para ocultarlo.

## Flujos cortos

Inicio → +: un toque para abrir el formulario; Guardar: segundo toque, además de completar los campos. Desde Inicio, tocar tarea abre su detalle en un toque. Perfil se abre desde la pestaña en un toque. No prometer que todo el proceso usa menos de tres toques: elegir fecha, curso o confirmar borrado puede necesitar más.

## Tu parte pendiente fuera del código

- Completar las tres sesiones reales de docs/usuarios.md y una mejora atribuible a ellas.
- Crear tus issues y tu PR; pedir revisión y resolver observaciones. No inventar enlaces ni atribuirte PRs de compañeros.
- Revisar un PR ajeno y dejar un comentario concreto después de leer su diff. Este documento no equivale a una revisión publicada.
- Coordinar con Juan el cambio pequeño de main.dart antes de fusionar y con Marco las pruebas en teléfono.
- Adjuntar las capturas del README y comprobar que el código mostrado esté integrado en main antes del 4 de noviembre a las 23:59. El PR #25 ya se fusionó; la aprobación formal de otro integrante quedó pendiente.

## Títulos y criterios para tus issues (borradores, no publicados)

1. **UX: Perfil local y recuperación de errores.** Aceptar cuando Perfil no muestre identidad ficticia, diferencie carga/vacío/error, permita reintentar y el arranque fallido ofrezca un nuevo intento sin borrar datos. Código y ocho pruebas integrados en `main` con el PR #25; la revisión formal de otro integrante quedó pendiente.
2. **UX: validar TaskU con tres personas reales.** Aceptar cuando docs/usuarios.md registre alias autorizado, tarea intentada, hallazgo, evidencia y resultado de tres sesiones; asociar al menos una mejora a su PR real y revalidarla. Pendiente.
3. **UX: evidencia visual y recorrido de exposición.** Aceptar cuando el README muestre las cuatro capturas a 390 x 844 y el equipo acuerde el recorrido de seis minutos. Capturas y propuesta local listas; ensayo con el equipo pendiente.

Para revisar un PR ajeno: leer su diff, intentar reproducir el flujo que modifica y comentar una observación concreta (archivo/acción, comportamiento observado y resultado esperado). No pegar una aprobación genérica sin revisar. No se publicó ninguna revisión en nombre del usuario.
