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
| 5:00-6:00 | Perfil local, carga/vacío/error; «Deshacer» al eliminar una tarea (hallazgo U03). Aclarar que U01 y U02 no reportaron fricción. | Pablo |

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

## Estado para la demo

- Las tres sesiones reales quedaron documentadas en `docs/usuarios.md` y en las hojas `U01–U03`.
- La mejora derivada de U03 («Deshacer» al eliminar una tarea) está en el PR #31, fusionado en `main`; la aprobación quedó registrada.
- La issue #30 enlaza el hallazgo con el PR #31.
- Falta revalidar con U03 en el APK 1.2.1 y ensayar el recorrido completo con el equipo.

## Checklist para la demo del 5 de noviembre

- [ ] Instalar `TaskU-1.2.1.apk` en el teléfono y comprobar que abre con datos de prueba.
- [ ] Probar una vez: eliminar una tarea → «Deshacer» → la tarea vuelve con sus subtareas.
- [ ] Tener GitHub abierto en el PR #31, las Actions y la issue #30.
- [ ] Ensayar el recorrido de 6 minutos con los responsables de cada bloque.
- [ ] No afirmar que U01 o U02 validaron el «Deshacer»: la fricción y la mejora son de U03.
- [ ] No prometer notificaciones del sistema, papelera, nube, PDF ni Premium como funciones de esta entrega.

## Títulos y criterios para tus issues (borradores, no publicados)

1. **UX: Perfil local y recuperación de errores.** Aceptar cuando Perfil no muestre identidad ficticia, diferencie carga/vacío/error, permita reintentar y el arranque fallido ofrezca un nuevo intento sin borrar datos. Código y ocho pruebas integrados en `main` con el PR #25; la revisión formal de otro integrante quedó pendiente.
2. **UX: validar TaskU con tres personas reales.** Aceptar cuando docs/usuarios.md registre alias autorizado, tarea intentada, hallazgo, evidencia y resultado de tres sesiones; asociar al menos una mejora a su PR real y revalidarla. **Hecho:** U01, U02 y U03 documentadas; mejora en la issue #30 y el PR #31. Falta revalidar con U03 en el APK 1.2.1.
3. **UX: evidencia visual y recorrido de exposición.** Aceptar cuando el README muestre las cuatro capturas a 390 x 844 y el equipo acuerde el recorrido de seis minutos. Capturas y propuesta local listas; ensayo con el equipo pendiente.

Para revisar un PR ajeno: leer su diff, intentar reproducir el flujo que modifica y comentar una observación concreta (archivo/acción, comportamiento observado y resultado esperado). No pegar una aprobación genérica sin revisar. No se publicó ninguna revisión en nombre del usuario.
