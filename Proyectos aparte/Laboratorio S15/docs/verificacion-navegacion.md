# Verificación del integrante 1 - Pareja A

Fecha: 23/10/2026. Proyecto: Mi bolsillo. Herramienta: Codex.

## Alcance y fuente

Se revisaron las dos páginas de `Lab4 E.pdf`, ubicado en la carpeta superior.
El documento asigna 1.00 punto al criterio Navegación: pestaña en un provider,
IndexedStack o go_router y navegación desde otra pantalla. Sus pruebas obligatorias
1 y 2 piden que la barra funcione, conservar el scroll y que Ver todo abra el listado.

El PDF describe responsabilidades del equipo; no enumera integrantes individuales.
La asignación exclusiva al integrante 1 de la Pareja A proviene de las instrucciones
del usuario. Los filtros, estados de datos, borrado, Deshacer y sus pruebas se dejan
a los demás integrantes. No se asegura una calificación: el docente revisa la entrega.

## Matriz de cumplimiento

| Requisito del integrante 1 | Estado | Evidencia |
| --- | --- | --- |
| Pestaña activa en provider con Notifier | Cumplido | navigation_provider.dart: Notifier<AppTab> y NotifierProvider. |
| Método para cambiar de pestaña | Cumplido | selectTab asigna state. |
| Interfaz reactiva con ref.watch | Cumplido | MainScreen y AppBottomNavigation observan navigationProvider. |
| Acciones mediante ref.read | Cumplido | Barra y Ver todo llaman al Notifier. |
| Sin callbacks de navegación por constructores | Cumplido | Ninguna pantalla recibe funciones de navegación. |
| Índices consistentes y válidos | Cumplido | Enum de cuatro valores; coincide con barra y stack; pruebas contrastan los tres. |
| Cuatro pantallas en IndexedStack | Cumplido | Inicio, Presupuesto, Historial y Ajustes. |
| Todos los botones de la barra funcionan | Cumplido | Prueba recorre las cuatro opciones y verifica estado y pantalla. |
| Presupuesto y Ajustes muestran Próximamente | Cumplido | Prueba verifica pantalla y contenido visible. |
| Ver todo selecciona Historial y la barra | Cumplido | Verifica provider, índice, lista visible y ausencia de nueva ruta. |
| Scroll conservado al regresar | Cumplido | Misma instancia de ScrollableState y mismo valor exacto de pixels. |
| IDs estables y modelo separado | Cumplido | Movement y datos fijos mov-001 a mov-048. |
| Integración documentada | Cumplido | README: conexión del filtro y Dismissible. |
| Bitácora de IA | Cumplido | Se conserva el historial y se añade esta revisión. |
| Rama y commit local | Cumplido | Trabajo en feat/navegacion; main conserva su commit base. |
| Descripción del PR | Cumplido | docs/pr-navegacion.md, borrador sin publicar. |

## Qué se cambió

No se modificó ningún archivo de lib/, el diseño, el modelo ni las dependencias:
la implementación existente cumplía la navegación solicitada.

- Se amplió test/navigation_test.dart para contrastar provider, barra e IndexedStack,
  verificar contenido de Próximamente y del listado, igualdad exacta del scroll y
  reacción ante cambios directos del provider.
- Se conservan las cuatro pruebas anteriores y se añade una quinta.
- Se actualizó README.md con puntos concretos para Integrante 2 e Integrante 3.
- Se añadieron este informe y el borrador docs/pr-navegacion.md.
- Se actualizaron la bitácora y el árbol de archivos.

## Explicación para el estudiante

**Notifier:** clase que mantiene el estado y ofrece métodos para cambiarlo.
NavigationNotifier guarda un AppTab. ref.watch observa el valor y actualiza la
interfaz cuando cambia. El enum limita los valores a las cuatro pestañas.

**IndexedStack:** mantiene sus hijos montados y muestra el hijo del índice activo.
Cambiar de pestaña no destruye el State de Historial.

**Ver todo:** llama a ref.read(navigationProvider.notifier).selectTab(AppTab.history).
La barra y MainScreen observan ese mismo provider, por lo que ambos cambian juntos.
No utiliza Navigator.push ni recibe funciones por constructor.

**Scroll:** ScrollController se crea una sola vez en el State de Historial y se libera
en dispose. IndexedStack conserva ese State y PageStorageKey identifica la lista.
Las pruebas desplazan más de 500 píxeles, recorren las otras tres pestañas y vuelven
por barra y por Ver todo; verifican identidad del State y posición exactamente igual.
No se promete conservar ese scroll tras cerrar la aplicación.

## Validaciones realizadas en esta revisión

- flutter pub get: correcto; sin nuevas dependencias.
- flutter analyze: No issues found (2.8 s en la ejecución final).
- flutter test: 5 pruebas aprobadas; 0 fallos.
- dart format test/navigation_test.dart: sin cambios pendientes en la ejecución final.

Pruebas:
1. Las cuatro pestañas cambian la pantalla y la selección.
2. Ver todo selecciona Historial sin apilar otra ruta.
3. Historial conserva el scroll al volver por barra y Ver todo.
4. La interfaz reacciona al provider sin pulsar la barra.
5. La interfaz funciona en un móvil de 320 píxeles.

En la primera ejecución de la prueba nueva hubo un fallo en el finder:
ValueKey<String?> no coincide con ValueKey<String>. Se corrigió la lectura del
mapa con la comprobación no nula; después se repitieron pub get, analyze y test.
No se eliminó ninguna prueba. No se detectó un fallo del código de la aplicación.

Esta revisión valida comportamiento con WidgetTester y ProviderScope.
No se realizó una nueva inspección visual en Chrome ni una nueva compilación web;
la compilación web correcta de la fase anterior sigue registrada en la bitácora.

## Git y entrega del equipo

La rama de trabajo es feat/navegacion. main mantiene el commit
a7650f352f1c2e2dd05dea71788b7e302179930a.
El commit de esta revisión se puede consultar con git log -1 --oneline.

No hay remoto configurado ni workflow de CI en .github/workflows.
No se hizo push, merge ni apertura de PR.
Para abrir el PR se necesita que el usuario revise el resultado, facilite o cree el
repositorio del equipo y autorice publicar la rama. Para completar la entrega del
docente también faltan la plantilla del equipo, el CI de S14 en verde, revisión
de otra pareja y la integración por PR. Esto es proceso de entrega pendiente,
no funcionalidad pendiente del integrante 1.
