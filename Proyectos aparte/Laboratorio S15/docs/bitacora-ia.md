# Bitácora de inteligencia artificial

- Fecha: 23 de octubre de 2026 (America/Guatemala).
- Herramienta: Codex.
- Objetivo: preparar el Laboratorio S15 y desarrollar únicamente la navegación del integrante 1 de la Pareja A.
- Autorización: el usuario confirmó crear un proyecto nuevo local, sin repositorio remoto, push ni merge.

## Entorno verificado

Flutter 3.44.8 stable, Dart 3.12.2, Git 2.52.0.windows.1.
La carpeta estaba vacía en la primera revisión. Antes de generar el proyecto apareció
el archivo local `.flutter_tool_state`, que se conservó.
No existía repositorio Git. Chrome está disponible.
Android tiene SDK 36.0.0, pero faltan cmdline-tools y aceptar licencias.
Windows carece de componentes de Visual Studio C++. No se modificaron esas instalaciones.

## Archivos y dependencias

Se generó la estructura estándar para web y Android mediante Flutter.
Se crearon las carpetas lib/app, lib/data, lib/models, lib/providers,
lib/screens, lib/widgets y test, además de esta bitácora.
README.md contiene la estructura y explica cada archivo.

Dependencia directa añadida: flutter_riverpod ^3.4.3.
La plantilla ya incluía flutter_test (SDK Flutter) y flutter_lints ^6.0.0.
pubspec.lock registra las versiones resueltas y las dependencias transitivas.

## Funcionalidades

- Cuatro pestañas: Inicio, Presupuesto, Historial y Ajustes.
- NavigationNotifier y NotifierProvider como estado compartido.
- IndexedStack para mantener montadas las cuatro pantallas.
- Ver todo cambia directamente la pestaña mediante Riverpod.
- Historial con 48 registros, IDs fijos y ScrollController persistente.
- PageStorageKey para identificar cada lista.
- Presupuesto y Ajustes muestran Próximamente.
- Sin filtros, borrado ni Deshacer.

## Incidencias y correcciones

- El lanzador de comandos restringido falló al iniciar. Se utilizó Node para leer
  archivos y se ejecutaron los comandos de Flutter con acceso a la caché del SDK.
- Flutter no podía abrir su lockfile con permisos restringidos; el diagnóstico
  con acceso al SDK confirmó la versión y permitió continuar.
- Un intento redundante de añadir flutter_test utilizó una combinación de opciones
  rechazada por pub. Se verificó que la plantilla ya declaraba esa dependencia.
- La primera generación de código encontró un error de interpolación de JavaScript
  antes de escribir archivos; se corrigió el mecanismo de escritura.

## Decisiones y sugerencias

No hubo sugerencias rechazadas por el usuario. Se respetó su decisión de preparar
Chrome y conservar Android sin configurarlo todavía. No se instalaron paquetes
de rutas, generadores ni componentes de filtros o eliminación.

## Pruebas

Resultados ejecutados con Flutter 3.44.8:

- `flutter pub get`: correcto.
- `dart format lib test`: 13 archivos procesados.
- `flutter analyze`: No issues found (87.1 s).
- `flutter test`: 4 pruebas aprobadas (6 s de ejecución tras la carga inicial).
  1. Cambio entre las cuatro pestañas y selección de la barra.
  2. Ver todo selecciona Historial sin añadir una ruta.
  3. Scroll preservado al volver por la barra y por Ver todo.
  4. Interfaz sin excepciones en ancho de 320 píxeles.
- `flutter build web --release`: correcto; salida en build/web (111.2 s).
- La compilación mostró una advertencia de fuente CupertinoIcons. Esta app usa
  únicamente Material Icons; no hubo errores de compilación ni de análisis.
- Android y Windows no se compilaron. No se verificó visualmente una sesión de Chrome;
  la validación realizada incluye pruebas de widgets y compilación web.

No fue necesario corregir errores de Dart ni fallos de las pruebas.

## Git local

Se inicializó el repositorio y se trabajó en feat/navegacion.
main apunta al commit base vacío; la implementación se guarda en un commit local
en feat/navegacion. No hay remoto configurado, push, merge ni Pull Request.
El archivo local .flutter_tool_state se conservó y se excluyó del versionado.

## Revisión final contra Lab4 E.pdf - 23/10/2026

- Herramienta: Codex.
- Objetivo: comprobar y finalizar exclusivamente la navegación del integrante 1
  de la Pareja A sobre el proyecto existente.
- Fuente: se extrajo el texto de las dos páginas de Lab4 E.pdf con pypdf.
  Se identificaron el criterio Navegación (1.00 punto), los requisitos 1 y 2
  y las pruebas obligatorias 1 y 2. El documento distribuye requisitos a nivel
  del equipo; el alcance individual lo estableció el usuario.
- Estado inicial: árbol Git limpio, rama feat/navegacion, commit 62448a9.
  main apuntaba a a7650f352f1c2e2dd05dea71788b7e302179930a.
- Hallazgo: la navegación de lib/ ya cumplía los requisitos. Se conservaron todos
  sus archivos, el diseño, el modelo, los datos y las dependencias.

### Cambios y archivos

- Modificado test/navigation_test.dart: comprobación directa del provider,
  concordancia con barra e IndexedStack, contenido visible de Próximamente/listado,
  persistencia exacta del scroll y misma instancia del State desde todas las pestañas.
- Añadida una quinta prueba para cambiar el Notifier directamente y verificar
  la reacción de la interfaz. Se conservaron las cuatro pruebas anteriores.
- Modificado README.md: integración concreta del filtro para Integrante 2 y de
  Dismissible para Integrante 3, referencias a informe y borrador de PR.
- Creados docs/verificacion-navegacion.md y docs/pr-navegacion.md.
- Modificados docs/estructura-proyecto.txt y esta bitácora.

### Correcciones y decisiones

La primera ejecución final obtuvo análisis sin problemas, pero falló la prueba nueva
porque el finder construía una ValueKey<String?> a partir de una lectura de mapa.
Las claves reales eran ValueKey<String>. Se corrigió el finder con la lectura no nula
del mapa y se repitieron todas las validaciones solicitadas. El fallo no procedía de
la navegación de la app. No se eliminaron pruebas ni se añadieron dependencias.

No hubo sugerencias rechazadas por el usuario. Se mantuvo el alcance exclusivo de
navegación y no se implementaron filtros, borrado, Deshacer, edición ni CI nuevo.
El CI de S14 y la plantilla del equipo deberán conectarse cuando exista su repositorio.

### Resultados finales ejecutados

- dart format test/navigation_test.dart: sin cambios pendientes.
- flutter pub get: correcto.
- flutter analyze: No issues found (2.8 s).
- flutter test: All tests passed, 5 pruebas, 0 fallos.
- Se comprobó igualdad exacta de position.pixels, no solo una tolerancia aproximada,
  al retornar desde Inicio, Presupuesto, Ajustes y Ver todo.
- No se repitió la compilación web: esta revisión no modifica lib/, assets ni pubspec.
- No se realizó una inspección visual nueva en Chrome.
- Informe y borrador del PR preparados localmente, sin publicarlos.

### Git y pendientes de entrega

Se guarda esta revisión en un commit descriptivo de feat/navegacion, limitado a
pruebas y documentación propias. El hash se consulta con git log -1 --oneline.
main debe conservar a7650f352f1c2e2dd05dea71788b7e302179930a.
No se configura remoto ni se ejecuta push, merge o apertura de PR.

Pendiente externo: revisión del usuario, repositorio del equipo y autorización de
publicación. Para la entrega completa del docente faltarán el PR con la plantilla del
equipo, el CI de S14 en verde y revisión de otra pareja. No se confunden las pruebas
locales aprobadas con CI remoto ejecutado.

---

## 28 de octubre de 2026 · completar filtro, estados y borrado con Deshacer

- **Herramienta:** Claude Code (asistente de código).
- **Especificación:** "Verifica qué falta del Laboratorio S15 y completa la carpeta
  del laboratorio con filtro inmutable, estados de UI, borrar con Deshacer y sus
  pruebas, con commits atómicos y un PR con la plantilla."
- **Resultado:** `MovementFilter` inmutable, `MovementFilterNotifier`,
  `filteredMovementsProvider` con `ref.watch`, estados de carga/error/vacío/datos,
  `Dismissible` con `key = id` y `SnackBar` de Deshacer, además de diez pruebas.
- **Aceptado:** el repositorio en memoria con `Future.delayed` como fuente, porque
  el alcance permite esa alternativa; borrar en el repositorio antes de confirmar
  el gesto; restaurar el mismo objeto con el mismo `id`; y un job de CI propio para
  la carpeta del laboratorio.
- **Rechazado / corregido:** se descartó duplicar el trabajo en `Proyecto final`,
  que ya tiene su filtro y su borrado, y se mantuvo el alcance en esta carpeta; se
  descartó añadir una base de datos nueva, de modo que la persistencia entre
  cierres completos queda documentada como limitación.
- **Verificación:** `dart format lib test` sin cambios pendientes; `flutter analyze`
  sin observaciones; `flutter test` con 10 pruebas en verde.
- **Commit / PR:** commits 702bfbf, d4c0b9f, c1f940b y efcd914 en la rama
  `feat/s15-filtro-estados-borrado`; el PR se abre desde esa rama.
