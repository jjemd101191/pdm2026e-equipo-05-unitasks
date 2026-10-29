# Verificación de la corrección - 2026-10-29

## Ubicación y diseño

Trabajo integrado en Proyectos aparte/Mis Tareas. Se mantiene MyApp, Inicio, paquete flutter_application_1, las tres tarjetas y prueba original. Las constantes de color se extrajeron sin cambiar valores a lib/theme.dart; ThemeData conserva fondo FC F B FF (0xFFFCFBFF), semilla morada 0xFF7352D6 y fuente predeterminada. Se añadió la entrada Cursos a la barra inferior. Ningún archivo previo de las plataformas fue sobrescrito.

## Error de arranque reproducido

Se ejecutó flutter run -d chrome en la copia equivocada Laboratorio S16 - Cursos y falló exactamente al listar ios/Flutter/ephemeral/Packages/FlutterGeneratedPluginSwiftPackage/Sources/FlutterGeneratedPluginSwiftPackage. flutter run -d chrome --no-pub sí arrancó; esto aisló el fallo al recorrido/regeneración previo de dependencias.

La ruta completa allí mide 261 caracteres. os.path.isdir(ruta) devuelve false, mientras os.path.isdir con prefijo de Windows \\?\ devuelve true: el directorio existe y el acceso normal tropieza con la longitud de ruta. En Mis Tareas mide 247 caracteres y ambas comprobaciones devuelven true. No se modificó la configuración de rutas largas de Windows ni se copió ephemeral.

## Resultado

- flutter pub get: correcto en Mis Tareas.
- dart analyze lib test: No issues found.
- dart format --output=none --set-exit-if-changed lib test: 15 archivos, 0 cambios.
- flutter test --no-pub: 20 pruebas aprobadas, incluida la prueba original intacta.
- flutter run -d chrome --web-port=52816: arrancó en Chrome desde Mis Tareas; enlazado al servicio de depuración y ejecución de main confirmada.
- Recorrido de navegador real: Inicio original, entrada Cursos, crear curso de prueba, buscar, tocar y abrir formulario precargado, editar y guardar, duplicado con mensaje humano sin cerrar formulario, eliminar registro temporal, Deshacer, bloqueo de curso con 12 tareas, archivado y visualización en Archivados.
- Revisión visual a 390 x 844 y ancho normal del navegador. Sin errores ni advertencias registrados por la consola durante el recorrido.
- Comprobación de integridad del Proyecto final por SHA-256 y comparación de archivos nativos/web previos y prueba original de Mis Tareas: sin cambios.

La recarga restableció los datos demo: no quedaron registros de prueba persistentes. Sigue pendiente integrar el DAO SQLite y migración de A y probar en Android; no se afirma persistencia real. No se operó GitHub ni se cambiaron sus workflows.
