# Changelog

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
