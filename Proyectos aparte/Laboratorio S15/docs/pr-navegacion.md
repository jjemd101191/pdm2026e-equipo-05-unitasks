# Borrador de Pull Request

Título sugerido: feat: navegación reactiva con Riverpod y conservación del scroll

Base prevista: main. Rama: feat/navegacion. No publicado.

## Objetivo

Completar el criterio Navegación (1 punto) del laboratorio S15:
navegación entre Inicio, Presupuesto, Historial y Ajustes con estado compartido,
y acceso al listado desde Inicio.

## Cambios de la rama completa

- NavigationNotifier y NotifierProvider para la pestaña activa.
- Barra inferior y Ver todo actualizan el provider mediante ref.read.
- MainScreen usa ref.watch e IndexedStack.
- Presupuesto y Ajustes muestran Próximamente.
- Historial tiene 48 movimientos de demostración con IDs estables.
- ScrollController persistente y PageStorageKey para conservar el scroll.
- Modelo y widgets separados; puntos de integración documentados.
- Cinco pruebas de widgets y bitácora de IA.
- En la revisión final se reforzaron pruebas y documentación; el código de lib/
  ya cumplía los requisitos y no se modificó.

## Pruebas ejecutadas

- [x] flutter pub get.
- [x] flutter analyze: sin problemas.
- [x] flutter test: 5 pruebas aprobadas.
- [x] Compilación web release en la fase inicial, registrada en bitácora.
- [ ] CI de S14 en el repositorio del equipo: pendiente de disponer del repositorio.
- [ ] Revisión de otra pareja.

## Evidencia de navegación

test/navigation_test.dart pulsa las cuatro opciones y contrasta el estado del
provider, la selección de la barra, el índice del stack y el contenido visible.
Ver todo verifica además que se ve el listado y que Navigator no tiene una ruta
adicional. Otra prueba cambia el Notifier directamente y observa la actualización
de la interfaz sin pulsar la barra.

## Evidencia de conservación del scroll

La prueba desplaza Historial más de 500 píxeles. Luego visita Presupuesto, Ajustes
e Inicio, regresando a Historial desde cada pantalla. También regresa por Ver todo.
Comprueba la misma instancia de ScrollableState y la igualdad exacta de
position.pixels en todos los retornos.

## Integración y limitaciones

- Los datos son de ejemplo y están en memoria. No hay persistencia ni repositorio real.
- El balance mostrado en Inicio es ilustrativo.
- Los filtros corresponden al Integrante 2; Dismissible y Deshacer al Integrante 3.
- Sus pruebas y los estados de carga/error/vacío se integrarán con esas funciones.
- Android conserva su estructura pero no se ha configurado ni compilado.
- La revisión final usa WidgetTester; no contiene capturas ni verificación visual
  nueva de Chrome.
- El scroll se conserva entre pestañas durante la sesión, no tras cerrar la app.

## Proceso y revisión

Este documento es un borrador local, no un PR abierto.
Antes de publicarlo: revisar resultados con el usuario, conectar el repositorio del
equipo con autorización, adaptar esta descripción a su plantilla y ejecutar el CI.
La entrega del docente exige CI de S14 en verde y revisión de otra pareja.
No se ha hecho push ni merge.
