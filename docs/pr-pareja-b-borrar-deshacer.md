## Qué cambia

Agrega búsqueda reactiva de cursos por nombre o docente, una identidad estable para cada curso y borrado por deslizamiento con la acción «Deshacer». Si el repositorio falla al borrar, la fila permanece visible.

Cierra #<número-del-issue>

## Cómo probarlo

1. Ejecutar `flutter pub get` y `flutter test` desde `Proyecto final`.
2. En Cursos, buscar un curso por nombre o docente y confirmar que la lista se filtra sin botón de recarga.
3. Deslizar un curso hacia la izquierda, confirmar que desaparece y tocar «Deshacer»; comprobar que vuelve con el mismo id y datos.
4. Simular un fallo del repositorio al borrar y confirmar que el curso permanece.

## Capturas

Pendiente de captura en emulador/dispositivo.

## Checklist del autor

- [x] `dart format .` completado.
- [x] `flutter test --no-pub` en verde (10 pruebas).
- [ ] `flutter analyze` no concluyó: el servidor de análisis salió con código `-1073741816`.
- [ ] Probé en un dispositivo o emulador.
- [x] Sin SQL ni `http` dentro de widgets.
- [x] Sin `print` de depuración ni código comentado nuevo.
- [x] Entrada agregada a `docs/bitacora-ia.md`.
- [x] Sin cambios de arquitectura adicionales.

## Para quien revisa

Revisar que `Dismissible` usa `ValueKey(curso.id)`, que el repositorio elimina antes de confirmar el gesto y que el SnackBar restaura el curso con el mismo id. La lista sigue siendo de demostración en memoria; el laboratorio permite esta alternativa si aún no hay base de datos.

## Respuesta obligatoria: ¿por qué la key debe ser el id y qué pasa al borrar la fila 2 de 5?

Flutter usa la key para mantener la identidad de cada fila cuando reconstruye la lista. Con `ValueKey(curso.id)`, cada `Dismissible` sigue asociado al curso correcto. Si se usara el índice y se borrara la fila 2 de 5, las filas 3, 4 y 5 ocuparían otros índices; Flutter podría reutilizar el estado de una fila para otro curso, animar o descartar la fila equivocada y mezclar estados. Con el id estable, el cambio de posición no cambia la identidad.
