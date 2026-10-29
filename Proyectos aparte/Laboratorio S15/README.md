# Laboratorio S15 · Mi bolsillo

Aplicación Flutter del Equipo 05 para el laboratorio de **navegación, filtros y
borrado con Deshacer**. Usa Riverpod y un `IndexedStack` para conservar el estado
y el desplazamiento de cada pantalla.

## Funcionalidad

- Cuatro pestañas: Inicio, Presupuesto, Historial y Ajustes.
- La pestaña activa vive en `navigationProvider` (`Notifier`). Ningún botón de la
  barra queda sin acción: Presupuesto y Ajustes muestran «Próximamente».
- «Ver todo» en Inicio cambia la pestaña mediante el mismo provider, sin pasar
  callbacks por constructores ni apilar otra ruta.
- Historial consulta 48 movimientos desde un repositorio en memoria con
  `Future.delayed` y muestra los estados de carga, error con Reintentar, vacío y
  datos.
- Filtro inmutable (`MovementFilter`) en `movementFilterProvider`. El provider
  de la lista hace `ref.watch` del filtro y de los movimientos, así que el
  listado se recalcula al cambiar categoría, mes o texto, sin botón de recarga.
- Deslizar una fila la borra primero en el repositorio; si el borrado falla, la
  fila vuelve. El `SnackBar` ofrece **Deshacer**, que restaura el registro con el
  mismo `id` y sus mismos datos en la posición original.

## Entorno y ejecución

Verificado con Flutter **3.44.8 stable**, Dart **3.12.2** y Git **2.52.0**.

```powershell
flutter pub get
flutter run -d chrome
```

Para verificar o compilar:

```powershell
flutter analyze
flutter test
flutter build web --release
```

Android conserva su estructura estándar, pero no fue configurado ni compilado.
La app no requiere componentes de Visual Studio para ejecutarse en Chrome.

## Dependencias

- `flutter`: SDK.
- `flutter_riverpod: ^3.4.3`: navegación, filtro y datos.
- `flutter_test`: SDK, pruebas de widgets.
- `flutter_lints: ^6.0.0`: reglas de análisis incluidas por la plantilla.

`pubspec.lock` fija las versiones resueltas.

## Cómo funciona

1. `main.dart` instala `ProviderScope` alrededor de la aplicación.
2. `NavigationNotifier` extiende `Notifier<AppTab>`; `navigationProvider` expone
   la pestaña activa. La barra y «Ver todo» llaman al mismo Notifier.
3. `MainScreen` observa la pestaña y cambia el índice de `IndexedStack`, que
   mantiene montadas las cuatro pantallas y conserva su `State`.
4. `MovementsNotifier` extiende `AsyncNotifier<List<Movement>>` y consulta
   `MovementRepository`. `AsyncValue` permite distinguir carga, error y datos.
5. `MovementFilterNotifier` guarda un `MovementFilter` inmutable.
   `filteredMovementsProvider` hace `ref.watch` del filtro y de la fuente; al
   cambiar cualquiera de los dos, la lista visible se recalcula sola.
6. `HistoryScreen` envuelve cada fila en un `Dismissible` con
   `ValueKey(movement.id)`. `confirmDismiss` borra en el repositorio y devuelve
   `false` si falla; `onDismissed` retira la fila del estado y muestra el
   `SnackBar` con Deshacer.
7. Historial mantiene un `ScrollController` en su `State` y lo libera en
   `dispose`. La lista tiene una `PageStorageKey` estable.

El orden compartido es: **Inicio (0), Presupuesto (1), Historial (2), Ajustes (3)**.

## Responsabilidad de cada archivo

| Archivo | Propósito |
| --- | --- |
| lib/main.dart | Inicia Flutter con ProviderScope. |
| lib/app/app.dart | MaterialApp y tema visual. |
| lib/providers/navigation_provider.dart | AppTab, NavigationNotifier y provider. |
| lib/models/movement.dart | Modelo inmutable con ID, fecha y monto en centavos. |
| lib/models/movement_filter.dart | Filtro inmutable por categoría, mes y texto. |
| lib/data/sample_movements.dart | 48 movimientos fijos de demostración. |
| lib/data/movement_repository.dart | Contrato del repositorio y versión en memoria. |
| lib/providers/movements_provider.dart | AsyncNotifier con carga, borrado y restauración. |
| lib/providers/movement_filter_provider.dart | Filtro, lista filtrada, categorías y meses. |
| lib/screens/main_screen.dart | Scaffold, IndexedStack y barra inferior. |
| lib/screens/home_screen.dart | Encabezado, tarjeta, últimos movimientos y Ver todo. |
| lib/screens/history_screen.dart | Filtros, estados, lista, Dismissible y Deshacer. |
| lib/screens/coming_soon_screen.dart | Contenido reutilizable para Presupuesto y Ajustes. |
| lib/widgets/app_bottom_navigation.dart | Las cuatro opciones de navegación con Riverpod. |
| lib/widgets/movement_tile.dart | Presentación de un movimiento. |
| lib/widgets/status_view.dart | Mensajes de estado vacío y error con acción. |
| test/navigation_test.dart | Pestañas, Ver todo, scroll y ancho móvil. |
| test/movement_states_test.dart | Error de carga y Reintentar. |
| test/movement_filter_test.dart | Cambio de filtro y estado vacío. |
| test/movement_delete_test.dart | Borrar y Deshacer; fallo del repositorio. |
| docs/bitacora-ia.md | Registro de trabajo con IA y resultados reales. |
| docs/estructura-proyecto.txt | Árbol de archivos del proyecto. |
| docs/pr-navegacion.md | Borrador histórico del PR de navegación. |
| docs/verificacion-navegacion.md | Comparación de la navegación con la rúbrica. |

## Pruebas

```powershell
flutter test
```

La suite cubre 10 casos:

- 5 de navegación: pestañas, «Ver todo», conservación del scroll y ancho de 320 px.
- 1 de estados: error con Reintentar y recuperación de los datos.
- 2 de filtro: cambio de categoría sin recargar y estado vacío con limpieza.
- 2 de borrado: deslizar, Deshacer con el mismo id y fila que permanece si falla.

Resultado del 28/10/2026: `dart format` sin cambios pendientes, `flutter analyze`
sin observaciones y **10 pruebas en verde**.

## Comprobación manual

1. Abrir Historial y desplazarse hacia abajo.
2. Cambiar a Inicio y regresar: se mantiene la posición.
3. Volver a Inicio y pulsar **Ver todo**: queda seleccionada Historial.
4. Elegir una categoría o un mes: la lista cambia sola; buscar un texto sin
   coincidencias muestra el estado vacío y **Limpiar filtro** lo restablece.
5. Deslizar un movimiento y pulsar **Deshacer**: vuelve con los mismos datos.
6. Abrir Presupuesto y Ajustes: ambos muestran «Próximamente».

## Limitaciones

La app no tiene base de datos todavía. `DemoMovementRepository` mantiene la lista
en memoria, por lo que un borrado o una restauración se conservan mientras vive
el proceso, pero no sobreviven al cierre completo de la aplicación. El alcance de
la S15 permite esta alternativa. La edición de registros corresponde a la S16.

## Git

La navegación se integró en el PR #10. El filtro, los estados y el borrado con
Deshacer se entregan desde la rama `feat/s15-filtro-estados-borrado` con commits
atómicos por requisito (estados, filtro, borrado/Deshacer, CI y documentación).

## Referencias

[Riverpod: providers](https://riverpod.dev/docs/concepts2/providers) y
[Flutter: IndexedStack](https://api.flutter.dev/flutter/widgets/IndexedStack-class.html).
