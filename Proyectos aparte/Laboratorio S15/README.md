# Laboratorio S15 · Mi bolsillo

Navegación del **integrante 1 de la Pareja A**, Universidad Mesoamericana.
Aplicación de ejemplo con cuatro pestañas, Riverpod y conservación del scroll.
No incluye filtros, borrado ni Deshacer.

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

La compilación web queda en `build/web/`. No abras index.html con file://:
usa `flutter run -d chrome` o un servidor HTTP.

Android conserva su estructura estándar, pero no fue configurado ni compilado.
Antes de usarlo habrá que instalar Android SDK Command-line Tools desde
Android Studio y aceptar las licencias con `flutter doctor --android-licenses`.
La app no requiere componentes de Visual Studio para ejecutarse en Chrome.

## Dependencias

- `flutter`: SDK.
- `flutter_riverpod: ^3.4.3`: estado de navegación y acceso a datos.
- `flutter_test`: SDK, pruebas de widgets.
- `flutter_lints: ^6.0.0`: reglas de análisis incluidas por la plantilla.

`pubspec.lock` fija las versiones resueltas. No se añadieron paquetes de rutas,
generación de código, fuentes ni recursos externos.

## Cómo funciona

1. `main.dart` instala `ProviderScope` alrededor de la aplicación.
2. `NavigationNotifier` extiende `Notifier<AppTab>`. Un Notifier guarda un estado
   y expone métodos para modificarlo. `build()` devuelve la pestaña inicial;
   `selectTab()` asigna el nuevo valor a `state`.
3. `navigationProvider` expone ese estado. `ref.watch` observa cambios y reconstruye
   los widgets que lo necesitan; `ref.read(...notifier)` permite llamar a sus métodos.
4. La barra inferior y el botón **Ver todo** llaman al mismo Notifier.
   No se pasan callbacks de navegación por constructores y no se usa Navigator.push.
5. `MainScreen` observa la pestaña y cambia el índice de `IndexedStack`.
   Este widget mantiene sus hijos montados y muestra solo el correspondiente al índice.
   Así no se destruye el estado al cambiar de pestaña.
6. Historial mantiene un `ScrollController` en su State y lo libera en `dispose`.
   La lista tiene una `PageStorageKey` estable. Hay 48 movimientos para probar
   el desplazamiento.

El orden compartido es: **Inicio (0), Presupuesto (1), Historial (2), Ajustes (3)**.

Desde cualquier ConsumerWidget se puede navegar con:

```dart
ref.read(navigationProvider.notifier).selectTab(AppTab.history);
```

El balance de Inicio es un valor ilustrativo, no el total calculado del historial.
Los registros tienen fechas fijas y montos en centavos.

## Responsabilidad de cada archivo

| Archivo | Propósito |
| --- | --- |
| lib/main.dart | Inicia Flutter con ProviderScope. |
| lib/app/app.dart | MaterialApp y tema visual. |
| lib/providers/navigation_provider.dart | AppTab, NavigationNotifier y provider. |
| lib/providers/movements_provider.dart | Punto de acceso compartido a los movimientos. |
| lib/models/movement.dart | Modelo inmutable con ID, fecha y monto en centavos. |
| lib/data/sample_movements.dart | 48 movimientos fijos de demostración. |
| lib/screens/main_screen.dart | Scaffold, IndexedStack y barra inferior. |
| lib/screens/home_screen.dart | Encabezado, tarjeta, últimos movimientos y Ver todo. |
| lib/screens/history_screen.dart | Historial y conservación del desplazamiento. |
| lib/screens/coming_soon_screen.dart | Contenido reutilizable para Presupuesto y Ajustes. |
| lib/widgets/app_bottom_navigation.dart | Las cuatro opciones de navegación con Riverpod. |
| lib/widgets/movement_tile.dart | Presentación de un movimiento. |
| test/navigation_test.dart | Pruebas de pestañas, Ver todo, scroll y ancho móvil. |
| docs/bitacora-ia.md | Registro de trabajo con IA y resultados reales. |
| docs/estructura-proyecto.txt | Árbol completo de archivos, sin cachés ni metadatos internos de Git/IDE. |
| pubspec.yaml / pubspec.lock | Dependencias declaradas y resueltas. |
| analysis_options.yaml | Configuración de análisis de la plantilla. |
| android/ / web/ | Archivos de plataforma generados por Flutter. |

## Integración con los compañeros

`movementsProvider` es por ahora un Provider de solo lectura. El equipo podrá
sustituirlo por un Notifier de movimientos o por su repositorio de datos.
Inicio e Historial ya lo observan, por lo que pueden compartir la misma fuente.

Para los filtros, se puede añadir un provider separado con los criterios y otro
con la lista visible que consuma Historial. Para borrar y Deshacer, el responsable
puede añadir los métodos de modificación al estado de movimientos.
Conservar `Movement.id` y `ValueKey(movement.id)` permite identificar registros
sin depender del índice de la lista. El ID no debe cambiar al filtrar o restaurar.

Mantener el orden de AppTab y los hijos de IndexedStack, así como el State y la
clave de la lista, evita perder la navegación o el scroll durante la integración.
Una eliminación que reduzca la longitud de la lista puede ajustar el scroll al
nuevo límite; eso se verificará al implementar esa funcionalidad.

## Git

Desarrollo local en `feat/navegacion`, con `main` como base.
No se configuró remoto ni se hizo push, merge o Pull Request.
El PR podrá crearse cuando el equipo disponga de repositorio y autorice publicarlo.

```powershell
git branch
git status
git log --oneline --all --decorate
```

## Comprobación manual del laboratorio

1. Abrir Historial y desplazarse hacia abajo.
2. Cambiar a Inicio y regresar a Historial: se mantiene la posición.
3. Volver a Inicio y pulsar Ver todo: queda seleccionada Historial con el mismo scroll.
4. Abrir Presupuesto y Ajustes: ambos muestran Próximamente.

Las pruebas automatizadas reproducen estas acciones y verifican que Ver todo
no apila otra ruta. Los resultados de ejecución constan en la bitácora.

Referencias: [Riverpod: providers](https://riverpod.dev/docs/concepts2/providers)
y [Flutter: IndexedStack](https://api.flutter.dev/flutter/widgets/IndexedStack-class.html).

Validación realizada el 23/10/2026: análisis sin problemas, 4 pruebas aprobadas
y compilación web release correcta. Android y Windows no fueron compilados.

## Revisión final del integrante 1

La comparación con la rúbrica de Lab4 E.pdf y la evidencia están en
[docs/verificacion-navegacion.md](docs/verificacion-navegacion.md).
El borrador local del PR está en [docs/pr-navegacion.md](docs/pr-navegacion.md).
La última validación completó pub get, analyze sin problemas y **5 pruebas aprobadas**.

### Conexión del filtro - Integrante 2

En `lib/providers/movements_provider.dart` está la fuente compartida. El integrante
puede añadir un Notifier para el filtro inmutable y un provider dependiente que haga
`ref.watch` del filtro y del repositorio. En `lib/screens/history_screen.dart`,
la lectura `ref.watch(movementsProvider)` es el lugar para conectar la lista filtrada.
Los estados cargando/error/vacío/datos se añadirán al integrar esa fuente asíncrona.
Esta fase no implementa el filtro ni cambia la estructura de los movimientos.

### Conexión de Dismissible - Integrante 3

En el `itemBuilder` de `lib/screens/history_screen.dart`, envolver `MovementTile`
con un `Dismissible` cuya clave sea `ValueKey(movement.id)`, nunca el índice.
Conectar la operación al repositorio de movimientos y el SnackBar de Deshacer a
su restauración con el mismo ID y datos. La política de borrado y de error corresponde
a ese integrante. La navegación y el controlador de scroll permanecen independientes.

Para completar la entrega del equipo aún se necesita el repositorio remoto,
su plantilla de PR, el CI de S14 en verde y la revisión de otra pareja.
Las validaciones locales no equivalen a un check de CI remoto.
