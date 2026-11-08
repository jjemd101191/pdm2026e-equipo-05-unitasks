# ADR 0005 · Autenticación con Firebase y sincronización con Firestore

- **Fecha:** 2026-11-08
- **Estado:** Aceptada
- **Contexto:** TaskU 1.3.0 guardaba todo en SQLite local, sin cuentas. El usuario pidió login real y que cada cuenta viera sus datos también en la nube.

## Decisión

1. **Firebase Auth con correo y contraseña.** No se usa Google Sign-In para no depender de SHA-1 ni de la configuración OAuth de Android en una demo.
2. **Firestore directo desde el cliente**, sin backend propio:
   - `users/{uid}/courses/{courseId}`
   - `users/{uid}/tasks/{taskId}` (subtareas y recordatorio dentro del documento)
   - Reglas: solo el uid del token puede leer y escribir su árbol.
3. **Drift sigue siendo la fuente de la UI.** Cada cambio se escribe primero en SQLite y se copia a Firestore sin bloquear la pantalla. Los cambios remotos se aplican a Drift.
4. **Repositorios decorados** (`CursoRepoSincronizado`, `TareaRepoSincronizado`): mantienen las interfaces existentes, así ninguna pantalla cambió.
5. **Esquema v4:** `usuarioId` en `courses` y `tasks`, y `courses.actualizadaEn`. Migración aditiva; las filas viejas quedan con `usuarioId = ''` y se adoptan en el primer inicio de sesión.
6. **Conflictos:** gana el `actualizadaEn` más reciente. Las escrituras que llegan de la nube no reescriben su marca, así que no se retroalimentan.
7. **Datos iniciales:** una cuenta nueva sin datos locales ni remotos recibe los cursos y tareas de ejemplo; si ya había datos locales sin dueño, se adoptan.

## Alternativas descartadas

- **Guardar todo solo en Firestore:** la app dejaría de funcionar sin conexión y habría que reescribir la UI.
- **Base local distinta por usuario:** obliga a reabrir la base al cambiar de sesión y complica el arranque; se prefirió una columna de dueño.
- **Tombstones y cola de pendientes:** más correcto para borrados sin conexión, pero aumenta la migración y las pruebas. Se acepta la limitación y se documenta.
- **Plugin `google-services` de Gradle:** con AGP 9 era un riesgo de build; `Firebase.initializeApp(options: ...)` con `firebase_options.dart` basta para Auth y Firestore.

## Consecuencias

- La app exige sesión en web y Android; en escritorio sigue funcionando en modo local (Firebase no está soportado).
- Las pantallas no son reactivas a cambios remotos en vivo: se refrescan al cambiar de pestaña o con «Sincronizar».
- El Premium sigue siendo local por cuenta; no se sincroniza.
- `lib/firebase_options.dart` se commitea (no es un secreto); la seguridad depende de `firestore.rules`.
- Sin conexión, las escrituras locales se conservan; en Android Firestore encola también las remotas. En web, un borrado hecho sin conexión podría no subir si se cierra la app antes de reconectar.
