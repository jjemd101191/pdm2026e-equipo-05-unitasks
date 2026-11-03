# Kit para las 3 sesiones de validación · TaskU

**Objetivo:** ejecutar tres sesiones reales de 10–15 minutos, documentar qué intentó cada persona, qué falló y qué mejora sale de ahí.
**Quién facilita:** cualquier integrante del equipo. Lo importante es que las tres personas sean **externas al equipo** y que no se inventen resultados.
**Dónde:** teléfono o emulador con la app instalada. Si no hay Android, usa la versión web en Edge/Chrome a 390 × 844 y **regístralo como limitación**.
**Tiempo total:** ~1 hora para las tres sesiones y las notas.

---

## 1. Antes de empezar

- [ ] App abierta y con datos de prueba (cursos y tareas de ejemplo).
- [ ] Tres personas confirmadas, idealmente de otro curso o carrera.
- [ ] Cronómetro y esta hoja de notas a mano.
- [ ] Confirmar que aceptan participar y que se tomarán notas.
- [ ] Acordar un alias; no usar nombres reales, datos personales ni capturas sin permiso.

**Frase de apertura (30 s):**

> «Gracias por ayudarme. Estamos probando TaskU, una app para organizar tareas de la universidad. No te estoy evaluando a ti: quiero ver si la app se entiende. Voy a pedirte que hagas unas tareas y tomaré notas. ¿Estás de acuerdo? Podemos usar un alias y no necesitas escribir datos personales reales.»

**Regla de oro:** no expliques dónde tocar. Si la persona se bloquea, anota cuándo y por qué; ayuda solo después de 20–30 segundos.

---

## 2. Tareas (10–15 min)

Hazlas en este orden, pero deja que la persona explore.

| # | Petición al participante | Qué observar |
|---|---|---|
| 1 | «Encuentra una tarea usando el buscador o un filtro.» | ¿Encuentra el buscador? ¿Entiende los filtros? ¿Usa la barra o los chips? |
| 2 | «Crea un compromiso con título y curso. Intenta guardarlo sin título y luego complétalo.» | ¿Ve la validación? ¿Entiende el selector de curso y la fecha? |
| 3 | «Abre el detalle de esa tarea, edita un dato y regresa al listado.» | ¿Encuentra el detalle? ¿El cambio se guarda? ¿Se pierde al volver? |
| 4 | «Elimina el compromiso de prueba y recupéralo con Deshacer, si aparece.» | ¿Descubre el gesto? ¿Ve el aviso de Deshacer? ¿Lo usa? |
| 5 | «Abre Perfil y explícame qué crees que significan los conteos y dónde se guardan tus datos.» | ¿Entiende «local»? ¿Los conteos coinciden con lo que vio? |
| 6 | «¿Qué fue confuso? ¿Qué cambiarías?» | Anota sus palabras textuales, con permiso. |

**No cuentes como sesión** una prueba automatizada, una revisión de código ni una conversación con un integrante del equipo.

---

## 3. Hoja de notas por sesión

Copia este bloque para U01, U02 y U03.

```markdown
### U0X

- Alias acordado:
- Fecha y hora:
- Dispositivo / navegador / tamaño:
- Facilitador:
- ¿Aceptó participar y se pueden tomar notas?:
- ¿Usó datos reales? (debe ser no):

| Tarea | Resultado (logrado / con ayuda / no logrado) | Pasos y ayudas |
|---|---|---|
| 1. Buscar o filtrar | | |
| 2. Crear y validar título | | |
| 3. Editar en detalle | | |
| 4. Eliminar y Deshacer | | |
| 5. Perfil y datos locales | | |
| 6. Pregunta abierta | | |

- Fricción principal (pantalla y momento):
- ¿Se repitió en otra tarea?:
- Cita textual (con permiso):
- Sugerencia de la persona:
- Mejora propuesta por el equipo:
- ¿Se puede probar con una prueba de widget o requiere dispositivo?:
```

---

## 4. Después de las tres sesiones

1. **Elige una sola fricción.** Prioriza la que se repitió en al menos dos sesiones o la que bloqueó una tarea.
2. **Define el cambio mínimo:** un texto, un botón, el orden de un campo, un estado vacío o un mensaje de error.
3. **Abre una rama** `fix/ux-<tema>`, implementa el cambio y agrega una prueba si aplica.
4. **Abre el PR** con: qué observaste, en qué sesión, qué cambiaste y cómo lo verificaste.
5. **Actualiza `docs/usuarios.md`** con las tres filas reales y el enlace al PR.
6. **Revalida** con al menos una persona si es posible; si no, registra la limitación.

**No inventes citas, nombres ni resultados.** Si una sesión no tuvo fallos, documenta lo que intentó y el resultado real; eso también es evidencia.

---

## 5. Qué enviarme para documentarlo

Pásame, por cada sesión:

- Alias, fecha y dispositivo/navegador.
- Resultado de las 6 tareas (logrado / con ayuda / no logrado).
- La fricción principal y en qué pantalla ocurrió.
- Una cita textual autorizada (o «sin cita»).
- La mejora que propones.

Con eso lleno `docs/usuarios.md`, redacto el PR y dejo la evidencia lista. Si prefieres, puedo preparar primero el texto del issue de la mejora.

---

## 6. Cómo abrir la app ahora

En la carpeta `Proyecto final`:

```bash
flutter run -d edge
# o, si tienes Chrome:
flutter run -d chrome
```

Para simular un teléfono en Edge/Chrome: abre DevTools (F12) → activa el modo dispositivo → elige 390 × 844. Anótalo como «web, 390 × 844» en la hoja.

Si consigues un Android con depuración USB o un emulador, usa `flutter run` y regístralo como Android. En esta máquina no hay Android SDK, así que el APK no se puede compilar aquí.
