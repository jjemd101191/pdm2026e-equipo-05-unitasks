# Borrador local: CRUD de cursos - Pareja B

## Qué cambia

Crear y editar cursos usa el mismo formulario, conserva el id y refresca la consulta por invalidación. Borrar consulta las tareas asociadas y ofrece Archivar cuando el curso está en uso. Los duplicados muestran un mensaje humano y no descartan lo escrito. Todo está aislado en Proyectos aparte/Mis Tareas y usa el tema morado de Mis Tareas.

## Summary

```text
Formulario -> callback guardar -> DAO -> invalidar cursosProvider -> listado
Borrar -> tareasDe(id) -> eliminar si está libre / ofrecer Archivar si está en uso
```

## Cómo probarlo

Desde esta aplicación: flutter pub get, dart analyze lib test y flutter test --no-pub. Luego ejecutar la app y seguir los pasos manuales del README. Confirmar especialmente que tocar una tarjeta precarga el formulario y que guardar conserva el id.

## Evidence

- Antes: el formulario devolvía el registro al cerrar y el listado mutaba su lista en memoria; el borrado no consultaba tareas.
- Después: 20 pruebas aprobadas; prueba de widget crea/edita y verifica id estable y nueva consulta al DAO; se prueban errores, duplicados, archivado y ambas entradas de borrado.
- Capturas estructurales generadas por test en build/evidencias. Recorrido visual confirmado en navegador con tipografía real; ejecución en teléfono pendiente.

## Checklist del autor

- [x] Pruebas de widget y reglas con DAO falso.
- [x] El formulario no conoce SQL ni providers.
- [x] Bitácora de IA local.
- [ ] Conectar el DAO SQLite de A y acordar sus firmas.
- [ ] Probar persistencia y migración real de A.
- [ ] Probar en dispositivo o emulador.
- [ ] Incluir esta carpeta en CI y obtener revisión de la otra pareja.

## Para quien revisa

Revisar docs/contrato-pareja-a.md. El DAO actual es una demo en memoria: no presentar este borrador como la entrega S16 completa. No se ha publicado este PR ni se ha operado GitHub.

## Merge Danger

**Door:** reversible para esta copia de demostración.

**Blast Radius:** local.

Solo incorpora una aplicación nueva en Proyectos aparte. Integrar SQLite requiere revisar esquema, id, unicidad y borrado atómico con la pareja A antes de instalar sobre datos reales.
