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

Aplicación desarrollada en **Flutter** para el seguimiento de compromisos académicos, como tareas, exámenes y proyectos. Permite registrar actividades, consultar una agenda, gestionar recordatorios dentro de la aplicación y almacenar la información localmente en el dispositivo.

La aplicación funciona sin conexión a Internet y no requiere enviar los datos a un servidor.

**Versión actual: 1.4.0** (`pubspec.yaml` → `1.4.0+6`).

### Problema y usuario

Un estudiante universitario con varios cursos reparte tareas, exámenes y proyectos entre notas, recordatorios y calendarios. Esa dispersión hace fácil olvidar una entrega, y las herramientas generales no siempre están pensadas para la carga académica ni para funcionar sin Internet.

TaskU está dirigida a estudiantes de 5.º a 8.º semestre que usan el teléfono como dispositivo principal y necesitan registrar un compromiso en pocos pasos, consultarlo en una agenda y encontrarlo aunque no haya conexión. La propuesta es centralizar tareas, exámenes y proyectos por curso, con recordatorios dentro de la app y datos guardados solo en el dispositivo. La versión 1.3.0 incorpora anuncios intersticiales con los IDs de prueba de Google y un plan Premium simulado que los quita; la nube, el PDF y los tableros siguen planteados en el informe del proyecto y no forman parte de esta entrega.

### Qué funciona hoy

| Pantalla | Archivo | Qué hace |
|---|---|---|
| 1 · Pendientes (`Inicio`) | `lib/screens/task_list_screen.dart` | Lista de tareas guardadas, búsqueda por título, descripción y nombre del curso, filtros Pendientes/Todas/Completadas combinables con la búsqueda, resumen y avance, marca rápida como completada, recordatorios vencidos dentro de la aplicación y botón + para registrar tareas. |
| 2 · Nueva / editar tarea | `lib/screens/task_form_screen.dart` | Título obligatorio, curso, tipo, prioridad, fecha y hora, recordatorio y descripción. El mismo formulario permite crear y editar tareas. |
| 3 · Calendario | `lib/screens/calendar_screen.dart` | Mes navegable, días con entregas, agenda del día seleccionado y acceso al detalle de cada tarea. |
| 4A · Detalle de tarea | `lib/screens/task_detail_screen.dart` | Información del curso, prioridad, tipo, fecha, recordatorio y estado; descripción; subtareas con progreso; completar/reabrir, editar y eliminar. Al eliminar, Inicio ofrece «Deshacer» y restaura la misma tarea. **Cada cambio se guarda al instante.** |
| 4B · Gestión de cursos | `lib/screens/course_list_screen.dart` | Filtros (Todos · 2026-2 · Con pendientes), búsqueda local, resumen del semestre con anillo de avance, tarjetas con conteos calculados desde las tareas, editar, eliminar con «Deshacer» y agregar. |
| 4C · Registrar / editar curso | `lib/screens/course_form_screen.dart` | Nombre, docente, color, días, horario y periodo. |
| Cuenta | `lib/screens/login_screen.dart` | Registro e inicio de sesión con correo y contraseña (Firebase Auth). Sin sesión no se entra a la app; la sesión se conserva al cerrar. |
| Perfil | `lib/screens/profile_screen.dart` | Correo de la cuenta, conteos reales, estado de la sincronización, plan Gratis/Premium real, acceso a Premium y «Cerrar sesión». |

### Búsqueda de tareas

La pantalla Inicio incorpora un buscador que permite localizar tareas utilizando los siguientes criterios:

- Título de la tarea.
- Descripción de la tarea.
- Nombre del curso asociado.

La búsqueda no distingue entre mayúsculas y minúsculas y se actualiza conforme se escribe el texto.

También puede utilizarse junto con los filtros **Pendientes, Todas y Completadas**, sin modificar el funcionamiento de estos.

Cuando no existen resultados, se muestra el mensaje «No hay tareas con ese texto». El usuario puede limpiar la búsqueda para visualizar nuevamente las tareas correspondientes al filtro seleccionado.

Esta funcionalidad se implementó sin modificar el esquema de la base de datos.

### Anuncios y Premium

- **Anuncios:** la versión gratuita muestra un intersticial de AdMob después de completar una tarea, tanto desde Inicio como desde el detalle. Se usa como máximo uno cada 90 segundos y nunca aparece en formularios.
- **Plataformas:** AdMob solo funciona en Android/iOS. En web y escritorio la app no muestra anuncios y el build web no incluye el SDK.
- **IDs de prueba:** se usan los IDs de prueba de Google (`ca-app-pub-3940256099942544/...`), que no generan ingresos ni requieren cuenta de AdMob. Para producción hay que reemplazarlos.
- **Premium:** es una **demostración**. La pantalla `PremiumScreen` explica los beneficios, pero no hay pasarela de pago ni cobro real. Al activarlo se guarda `premium_activo` en la base local y la app deja de mostrar anuncios.
- **Sin límite de tareas:** la versión gratis no limita las tareas activas, porque el sondeo de Mercadeo mostró que el 46 % rechaza el límite de 3.

### Cuentas y sincronización

- **Cuentas:** Firebase Auth con correo y contraseña. La pantalla de login permite registrarse o entrar; al cerrar sesión se vuelve al login. La sesión persiste entre reinicios.
- **Cada cuenta ve sus datos:** todas las consultas filtran por el uid de la cuenta, así que dos cuentas en el mismo teléfono no se mezclan.
- **Nube:** Firestore guarda los cursos en `users/{uid}/courses` y las tareas en `users/{uid}/tasks` (con subtareas y recordatorio dentro del documento). Las reglas `firestore.rules` solo permiten el árbol del propio uid.
- **Sin conexión:** la app sigue leyendo y escribiendo en SQLite. Al reconectar, Firestore envía lo pendiente y la app aplica lo que llegue de la nube.
- **Conflictos:** gana el cambio con `actualizadaEn` más reciente. Es una regla simple, pensada para el alcance del curso.
- **Primera sesión:** si la cuenta no tiene datos en la nube, se adoptan los que ya estaban en el teléfono (o se siembran los de ejemplo) y se suben; si ya tiene, se descargan.
- **Límite conocido:** las pantallas no se suscriben a los cambios remotos en vivo; un cambio hecho en otro dispositivo aparece al cambiar de pestaña o con «Sincronizar» en el Perfil.

### Persistencia

- **Motor:** Drift 2.35 sobre SQLite (`drift` + `drift_flutter`). En móvil y escritorio utiliza `tasku.sqlite`; en web utiliza SQLite compilado a WebAssembly (WASM).
- **Esquema v4:** tablas `courses`, `tasks`, `subtasks`, `reminders` y `app_settings`, con claves foráneas (`RESTRICT` de tareas hacia curso y `CASCADE` de subtareas y recordatorios) e índices por curso, fecha de entrega y usuario. La migración v1 → v2 agrega `courses.archivado`; la v2 → v3 crea `app_settings`; la v3 → v4 agrega `usuarioId` a cursos y tareas y `courses.actualizadaEn` (se rellena con `creadoEn`).
- **Migraciones:** el esquema se versiona mediante `schemaVersion` y cada paso se verifica en `test/data/migracion_test.dart` (v1 → v4, v2 → v4 y v3 → v4).
- **Datos iniciales:** una cuenta nueva recibe cuatro cursos y ocho tareas de ejemplo desde `seed_data.dart`, una sola vez.
- **Flujo de datos:** el recorrido pantalla → repositorio → DAO → SQLite → stream → pantalla se documenta en la [ADR 0003](../docs/adr/0003-flujo-de-datos-y-migraciones.md).

### Reglas de negocio implementadas

- **Un curso con tareas no puede eliminarse.** El sistema informa cuántas tareas tiene asociadas para evitar la pérdida de información. Un curso vacío puede eliminarse y recuperarse mediante «Deshacer».
- **Los pendientes y el avance se calculan** a partir de las tareas almacenadas; los cursos no mantienen contadores independientes.
- **Completar una tarea** marca también todas sus subtareas. Desmarcar una subtarea permite reabrir la tarea.
- **Los recordatorios se calculan** a partir de la fecha de entrega y se muestran dentro de la aplicación cuando vencen. Las notificaciones del sistema todavía no están implementadas.
- **Una tarea eliminada se puede recuperar** con «Deshacer»; vuelve con el mismo id, sus subtareas y su recordatorio.

### Validación con usuarios

Se realizaron tres sesiones reales con el APK 1.2.0 instalado en un teléfono Android del equipo. El detalle está en [`docs/usuarios.md`](../docs/usuarios.md) y en las hojas `docs/evidencia/U01.md` a `U03.md`.

- **U01 (Moises) y U02 (Carlitos):** completaron las actividades sin ayuda; no reportaron fricción.
- **U03:** no encontró cómo recuperar una tarea eliminada (2/5) y esperaba una papelera. Calificó la app con 9.5/10.
- **Mejora aplicada:** «Deshacer» al eliminar una tarea, con restauración del mismo id, subtareas y recordatorio (issue [#30](https://github.com/jjemd101191/pdm2026e-equipo-05-unitasks/issues/30), PR [#31](https://github.com/jjemd101191/pdm2026e-equipo-05-unitasks/pull/31)).
- **Pendiente:** revalidar con U03 en el APK 1.2.1. La papelera y las notificaciones del sistema quedan como trabajo futuro.

### Arquitectura

```text
lib/
├── main.dart                 # Arranque, base local y ProviderScope
├── theme.dart                # Paleta y tema Material 3
├── models/
│   ├── course.dart           # Course (incluye archivado)
│   ├── course_summary.dart   # Curso + pendientes/total calculados
│   ├── course_filter.dart    # Filtro inmutable de cursos
│   └── task.dart             # Task, Subtask, enums y recordatorios
├── data/
│   ├── db/
│   │   ├── app_database.dart # Esquema v2 y migraciones
│   │   ├── tablas.dart       # Courses, tasks, subtasks, reminders
│   │   ├── cursos_dao.dart
│   │   └── tareas_dao.dart
│   ├── course_repository.dart
│   ├── task_repository.dart
│   ├── drift_course_repository.dart
│   ├── drift_task_repository.dart
│   └── seed_data.dart
├── providers/
│   └── providers.dart        # Repositorios y listas reactivas (Riverpod)
├── screens/                  # Inicio, calendario, cursos, perfil y formularios
├── utils/                    # Fechas en español e identificadores locales
└── widgets/                  # InfoChip, PrimaryButton, EstadoVista
```

La decisión de persistencia y sus consecuencias se encuentran documentadas en la [ADR 0002](../docs/adr/0002-persistencia-drift-riverpod.md).

El flujo de datos y la migración del esquema v2 se describen en la [ADR 0003](../docs/adr/0003-flujo-de-datos-y-migraciones.md).

## Cómo ejecutar

### Requisitos

- Flutter SDK instalado y configurado.
- Dart SDK compatible con el proyecto.
- Visual Studio Code, Android Studio u otro editor compatible con Flutter.
- Chrome para ejecutar la versión web.
- Emulador o dispositivo compatible para ejecutar la aplicación móvil.

### Instalación y ejecución

Desde la carpeta principal del repositorio, ingresar al proyecto Flutter:

```bash
cd "Proyecto final"
```

Instalar las dependencias:

```bash
flutter pub get
```

Para ejecutar en un emulador o dispositivo conectado:

```bash
flutter run
```

Para ejecutar en Chrome:

```bash
flutter run -d chrome
```

### Configuración de SQLite en Flutter Web

En Flutter Web, Drift utiliza SQLite compilado a WebAssembly (WASM).

Para permitir la inicialización de la base de datos en el navegador, se incluyen los siguientes archivos dentro de `web/`:

- `sqlite3.wasm`: módulo WebAssembly utilizado por SQLite.
- `drift_worker.js`: archivo utilizado para ejecutar operaciones de Drift en el entorno web.

Estos recursos permiten ejecutar la aplicación en Chrome sin requerir un servidor de base de datos externo.

La compilación web se verificó con `flutter build web --release`. El recorrido manual en navegador y en Android queda registrado en la [matriz de pruebas](../docs/qa-matriz.md).

### Despliegue en Firebase Hosting

La configuración está en `firebase.json` (carpeta pública `build/web`, cabecera `application/wasm` para Drift y reescritura a `index.html`).

**App publicada:** <https://tasku-equipo-05.web.app> (proyecto `tasku-equipo-05`, plan Spark gratuito).

```bash
cd "Proyecto final"
flutter build web --release
npx --yes firebase-tools login
npx --yes firebase-tools deploy --only firestore:rules,hosting --project tasku-equipo-05
```

El login de `firebase-tools` usa un código que se pega en la terminal; la primera vez también hay que crear el proyecto en <https://console.firebase.google.com/>, habilitar **Authentication → Correo electrónico/contraseña** y crear la base de Firestore en la consola (el CLI no puede aceptar los Términos de Servicio de Google Cloud). El despliegue web no muestra anuncios: AdMob solo funciona en Android/iOS.

### APK de Android desde GitHub Actions

Esta PC no tiene Android SDK, así que el APK se compila en Actions:

1. En GitHub, **Actions → «APK de Android» → Run workflow**.
2. Al terminar, descargar el artefacto `tasku-apk-<número>` y abrir el `.apk` en el teléfono (hay que permitir instalar apps de origen desconocido).
3. El APK usa la firma debug y los IDs de prueba de AdMob: sirve para revisar, no para publicar en Play Store.

## Verificación

Resultados de la verificación del 2026-11-08 en la rama `feat/auth-firestore`:

- `dart format --output=none --set-exit-if-changed lib test` → 0 archivos por cambiar.
- `dart analyze` → **0 observaciones**.
- `flutter test` → **108 pruebas automatizadas aprobadas**, incluyendo login, gate de sesión, sincronización (adopción, descarga, conflictos, aislamiento por cuenta, borrados y modo sin conexión) y migraciones v1 → v4, v2 → v4 y v3 → v4.
- `flutter build web --release` → compilación web correcta.
- **APK 1.4.0:** se genera con el workflow `.github/workflows/android-apk.yml`; la instalación y prueba del anuncio en un teléfono quedan pendientes.

La matriz completa, con la distinción entre lo automatizado y lo pendiente, está en [`docs/qa-matriz.md`](../docs/qa-matriz.md).

Las pruebas específicas del buscador se encuentran en `test/task_list_search_test.dart`.

El flujo de integración continua (`.github/workflows/ci.yml`) ejecuta verificaciones de formato, análisis, pruebas automatizadas y compilación web para `Proyecto final`.

## Pendiente / siguiente paso

| Tema | Estado |
|---|---|
| Notificaciones del sistema (Android/iOS) | Pendiente. Actualmente los recordatorios se muestran dentro de la aplicación. Requiere `flutter_local_notifications`, `timezone`, permisos y configuración por plataforma. |
| Anuncios reales (producción) | **Implementado con IDs de prueba.** Para ingresos reales hay que registrar la app en AdMob, reemplazar los IDs y verificar el formato en un dispositivo. |
| Cobro real de Premium | **Simulado.** No hay pasarela de pago ni Play Billing; la compra no cobra dinero. |
| Sincronización en la nube | **Implementada:** Firestore por cuenta, con copia local y reglas por uid. Las pantallas refrescan al cambiar de pestaña o con «Sincronizar». |
| Exportación a PDF | Pendiente. Prevista para Premium; requiere generación de PDF en el cliente. |
| Verificación de correo y recuperación de contraseña | Pendiente. Firebase Auth ya está integrado; faltan los flujos de verificación y de «olvidé mi contraseña». |
| Icono de la aplicación | Se mantiene el icono predeterminado de Flutter; falta incorporar el diseño definitivo. |
| Validación con 3 personas reales | **Completada (3/3):** U01 (Moises), U02 (Carlitos) y U03, documentadas en [`docs/usuarios.md`](../docs/usuarios.md). U03 no encontró cómo recuperar una tarea; se aplicó «Deshacer». Falta revalidar con U03 en el APK 1.2.1. |
| APK e instalación en Android | **APK 1.2.0 instalado y usado en un teléfono Android** durante las tres sesiones. El 1.4.0 se compila en GitHub Actions y falta instalarlo para probar login, sincronización e intersticial. |
| Despliegue web | **Publicado:** <https://tasku-equipo-05.web.app> en Firebase Hosting (proyecto `tasku-equipo-05`, plan Spark). Falta el recorrido manual en navegador con la versión publicada. |
| Pruebas en dispositivo físico | Android verificado en las sesiones; iOS sigue pendiente. |

## Historial de módulos

- **Módulo 4** (4A detalle, 4B cursos y 4C formulario de curso) y **módulo 2** (formulario de tarea): base visual de la aplicación.
- **Versión 1.1.0:** se sustituyeron los datos de demostración en memoria por persistencia con Hive, se conectaron los flujos y se incorporaron Inicio, Calendario y Perfil. Consultar la entrada del 2026-10-29 en la [bitácora de IA](../docs/bitacora-ia.md).
- **Versión 1.2.0:** migración de Hive a Drift + Riverpod, esquema v2 con `courses.archivado`, prueba de migración v1 → v2, 89 pruebas automatizadas y matriz de pruebas. El saludo de Inicio dejó de usar una identidad ficticia.
- **Búsqueda de tareas (Issue #19):** incorporación de búsqueda por título, descripción y curso, compatible con los filtros de estado, seis pruebas automatizadas y soporte SQLite Web para ejecutar la aplicación en Chrome. Implementación realizada en la rama `feat/busqueda-tareas`.
- **Perfil local y recuperación de errores (PR #25):** Perfil sin identidad ficticia, estados de carga, vacío y error con «Reintentar», y arranque que permite reintentar la apertura de la base sin borrar datos.
- **Versión 1.2.1:** validación con tres personas reales y «Deshacer» al eliminar una tarea, derivado de la sesión U03 (issue #30).
- **Versión 1.3.0:** anuncios intersticiales de AdMob con IDs de prueba, plan Premium simulado que los quita, esquema v3 con `app_settings` y 92 pruebas automatizadas.
- **Versión 1.4.0:** cuentas con Firebase Auth (correo y contraseña), sincronización con Firestore por usuario, esquema v4 con `usuarioId` y migraciones probadas, APK vía GitHub Actions y 108 pruebas automatizadas.

## Capturas de la aplicación (390 × 844)

Capturas del navegador con la app integrada; no son evidencia de tres usuarios ni de ejecución en Android.

| Inicio | Calendario |
|---|---|
| ![Inicio](../docs/capturas/inicio.png) | ![Calendario](../docs/capturas/calendario.png) |

| Cursos | Perfil local |
|---|---|
| ![Cursos](../docs/capturas/cursos.png) | ![Perfil local](../docs/capturas/perfil.png) |

El aporte UX sustituye la identidad ficticia del Perfil y agrega recuperación ante errores sin alterar la base. Las tres sesiones de validación están documentadas en [usuarios.md](../docs/usuarios.md). Ver el [guion UX de Pablo](../docs/guion-ux-pablo.md).
