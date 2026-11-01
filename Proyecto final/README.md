# Unitasks - Equipo 05

Bienvenido al repositorio oficial del **Equipo 05** para el proyecto Unitasks (PDM 2026).

## Integrantes del Equipo

| Carnet | Nombre Completo |
| :---: | :--- |
| **202208011** | Juan José Efraín Martínez Delgado |
| **202308063** | Demy Brictany De León Figueroa |
| **202308022** | Marco Pablo Sigüenza Orozco |
| **202308036** | Adrián Pablo Girón Franco |

## TaskU · la aplicación

App en **Flutter** para el seguimiento de compromisos académicos (tareas, exámenes y proyectos): registro rápido, agenda, recordatorios dentro de la app y **persistencia local** en el dispositivo. La app funciona sin conexión y no envía datos a ningún servidor.

**Versión actual: 1.1.0** (`pubspec.yaml` → `1.1.0+2`).

### Qué funciona hoy

| Pantalla | Archivo | Qué hace |
|---|---|---|
| 1 · Pendientes (`Inicio`) | `lib/screens/task_list_screen.dart` | Lista real de tareas guardadas, filtros Pendientes/Todas/Completadas, resumen y avance, marca rápida como completada, recordatorios vencidos dentro de la app y botón + para registrar. |
| 2 · Nueva / editar tarea | `lib/screens/task_form_screen.dart` | Título obligatorio, curso, tipo, prioridad, fecha y hora, recordatorio y descripción. El mismo formulario crea y edita. |
| 3 · Calendario | `lib/screens/calendar_screen.dart` | Mes navegable, días con entregas, agenda del día seleccionado y acceso al detalle. |
| 4A · Detalle de tarea | `lib/screens/task_detail_screen.dart` | Chips de curso, prioridad y tipo; fecha, recordatorio y estado; descripción; subtareas con progreso; completar/reabrir, editar y eliminar. **Cada cambio se guarda al instante.** |
| 4B · Gestión de cursos | `lib/screens/course_list_screen.dart` | Filtros (Todos · 2026-2 · Con pendientes), búsqueda local, resumen del semestre con anillo de avance, tarjetas con conteos calculados desde las tareas, editar, eliminar con «Deshacer» y agregar. |
| 4C · Registrar / editar curso | `lib/screens/course_form_screen.dart` | Nombre, docente, color, días, horario y periodo. |
| Perfil | `lib/screens/profile_screen.dart` | Datos de la cuenta local, conteos reales, aviso de que la información vive en el dispositivo y estado del plan. |

### Persistencia

- Motor: **Drift 2.35 sobre SQLite** (`drift` + `drift_flutter`). En móvil y escritorio abre `tasku.sqlite`; en web usa SQLite compilado a WASM.
- Esquema v2: `courses`, `tasks`, `subtasks` y `reminders`, con claves foráneas (`RESTRICT` de tareas hacia curso y `CASCADE` de subtareas y recordatorios) e índices por curso y fecha de entrega.
- El esquema se versiona con `schemaVersion`. La migración v1 → v2 agrega `courses.archivado` con valor por defecto `false` y está probada en `test/data/migracion_test.dart`.
- La primera apertura carga **datos de ejemplo** (4 cursos y 8 tareas) desde `seed_data.dart`, una sola vez, en `onCreate`.
- El recorrido completo (pantalla → repositorio → DAO → SQLite → stream → pantalla) está en la [ADR 0003](../docs/adr/0003-flujo-de-datos-y-migraciones.md).

### Reglas de negocio implementadas

- **Un curso con tareas no se puede eliminar.** Se avisa cuántas tareas tiene para no perder trabajo en cascada. Un curso vacío sí se elimina y se puede recuperar con «Deshacer».
- **Los pendientes y el avance se calculan** desde las tareas reales; el curso ya no guarda contadores escritos a mano.
- **Completar una tarea** marca también todas sus subtareas; desmarcar una subtarea reabre la tarea.
- **Los recordatorios se calculan** desde la fecha de entrega y se muestran dentro de la app cuando vencen. Las notificaciones del sistema todavía no están implementadas.

### Arquitectura

```
lib/
├── main.dart                 # arranque, base local y ProviderScope
├── theme.dart                # paleta y tema Material 3
├── models/
│   ├── course.dart           # Course (incluye archivado)
│   ├── course_summary.dart   # curso + pendientes/total calculados
│   ├── course_filter.dart    # filtro inmutable de cursos
│   └── task.dart             # Task, Subtask, enums y recordatorios
├── data/
│   ├── db/
│   │   ├── app_database.dart # esquema v2 y migraciones
│   │   ├── tablas.dart       # courses, tasks, subtasks, reminders
│   │   ├── cursos_dao.dart
│   │   └── tareas_dao.dart
│   ├── course_repository.dart
│   ├── task_repository.dart
│   ├── drift_course_repository.dart
│   ├── drift_task_repository.dart
│   └── seed_data.dart
├── providers/
│   └── providers.dart        # repositorios y listas reactivas (Riverpod)
├── screens/                  # Inicio, calendario, cursos, perfil y formularios
├── utils/                    # fechas en español e ids locales
└── widgets/                  # InfoChip, PrimaryButton, EstadoVista
```

La decisión de persistencia y sus consecuencias están documentadas en
[`../docs/adr/0002-persistencia-drift-riverpod.md`](../docs/adr/0002-persistencia-drift-riverpod.md).
El flujo de un dato y la migración v2, en
[`../docs/adr/0003-flujo-de-datos-y-migraciones.md`](../docs/adr/0003-flujo-de-datos-y-migraciones.md).

## Cómo ejecutar

```bash
cd "Proyecto final"
flutter pub get
flutter run            # emulador o teléfono conectado
flutter run -d chrome  # o en el navegador
```

En web, Drift usa SQLite compilado a WASM; para que arranque, `web/` debe
contener `sqlite3.wasm` y `drift_worker.js`. Hoy esos archivos todavía no están
en el repo, así que la demo se hace en Android/escritorio.

## Verificación

Resultados de esta versión:

- `dart format --output=none --set-exit-if-changed .` → sin cambios.
- `flutter analyze` → **No issues found**.
- `flutter test` → **58 pruebas en verde** (modelos, DAOs, repositorios,
  providers, migración v1 → v2, formularios, cursos y flujo completo
  crear → completar → editar → eliminar).
- `flutter build web` → compila correctamente.

El CI (`.github/workflows/ci.yml`) ejecuta formato, análisis, pruebas y
compilación web para `Proyecto final`.

## Pendiente / siguiente paso

| Tema | Estado |
|---|---|
| Notificaciones del sistema (Android/iOS) | Pendiente. Hoy los recordatorios se muestran dentro de la app. Requiere `flutter_local_notifications`, `timezone`, permisos y configuración por plataforma. |
| Freemium (límite de 3 tareas activas) | Pendiente. El Perfil muestra el plan, pero no hay compras ni bloqueo hasta que exista Premium. |
| Sincronización en la nube y exportación a PDF | Pendiente (funciones Premium). Requieren backend/auth y un generador de PDF. |
| Icono de la app | Sigue el icono por defecto de Flutter; falta el diseño final. |
| Pruebas en dispositivo físico | Pendiente de verificación por el equipo en Android/iOS. |

## Historial de módulos

- **Módulo 4** (4A detalle, 4B cursos, 4C formulario de curso) y **módulo 2**
  (formulario de tarea): base visual de esta versión.
- **Versión 1.1.0**: se sustituyeron los datos demo en memoria por persistencia
  Hive, se conectaron todos los flujos y se añadieron Inicio, Calendario y Perfil
  reales. Ver la entrada del 2026-10-29 en [`../docs/bitacora-ia.md`](../docs/bitacora-ia.md).
- **Versión 1.2.0 (en preparación)**: migración de Hive a Drift + Riverpod,
  esquema v2 con `courses.archivado` y prueba de migración v1 → v2.
