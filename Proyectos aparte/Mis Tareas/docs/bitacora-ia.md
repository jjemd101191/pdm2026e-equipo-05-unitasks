# Bitácora de uso de IA

## 2026-10-15 — Preparación local de S14

- Herramienta: Codex. Solicitud: evaluar y preparar únicamente la copia abierta, sin implementar CI ni Parte B, crear ramas, hacer commits o subir cambios.
- Inspección: estructura de las seis plataformas, pubspec.yaml y lockfile, lib/main.dart, test/widget_test.dart, configuración del analizador, metadatos Flutter, exclusiones Git y carpeta .github existente.
- Diagnóstico: Flutter 3.44.8 stable y Dart 3.12.2; prueba de contador de plantilla incompatible con la pantalla actual Mis Tareas; formato pendiente; ausencia de repositorio .git en esta copia o sus padres.
- Correcciones aplicadas: formato automático de lib/main.dart; adaptación de la única prueba existente para validar la pantalla actual, navegación visible y desplazamiento hasta la última tarea; exclusión de .flutter_tool_state. No se eliminó ningún archivo de pruebas ni se desactivaron verificaciones.
- Limpieza: flutter clean y eliminación de android/.gradle, limitada a una ruta absoluta comprobada dentro de esta copia. pub get y test regeneraron archivos necesarios.
- Validación final: pub get correcto y pubspec.lock sin cambios; formato correcto (2 archivos, 0 cambios pendientes); análisis sin incidencias; 1 prueba aprobada.
- Incidencia del entorno: el lanzador de comandos inicial falló; la ejecución alternativa limitada no pudo acceder al lockfile de la caché del SDK. Se completaron los comandos Flutter con ejecución elevada autorizada por el entorno. El SDK no se actualizó.
- Sugerencias descartadas o diferidas por las restricciones: actualización anunciada de Flutter; actualización de paquetes disponibles; eliminación de la prueba fallida o desactivación de análisis/pruebas; implementación de CI o Parte B; inicialización de Git o elección de remoto. Son decisiones de esta preparación, no rechazos adicionales expresados por el usuario.
- Se conservaron pantallas, dependencias, configuraciones de plataformas, ajustes del IDE, hooks anteriores de Java y metadatos. No se tocó ningún repositorio externo.
- Pendiente: decidir con el usuario cómo vincular esta copia al repositorio correcto y continuar la Parte A paso a paso.


## 2026-10-29 - Pareja B integrada en Mis Tareas

- Solicitud: corregir la ubicación del trabajo de B, usar exclusivamente esta app y conservar su pantalla, fuente y paleta morada. No operar GitHub.
- Se conserva Inicio y la prueba original; se añade Cursos como cuarta opción de navegación. Se integran el formulario compartido, copyWith con id estable, provider con invalidación, bloqueo de borrado, archivado, duplicados y DAO de demostración.
- Se corrigió el error anterior de trabajar sobre una copia del Proyecto final. No se trasladaron caches, archivos nativos ni metadatos desde aquella copia. Los colores de Cursos usan los valores originales de Mis Tareas y el ThemeData mantiene sus ajustes.
- Contrato de A todavía no recibido. No se inventó persistencia ni migración. No se implementa el CRUD de tareas ni acciones nuevas de Calendario/Agregar.
- Validación y causa del problema de arranque: ver docs/verificacion-pareja-b.md.
