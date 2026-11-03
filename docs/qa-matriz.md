# Matriz de pruebas · TaskU (Equipo 05)

**Ejecución:** Juan José Martínez Delgado (`@jjemd101191`), con la evidencia automatizada del repositorio.
**Fecha:** 2026-11-03.
**Rama:** `feat/cierre-sprint3` (no fusionada a `main` al escribir este documento).
**Entorno:** Windows 11 (10.0.26300), Flutter 3.44.8 stable, Dart 3.12.2.
**Alcance:** flujos de la app del Sprint 3 y requisitos de la exposición.

> **Criterio de honestidad:** aquí se distingue lo **ejecutado** de lo **pendiente**. No se marca como aprobado nada que no se haya corrido. En esta máquina **no hay Android SDK ni AVD**, así que el APK y la instalación en teléfono quedan pendientes; la compilación web y las pruebas automatizadas sí se ejecutaron.

## 1. Verificación automatizada

| Comando | Resultado |
|---|---|
| `flutter test` | **89 pruebas aprobadas**, 0 fallos |
| `dart analyze lib test` | **0 observaciones** |
| `dart format --output=none --set-exit-if-changed lib test` | **0 archivos por cambiar** |
| `flutter build web --release` | **Correcto** (`build/web`) |
| `flutter build apk --release` | **Correcto:** `build/app/outputs/flutter-apk/app-release.apk` (57.8 MB, versión `1.2.0`). Se compiló desde la unidad `X:` para evitar la tilde de la ruta. La instalación en Android queda pendiente. |

> El APK no se sube al repositorio: `build/` está ignorado. La copia para instalar está en el escritorio como `TaskU-1.2.0.apk`.
| CI de GitHub en `main` | **Verde** (último run del 2026-11-02; jobs de Proyecto final, S15 y S16) |

## 2. Matriz funcional

| ID | Caso | Esperado | Resultado | Evidencia |
|---|---|---|---|---|
| Q-01 | Crear tarea con título, curso, tipo, prioridad, fecha, recordatorio y descripción | La tarea queda guardada y visible en Inicio | **Aprobado (automatizado)** | `test/task_flow_test.dart`, `test/task_form_screen_test.dart` |
| Q-02 | Guardar sin título | El formulario muestra la validación y no crea la tarea | **Aprobado (automatizado)** | `test/task_form_screen_test.dart` |
| Q-03 | Editar una tarea existente | Los cambios se reflejan en el detalle y en el listado | **Aprobado (automatizado)** | `test/task_flow_test.dart` |
| Q-04 | Eliminar una tarea | La tarea desaparece del listado y de la base | **Aprobado (automatizado)** | `test/task_flow_test.dart` |
| Q-05 | Completar y reabrir una tarea | Pide confirmación; completar marca subtareas; reabrir las conserva | **Aprobado (automatizado)** | `test/task_list_completion_confirmation_test.dart`, `test/task_detail_completion_confirmation_test.dart`, `test/confirmacion_estado_test.dart` |
| Q-06 | Agregar, marcar y contar subtareas | El progreso y el estado de la tarea son coherentes | **Aprobado (automatizado)** | `test/models_test.dart`, `test/data/repositorios_test.dart` |
| Q-07 | Buscar por título, descripción y curso; ignorar mayúsculas; estado vacío | El listado se filtra sin recargar y muestra «No hay tareas con ese texto» | **Aprobado (automatizado)** | `test/task_list_search_test.dart` |
| Q-08 | Combinar búsqueda con Pendientes / Todas / Completadas | Los filtros y la búsqueda se aplican juntos | **Aprobado (automatizado)** | `test/task_list_search_test.dart` |
| Q-09 | Calendario: mes, agenda del día y navegación entre meses | Muestra las entregas del día y cambia de mes | **Aprobado (automatizado)** | `test/calendar_screen_test.dart` |
| Q-10 | Calendario: estado vacío y error con «Reintentar» | Informa el estado y permite reintentar | **Aprobado (automatizado)** | `test/calendar_screen_test.dart` |
| Q-11 | CRUD de cursos | Crear, editar, listar y eliminar un curso vacío | **Aprobado (automatizado)** | `test/widget_test.dart`, `test/data/repositorios_test.dart` |
| Q-12 | Intentar eliminar un curso con tareas | Se bloquea (RESTRICT) y se informa cuántas tareas tiene | **Aprobado (automatizado)** | `test/widget_test.dart`, `test/data/repositorios_test.dart` |
| Q-13 | Eliminar un curso vacío y usar «Deshacer» | El curso vuelve con el mismo id | **Aprobado (automatizado)** | `test/widget_test.dart` |
| Q-14 | Cerrar y reabrir la app | Los datos siguen en el archivo SQLite y no se vuelven a sembrar | **Aprobado (automatizado)** | `test/data/repositorios_test.dart` (grupo «en un archivo») |
| Q-15 | Migración v1 → v2 | Los cursos existentes sobreviven y aparece `archivado = false` | **Aprobado (automatizado)** | `test/data/migracion_test.dart` |
| Q-16 | Estados de carga, vacío y error con «Reintentar» | Inicio, Calendario, Cursos y Perfil informan y permiten reintentar | **Aprobado (automatizado)** | `test/widget_test.dart`, `test/calendar_screen_test.dart`, `test/profile_ux_test.dart` |
| Q-17 | Arranque fallido de la base | Muestra «Reintentar» sin borrar datos | **Aprobado (automatizado)** | `test/startup_retry_test.dart` |
| Q-18 | Uso sin conexión | No hay llamadas de red; la base es local | **Aprobado por revisión de código** | `pubspec.yaml` no incluye clientes HTTP; `lib/data/db/app_database.dart` usa SQLite/Drift local |
| Q-19 | Compilación web | La app compila para web | **Aprobado** | `flutter build web --release` → `build/web` |
| Q-20 | Compilar el APK de la demo | Generar `app-release.apk` | **Aprobado:** APK release de 57.8 MB, versión `1.2.0`, firmado con certificado debug | `Proyecto final/build/app/outputs/flutter-apk/app-release.apk`; copia en `Desktop/TaskU-1.2.0.apk` |
| Q-21 | Instalar y recorrer la app en Android | La app abre, persiste y se navega en teléfono o emulador | **Pendiente de ejecución manual** | APK listo; requiere teléfono con depuración USB o un AVD |
| Q-22 | Pruebas con 3 personas reales | Tres sesiones documentadas y una mejora aplicada | **Pendiente (Pablo): 0/3** | `docs/usuarios.md` |

## 3. Cómo reproducir

```bash
cd "Proyecto final"
flutter pub get
flutter test
dart analyze lib test
dart format --output=none --set-exit-if-changed lib test
flutter build web --release
# En una máquina con Android SDK:
flutter build apk --release
```

## 4. Pendiente para la demo

1. **Android:** el APK ya está compilado; falta instalarlo en un teléfono o AVD y recorrer el flujo.
2. **Recorrido manual:** abrir la app en el teléfono/emulador, crear una tarea, cerrar por completo, reabrir y comprobar que sigue ahí.
3. **Usuarios:** Pablo debe completar las 3 sesiones reales; no se pueden sustituir por pruebas automatizadas.

## 5. Fuera del alcance de esta matriz

- Notificaciones del sistema (la app solo muestra recordatorios dentro de la interfaz).
- Freemium, Premium, sincronización en la nube y exportación a PDF.
- Archivado de cursos desde la interfaz (la columna y la migración existen; no hay acción de usuario).
