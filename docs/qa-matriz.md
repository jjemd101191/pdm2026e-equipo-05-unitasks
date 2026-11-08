# Matriz de pruebas · TaskU (Equipo 05)

**Ejecución:** Juan José Martínez Delgado (`@jjemd101191`), con la evidencia automatizada del repositorio.
**Fecha:** 2026-11-08.
**Rama:** `feat/auth-firestore`.
**Entorno:** Windows 11 (10.0.26300), Flutter 3.44.8 stable, Dart 3.12.2.
**Alcance:** flujos de la app del Sprint 3, anuncios intersticiales, Premium simulado y cuentas con sincronización en Firestore.

> **Criterio de honestidad:** aquí se distingue lo **ejecutado** de lo **pendiente**. No se marca como aprobado nada que no se haya corrido. En esta máquina **no hay Android SDK ni AVD**, así que el APK y la instalación en teléfono quedan pendientes; la compilación web y las pruebas automatizadas sí se ejecutaron.

## 1. Verificación automatizada

| Comando | Resultado |
|---|---|
| `flutter test` | **108 pruebas aprobadas**, 0 fallos |
| `dart analyze lib test` | **0 observaciones** |
| `dart format --output=none --set-exit-if-changed lib test` | **0 archivos por cambiar** |
| `flutter build web --release` | **Correcto** (`build/web`) |
| `flutter build apk --release` | **Pendiente en esta máquina:** no hay Android SDK ni Java. El 1.4.0 se compila con el workflow `.github/workflows/android-apk.yml` y se descarga como artefacto; falta instalarlo. |

> El APK no se sube al repositorio: `build/` está ignorado.
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
| Q-15 | Migración v1 → v3 | Los cursos existentes sobreviven, aparece `archivado = false` y se crea `app_settings` | **Aprobado (automatizado)** | `test/data/migracion_test.dart` |
| Q-16 | Estados de carga, vacío y error con «Reintentar» | Inicio, Calendario, Cursos y Perfil informan y permiten reintentar | **Aprobado (automatizado)** | `test/widget_test.dart`, `test/calendar_screen_test.dart`, `test/profile_ux_test.dart` |
| Q-17 | Arranque fallido de la base | Muestra «Reintentar» sin borrar datos | **Aprobado (automatizado)** | `test/startup_retry_test.dart` |
| Q-18 | Uso sin conexión | La app sigue leyendo y guardando en SQLite; la nube se pone al día al reconectar | **Aprobado (automatizado)** | `test/data/sincronizacion_test.dart` («sin conexión la app conserva los datos locales») |
| Q-19 | Compilación web | La app compila para web | **Aprobado** | `flutter build web --release` → `build/web` |
| Q-20 | Compilar el APK de la demo | Generar `app-release.apk` | **Aprobado:** APK release de 57.8 MB, versión `1.2.1` (`versionCode 4`), firmado con certificado debug | `Proyecto final/build/app/outputs/flutter-apk/app-release.apk`; copia en `Desktop/TaskU-1.2.1.apk` |
| Q-21 | Instalar y recorrer la app en Android | La app abre y se navega en teléfono o emulador | **Aprobado:** APK 1.2.0 instalado en un teléfono Android del equipo; las tres sesiones recorrieron las actividades del kit | `docs/usuarios.md`, `docs/evidencia/U01.md`, `U02.md`, `U03.md` |
| Q-22 | Pruebas con 3 personas reales | Tres sesiones documentadas y una mejora aplicada | **Aprobado:** U01 (Moises), U02 (Carlitos) y U03 documentadas; U03 encontró fricción al recuperar una tarea y se aplicó «Deshacer» (issue #30), fusionada en `main` con el PR #31 | `docs/usuarios.md`, `docs/evidencia/U01.md`, `U02.md`, `U03.md`, issue [#30](https://github.com/jjemd101191/pdm2026e-equipo-05-unitasks/issues/30), PR [#31](https://github.com/jjemd101191/pdm2026e-equipo-05-unitasks/pull/31) |
| Q-23 | Eliminar una tarea y recuperarla con «Deshacer» | La tarea vuelve al listado con el mismo id, subtareas y recordatorio | **Aprobado (automatizado)** | `test/task_flow_test.dart` |
| Q-24 | Plan Premium simulado | Activar/desactivar el plan persiste en `app_settings` y el Perfil muestra el estado real | **Aprobado (automatizado)** | `test/data/settings_repository_test.dart`, `test/profile_ux_test.dart` |
| Q-25 | Migración v2 → v3 | La tabla `app_settings` se crea sin perder cursos y `user_version` queda en 3 | **Aprobado (automatizado)** | `test/data/migracion_test.dart` |
| Q-26 | Anuncio intersticial al completar una tarea | Se solicita solo si no hay Premium, con un máximo cada 90 s; no aparece en web ni escritorio | **Pendiente de verificación en dispositivo.** La lógica y el import condicional están cubiertos por análisis y build web; no hay Android SDK en esta máquina | `lib/ads/`, `lib/screens/task_list_screen.dart`, `lib/screens/task_detail_screen.dart` |
| Q-27 | Registro con correo y contraseña | La cuenta se crea y la app entra directo | **Aprobado (automatizado)** | `test/auth/login_screen_test.dart`, `test/auth/auth_gate_test.dart` |
| Q-28 | Entrar sin sesión | Se muestra el login y no se accede a las tareas | **Aprobado (automatizado)** | `test/auth/auth_gate_test.dart` |
| Q-29 | Cerrar sesión | Vuelve al login y la cuenta anterior deja de verse | **Aprobado (automatizado)** | `test/auth/auth_gate_test.dart` |
| Q-30 | Crear una tarea con sesión | Se guarda en Drift y se copia a Firestore | **Aprobado (automatizado con nube falsa)** | `test/data/sincronizacion_test.dart` |
| Q-31 | Cuenta nueva o con datos locales viejos | Adopta las filas sin dueño o siembra y las sube | **Aprobado (automatizado)** | `test/data/sincronizacion_test.dart` |
| Q-32 | Descargar cursos, tareas, subtareas y recordatorio | Llegan a la copia local con el mismo id | **Aprobado (automatizado)** | `test/data/sincronizacion_test.dart` |
| Q-33 | Conflicto entre local y remoto | Gana el `actualizadaEn` más reciente | **Aprobado (automatizado)** | `test/data/sincronizacion_test.dart` |
| Q-34 | Aislamiento entre cuentas | La cuenta A no ve ni toca los datos de la B | **Aprobado (automatizado)** | `test/data/sincronizacion_test.dart` |
| Q-35 | Borrado remoto | La fila desaparece también en el teléfono | **Aprobado (automatizado)** | `test/data/sincronizacion_test.dart` |
| Q-36 | Migración v3 → v4 | Se agregan `usuario_id` y `actualizada_en` sin perder datos; queda en 4 | **Aprobado (automatizado)** | `test/data/migracion_test.dart` |
| Q-38 | Entrar después del registro | La app monta Inicio (no pantalla gris) y muestra los datos sembrados | **Aprobado (automatizado + verificación headless):** `test/auth/arranque_con_sesion_test.dart`; captura del navegador con 6 pendientes y 2 de 8 completadas | `test/auth/arranque_con_sesion_test.dart`, `lib/auth/auth_gate.dart`, `lib/main.dart` |
| Q-37 | Reglas de Firestore | Un uid no puede leer ni escribir el árbol de otro | **Aprobado (API real):** con un token de una cuenta temporal, escritura en su propio árbol → 200 y lectura de otro uid → 403; la cuenta se eliminó después | `firestore.rules` |

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

1. **APK 1.4.0:** generarlo con el workflow `APK de Android` e instalarlo para probar login, sincronización e intersticial de prueba. En esta máquina no hay Android SDK.
2. **Sincronización real con dos cuentas/dispositivos:** Q-30 a Q-35 usan una nube falsa en memoria y Q-37 ya se comprobó contra Firestore real. Falta el recorrido visual con dos sesiones en la app desplegada.
3. **Revalidación U03:** repetir la tarea de eliminar y recuperar con U03 en el APK 1.4.0 o superior. Mientras no ocurra, se registra como pendiente.
4. **Persistencia en dispositivo:** la prueba automatizada Q-14 cubre cerrar y reabrir con un archivo real; no se registró una prueba manual de cierre completo en el teléfono durante las sesiones.

## 5. Fuera del alcance de esta matriz

- Notificaciones del sistema (la app solo muestra recordatorios dentro de la interfaz).
- Cobro real de Premium (Google Play Billing) y anuncios de producción con cuenta de AdMob.
- Exportación a PDF y sincronización del plan Premium (el Premium sigue siendo local por cuenta).
- Recuperación de contraseña y verificación de correo.
- Archivado de cursos desde la interfaz (la columna y la migración existen; no hay acción de usuario).
