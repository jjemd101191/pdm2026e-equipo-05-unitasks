# Unitasks - Equipo 05

Bienvenido al repositorio oficial del **Equipo 05** para el proyecto Unitasks (PDM 2026).

## Integrantes del Equipo

| Carnet | Nombre Completo |
| :---: | :--- |
| **202208011** | Juan José Efraín Martínez Delgado |
| **202308063** | Demy Brictany De León Figueroa |
| **202308022** | Marco Pablo Sigüenza Orozco |
| **202308036** | Adrián Pablo José Girón Franco |

## La aplicación (TaskU)

App móvil en **Flutter** para el seguimiento estructurado de compromisos académicos (tareas, exámenes y proyectos): registro rápido, recordatorios, funciona sin conexión (SQLite/Hive) y modelo freemium (gratis hasta 3 tareas activas; Premium con sincronización en la nube, sin anuncios y exportación a PDF).

## Módulo de pantallas 4 — Detalle de tarea y gestión de cursos

Este avance implementa las tres pantallas del módulo 4, basadas en el mockup aprobado por el equipo:

| Pantalla | Archivo | Qué hace |
|---|---|---|
| 4A · Detalle de tarea | `lib/screens/task_detail_screen.dart` | Chips de curso, prioridad y tipo; fecha de entrega; recordatorio; estado con % de avance; descripción; subtareas con barra de progreso (marcar y agregar); completar/reabrir y eliminar tarea. |
| 4B · Gestión de cursos | `lib/screens/course_list_screen.dart` | Filtros (Todos · 2026-2 · Con pendientes), resumen del semestre con anillo de avance, tarjetas de curso (color, docente, horario, pendientes), menú ⋮ con editar/eliminar, ordenar por pendientes y botón + para agregar. |
| 4C · Registrar/editar curso | `lib/screens/course_form_screen.dart` | Formulario con nombre, docente, color, días de clase, hora (selector de Material en español) y periodo; valida y devuelve el curso guardado. |

### Estructura

- `lib/main.dart` — punto de entrada (tema, idioma español).
- `lib/theme.dart` — colores de la marca y tema Material 3.
- `lib/models/` — `course.dart` (Course) y `task.dart` (Task, Subtask).
- `lib/data/demo_data.dart` — datos de ejemplo (en la versión final: SQLite/Hive).
- `lib/widgets/` — `info_chip.dart` y `primary_button.dart` (reutilizables).
- `lib/screens/home_shell.dart` — pestañas Inicio · Calendario · Cursos · Perfil; las pestañas ajenas al módulo 4 son marcadores de posición.

## Cómo ejecutar

```bash
flutter pub get
flutter run            # con un emulador o teléfono conectado
flutter run -d chrome  # o directo en el navegador
```

Para ver el módulo 4: la app abre en la pestaña **Cursos** (4B); el detalle de tarea (4A) se abre desde la tarjeta de ejemplo en **Inicio**, y el formulario de curso (4C) con el botón **+** o desde ⋮ → Editar curso.

## Verificación

- `dart analyze` → sin observaciones.
- `flutter test` → pruebas en verde.

> Nota: los datos son de demostración en memoria; la persistencia (SQLite/Hive) y
> la integración con las pantallas 1–3 del resto del equipo quedan pendientes.
