# Mis Tareas - Laboratorio S16, pareja B

Esta es la aplicación de trabajo: Proyectos aparte/Mis Tareas. Conserva la pantalla Inicio, paleta morada y fuente de sistema originales. Se agregó Cursos como cuarta opción de la barra inferior; los otros botones mantienen su alcance anterior.

## Ejecutar en esta carpeta

```powershell
flutter pub get
flutter run -d chrome
```

## Validar

```powershell
dart format --output=none --set-exit-if-changed lib test
dart analyze lib test
flutter test --no-pub
```

Cursos incluye formulario crear/editar con callback y conservación del id, listado consultado mediante provider e invalidación tras operaciones, búsqueda, filtros, estados de carga/error/vacío, borrado condicionado a tareas, opción Archivar, duplicados con mensaje humano y Deshacer.

**El DAO actual es una demostración en memoria: cerrar/reiniciar pierde los cambios.** La persistencia SQLite y migración corresponden a A y aún no están integradas. El contrato provisional está en docs/contrato-pareja-a.md y el borrador local de PR en docs/pr-pareja-b-crud.md. No se operó GitHub.

No usar la carpeta Laboratorio S16 - Cursos: fue una ubicación equivocada. Los archivos nativos, nombre de paquete y configuración de esta app se conservan. No copiar caches de otra app. Ver docs/verificacion-pareja-b.md para las comprobaciones y el error de ruta Windows.
