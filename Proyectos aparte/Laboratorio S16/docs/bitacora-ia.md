# Bitácora de uso de IA — Laboratorio S16

## 2026-10-30 · Integrante 2 (Prueba de migración)

- **Herramienta:** Copilot (asistente de código).
- **Generado:** `test/app_database_test.dart`, prueba de la migración real
  `LocalStore.abrir` con tres categorías v1 y seis movimientos vinculados.
- **Verificado:** `flutter pub get` completó; `dart format .` no cambió archivos;
  `flutter analyze` no encontró problemas; la prueba específica pasó (1 prueba)
  y `flutter test` pasó (2 pruebas).
- **Corregido / rechazado:** se probó la conservación tras cerrar y reabrir, el
  valor `archivado: false` y que datos v1 conflictivos no vuelvan a migrarse.
  No se agregó `sqflite_common_ffi`: el proyecto usa Hive CE, no SQLite. Se
  usaron categorías/movimientos reales del laboratorio en lugar de cursos/tareas,
  que no existen en este proyecto. No se modificó la implementación.

## 2026-10-29 · Integrante 1 (Pareja A)

- **Herramienta:** Claude Code (asistente de código).
- **Objetivo:** dejar listo el cambio de esquema que necesita el CRUD de
  categorías (`archivado`), la migración a una versión nueva de la base y el
  contrato del repositorio, como corresponde al Integrante 1 del reparto.
- **Especificación:** "Haz lo del Integrante 1 del Laboratorio S16: el cambio de
  esquema que necesita el CRUD, la migración a una versión nueva y el contrato
  del repositorio, sin tocar la versión anterior. El laboratorio es una tarea
  aparte: no modifiques `Proyecto final`."
- **Resultado:** app Flutter independiente en `Proyectos aparte/Laboratorio S16`
  con modelo `Categoria`, cajas `categorias_v1` → `categorias_v2`, migración
  única, repositorio con reglas y provider de Riverpod.
- **Aceptado:**
  - Versionar la caja (equivalente Hive de `onUpgrade`): copiar de
    `categorias_v1` agregando `archivado: false`, descartar la vieja y marcar
    `migracion_categorias_v2` en `meta_v1`.
  - Migración idempotente: copia con las mismas claves y una marca evita
    repetirla.
  - `listar` excluye archivadas por defecto; `incluirArchivadas` las devuelve
    para la futura sección «Archivadas».
  - Reglas de negocio en el repositorio: nombre repetido y categoría en uso
    lanzan excepciones con nombre propio, nunca un error de Hive.
  - Los datos de ejemplo cargan una sola vez (`sembrado`), igual que en S15.
- **Rechazado / corregido:**
  - Implementar el laboratorio dentro de `Proyecto final`: **rechazado por el
    usuario**; son tareas separadas. Todo ese cambio se revirtió antes de
    commitear y el trabajo se movió a una app aparte.
  - `sqflite` + `ALTER TABLE`: **descartado**; esta app usa Hive CE, así que la
    migración se demuestra con el mecanismo equivalente (caja versionada).
  - Editar los JSON dentro de `categorias_v1`: **rechazado**; no distingue
    esquemas y deja equipos a medio migrar sin forma de detectarlo.
  - `anterior.close()` antes de `deleteFromDisk()`: **corregido**; en
    `hive_ce` 2.22.0 `deleteFromDisk` ya cierra el archivo y el cierre previo
    lanzaba `FileSystemException: File closed`.
  - Widget test con Hive real: **corregido**; el I/O de archivos dentro de
    `testWidgets` corre en tiempo simulado y la prueba se colgó 10 minutos. Se
    sustituyó el repositorio por uno en memoria; el almacenamiento se prueba con
    `test()` normal.
- **Verificación:**
  - `dart format --output=none --set-exit-if-changed .` → sin cambios.
  - `dart analyze` → **No issues found**.
  - `flutter test` → **1 prueba en verde**.
  - Prueba temporal de migración y reglas (crear `categorias_v1` con dos
    categorías y un movimiento, abrir con la versión nueva, comprobar datos,
    nombre repetido, edición con el mismo id, borrado bloqueado por uso,
    archivar y reapertura) → **en verde**; se eliminó porque la prueba
    permanente es la entrega del Integrante 2.
- **Pendiente / siguiente paso:** prueba de migración permanente (I2),
  formulario y lista con `ref.invalidate(categoriasProvider)` (I3), diálogo de
  borrado con «Archivar» y widget test del formulario (I4).
