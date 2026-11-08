# Changelog

## 1.4.0 — 2026-11-08

- Cuentas con Firebase Auth (correo y contraseña): sin sesión no se entra, el Perfil muestra el correo y permite cerrar sesión.
- Sincronización con Firestore por usuario (`users/{uid}/courses` y `users/{uid}/tasks`), con copia local en Drift y reglas de seguridad por uid.
- Esquema v4: `usuarioId` en cursos y tareas y `courses.actualizadaEn`; migraciones v1 → v4, v2 → v4 y v3 → v4 probadas.
- Los datos que ya existían en el teléfono se adoptan en el primer inicio de sesión; una cuenta nueva recibe los datos de ejemplo.
- APK generado en GitHub Actions (`.github/workflows/android-apk.yml`).
- APK: R8 desactivado en release porque rompía WorkManager (dependencia de Firestore) y la app se cerraba al abrir.
- 108 pruebas automatizadas.

## 1.3.0 — 2026-11-08

- Anuncios intersticiales de AdMob con los IDs de prueba de Google al completar una tarea, desde Inicio y desde el detalle.
- Como máximo un intersticial cada 90 segundos; nunca aparece en formularios ni en la web.
- Plan Premium simulado en `PremiumScreen`: quita los anuncios y se guarda en el dispositivo. No hay pasarela de pago ni cobro real.
- Esquema v3 con la tabla `app_settings` para preferencias locales; migración v2 → v3 probada.
- La versión gratis no limita las tareas activas.
- 92 pruebas automatizadas.

## 1.2.1 — 2026-11-04

- «Deshacer» al eliminar una tarea: la restauración conserva el mismo id, subtareas y recordatorio.
- Validación con tres personas reales documentada en `docs/usuarios.md` y en las hojas U01–U03.
- Mejora derivada de la sesión U03, que no encontró cómo recuperar una tarea eliminada (issue #30).
- 90 pruebas automatizadas.

## 1.2.0 — 2026-11-03

- Persistencia migrada a Drift/SQLite con esquema v2, `courses.archivado`, claves foráneas e índices.
- Migración v1 → v2 probada: los datos existentes sobreviven y la columna nueva queda en `false`.
- Búsqueda de tareas por título, descripción y curso, combinable con los filtros de estado.
- Confirmación antes de completar o reabrir tareas; las subtareas se marcan o conservan según la regla.
- Perfil local sin identidad ficticia y recuperación de errores de arranque con «Reintentar».
- Saludo de Inicio sin identidad ficticia.
- 89 pruebas automatizadas, matriz de pruebas y verificación de compilación web.

## 1.1.0 — 2026-10-29

- Persistencia local inicial con Hive y conexión del flujo completo de tareas.
- Pantallas de Inicio, Calendario, Cursos y Perfil.
