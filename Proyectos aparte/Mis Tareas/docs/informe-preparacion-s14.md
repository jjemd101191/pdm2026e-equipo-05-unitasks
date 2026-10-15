# Informe de preparación S14

Fecha: 2026-10-15 (America/Guatemala).
Ámbito: únicamente flutter_application_1 dentro de la carpeta abierta.

## Estado

Proyecto Flutter válido y reutilizable. La pantalla Mis Tareas reside en lib/main.dart: MyApp, Inicio y los helpers filtro y tarea. La interfaz muestra datos fijos; filtros y navegación no tienen acciones implementadas. Es una base para añadir estados posteriormente, pero no implementa todavía la Parte B. No se recibió la rúbrica completa de esa parte.

Se inventariaron todas las carpetas del proyecto, omitiendo el detalle interno de cachés y ajustes locales del IDE. Se revisaron código Dart, prueba, pubspec, lockfile, metadatos y configuraciones principales Android/iOS/macOS/Linux/Windows/web. No se compiló una aplicación nativa ni se certificaron los toolchains de todas las plataformas.

## Versiones y dependencias

- Flutter instalado: 3.44.8 stable, revisión 058e0af2c2b57e369d905a03ac9748b0ebf543c6; coincide con la revisión de creación en .metadata.
- Dart instalado: 3.12.2. Restricción del proyecto: ^3.12.2 (>=3.12.2 <4.0.0).
- Dependencias directas: Flutter SDK y cupertino_icons ^1.0.8 (resuelta 1.0.9).
- Desarrollo: flutter_test SDK y flutter_lints ^6.0.0 (resuelta 6.0.0).
- pub get resolvió todos los paquetes; pubspec.yaml y pubspec.lock permanecen intactos. Se anunciaron 9 paquetes con versiones más recientes incompatibles con las restricciones actuales; no es un fallo de resolución y no se actualizaron.
- Android: AGP 9.0.1, Kotlin 2.3.20, Gradle 9.1.0 y objetivo Java 17 según los archivos existentes. Se conservaron; no se verificó una compilación Android.

## Comandos y resultados

Todos los comandos de proyecto se ejecutaron desde flutter_application_1.

| Comando | Resultado |
| --- | --- |
| flutter --version | Correcto: Flutter 3.44.8, Dart 3.12.2 |
| flutter clean | Correcto: eliminó build, .dart_tool, directorios ephemeral de iOS/macOS, Generated.xcconfig y flutter_export_environment.sh |
| flutter pub get | Correcto: dependencias resueltas, lockfile intacto |
| dart format --output=none --set-exit-if-changed . | Inicial: código 1, lib/main.dart necesitaba formato. Final: código 0, 2 archivos y 0 cambios |
| dart format . | Correcto: aplicó formato a lib/main.dart |
| flutter analyze | Inicial y final: código 0, No issues found! |
| flutter test | Inicial: código 1, esperaba texto 0 del contador inexistente. Final: código 0, 1 prueba aprobada |
| git status --short --branch / git remote -v / git log -5 --oneline / git rev-parse --show-toplevel | Código 128: esta copia no es un repositorio Git |
| git check-ignore --no-index .dart_tool/package_config.json | Código 128 por ausencia de repositorio; exclusiones revisadas directamente en los archivos |

Las comprobaciones iniciales de formato se ejecutaron mediante dart.exe del mismo SDK. La comprobación final también se ejecutó con el comando exacto dart format --output=none --set-exit-if-changed .: código 0, 2 archivos, 0 cambios. Flutter se ejecutó mediante el comando normal con acceso autorizado a su caché externa. No se modificó el SDK.

## Cambios y limpieza

- lib/main.dart: solo formato; se conservó la funcionalidad y toda la pantalla.
- test/widget_test.dart: se conservó y adaptó la única prueba de humo al contenido real. Comprueba título, saludo, resumen, filtro, primera tarea, barra inferior, desplazamiento y última tarea, y ausencia de excepciones.
- .gitignore: se agregó .flutter_tool_state para el estado local generado por Flutter. Las exclusiones existentes ya cubren build, .dart_tool, cobertura, IDE y archivos Android locales. pubspec.lock permanece versionable.
- docs/bitacora-ia.md: registro de uso de IA, decisiones y sugerencias descartadas/diferidas.
- docs/informe-preparacion-s14.md: este informe y el inventario.
- android/.gradle: caché eliminada tras verificar su ruta absoluta dentro del proyecto.
- Los archivos regenerables eliminados por flutter clean se recrearon según lo requerido por pub get y test. Los archivos iOS Generated.xcconfig y flutter_export_environment.sh reflejan ahora la ruta de esta copia. Es normal que existan nuevamente build y .dart_tool; están excluidos de Git.
- Se conservaron .idea y archivos .iml porque pueden contener ajustes personales. Se conservaron los wrappers, registradores de plugins, fuentes nativas, recursos, .metadata y hooks anteriores; no hay evidencia para borrarlos indiscriminadamente.

## Git y preparación de Parte A

No hay .git en la copia ni un repositorio padre reconocido por Git. Por ello no existen rama main, historial o remoto verificables para esta copia. No se eliminó ni reinicializó historial ni se cambió un remoto.

La carpeta .github existente contiene únicamente hooks de modernize/java-upgrade; no contiene workflows ni configuración de CI. Sus scripts y exclusiones se conservaron.

Pendientes, sin implementarse en esta preparación:

- Resolver con el usuario el repositorio correcto: recuperar una copia de trabajo con historial si corresponde, o autorizar la configuración inicial si esta copia será un repositorio nuevo. No copiar un .git ajeno indiscriminadamente.
- Confirmar la raíz del futuro repositorio. El pubspec está en flutter_application_1, una subcarpeta de la carpeta abierta. Si esa subcarpeta es la raíz, .github y docs irán allí; si la raíz es la carpeta superior, los workflows irán en su .github y los comandos Flutter necesitarán ese directorio de trabajo.
- Crear posteriormente .github/workflows/ci.yml con formato, análisis y pruebas obligatorias, usando un SDK compatible con el validado.
- Crear posteriormente .github/pull_request_template.md y .github/CODEOWNERS con las cuentas reales del equipo.
- Continuar docs/bitacora-ia.md durante el laboratorio.
- Crear chore/ci, abrir PR hacia main y aplicar el ruleset cuando se disponga del repositorio y permisos. No se inspeccionó ninguna configuración remota de GitHub.

La base Flutter está preparada. La preparación integral para el flujo de Parte A sigue pendiente de resolver el repositorio Git; las otras configuraciones son trabajo previsto para esa parte.

## Inventario de fuentes y configuración previo a la limpieza

Se listan carpetas y archivos; no se despliega el contenido interno de build, .dart_tool, .gradle, .idea y ephemeral.

```text
.dart_tool/
.flutter_tool_state
.github/
.github\modernize/
.github\modernize\java-upgrade/
.github\modernize\java-upgrade\.gitignore
.github\modernize\java-upgrade\hooks/
.github\modernize\java-upgrade\hooks\scripts/
.github\modernize\java-upgrade\hooks\scripts\recordToolUse.ps1
.github\modernize\java-upgrade\hooks\scripts\recordToolUse.sh
.gitignore
.idea/
.metadata
analysis_options.yaml
android/
android\.gitignore
android\.gradle/
android\app/
android\app\build.gradle.kts
android\app\src/
android\app\src\debug/
android\app\src\debug\AndroidManifest.xml
android\app\src\main/
android\app\src\main\AndroidManifest.xml
android\app\src\main\java/
android\app\src\main\java\io/
android\app\src\main\java\io\flutter/
android\app\src\main\java\io\flutter\plugins/
android\app\src\main\java\io\flutter\plugins\GeneratedPluginRegistrant.java
android\app\src\main\kotlin/
android\app\src\main\kotlin\com/
android\app\src\main\kotlin\com\example/
android\app\src\main\kotlin\com\example\flutter_application_1/
android\app\src\main\kotlin\com\example\flutter_application_1\MainActivity.kt
android\app\src\main\res/
android\app\src\main\res\drawable/
android\app\src\main\res\drawable\launch_background.xml
android\app\src\main\res\drawable-v21/
android\app\src\main\res\drawable-v21\launch_background.xml
android\app\src\main\res\mipmap-hdpi/
android\app\src\main\res\mipmap-hdpi\ic_launcher.png
android\app\src\main\res\mipmap-mdpi/
android\app\src\main\res\mipmap-mdpi\ic_launcher.png
android\app\src\main\res\mipmap-xhdpi/
android\app\src\main\res\mipmap-xhdpi\ic_launcher.png
android\app\src\main\res\mipmap-xxhdpi/
android\app\src\main\res\mipmap-xxhdpi\ic_launcher.png
android\app\src\main\res\mipmap-xxxhdpi/
android\app\src\main\res\mipmap-xxxhdpi\ic_launcher.png
android\app\src\main\res\values/
android\app\src\main\res\values\styles.xml
android\app\src\main\res\values-night/
android\app\src\main\res\values-night\styles.xml
android\app\src\profile/
android\app\src\profile\AndroidManifest.xml
android\build.gradle.kts
android\flutter_application_1_android.iml
android\gradle/
android\gradle\wrapper/
android\gradle\wrapper\gradle-wrapper.jar
android\gradle\wrapper\gradle-wrapper.properties
android\gradle.properties
android\gradlew
android\gradlew.bat
android\local.properties
android\settings.gradle.kts
build/
flutter_application_1.iml
ios/
ios\.gitignore
ios\Flutter/
ios\Flutter\AppFrameworkInfo.plist
ios\Flutter\Debug.xcconfig
ios\Flutter\ephemeral/
ios\Flutter\flutter_export_environment.sh
ios\Flutter\Generated.xcconfig
ios\Flutter\Release.xcconfig
ios\Runner/
ios\Runner\AppDelegate.swift
ios\Runner\Assets.xcassets/
ios\Runner\Assets.xcassets\AppIcon.appiconset/
ios\Runner\Assets.xcassets\AppIcon.appiconset\Contents.json
ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-1024x1024@1x.png
ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-20x20@1x.png
ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-20x20@2x.png
ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-20x20@3x.png
ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-29x29@1x.png
ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-29x29@2x.png
ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-29x29@3x.png
ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-40x40@1x.png
ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-40x40@2x.png
ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-40x40@3x.png
ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-60x60@2x.png
ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-60x60@3x.png
ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-76x76@1x.png
ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-76x76@2x.png
ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-83.5x83.5@2x.png
ios\Runner\Assets.xcassets\LaunchImage.imageset/
ios\Runner\Assets.xcassets\LaunchImage.imageset\Contents.json
ios\Runner\Assets.xcassets\LaunchImage.imageset\LaunchImage.png
ios\Runner\Assets.xcassets\LaunchImage.imageset\LaunchImage@2x.png
ios\Runner\Assets.xcassets\LaunchImage.imageset\LaunchImage@3x.png
ios\Runner\Assets.xcassets\LaunchImage.imageset\README.md
ios\Runner\Base.lproj/
ios\Runner\Base.lproj\LaunchScreen.storyboard
ios\Runner\Base.lproj\Main.storyboard
ios\Runner\GeneratedPluginRegistrant.h
ios\Runner\GeneratedPluginRegistrant.m
ios\Runner\Info.plist
ios\Runner\Runner-Bridging-Header.h
ios\Runner\SceneDelegate.swift
ios\Runner.xcodeproj/
ios\Runner.xcodeproj\project.pbxproj
ios\Runner.xcodeproj\project.xcworkspace/
ios\Runner.xcodeproj\project.xcworkspace\contents.xcworkspacedata
ios\Runner.xcodeproj\project.xcworkspace\xcshareddata/
ios\Runner.xcodeproj\project.xcworkspace\xcshareddata\IDEWorkspaceChecks.plist
ios\Runner.xcodeproj\project.xcworkspace\xcshareddata\WorkspaceSettings.xcsettings
ios\Runner.xcodeproj\xcshareddata/
ios\Runner.xcodeproj\xcshareddata\xcschemes/
ios\Runner.xcodeproj\xcshareddata\xcschemes\Runner.xcscheme
ios\Runner.xcworkspace/
ios\Runner.xcworkspace\contents.xcworkspacedata
ios\Runner.xcworkspace\xcshareddata/
ios\Runner.xcworkspace\xcshareddata\IDEWorkspaceChecks.plist
ios\Runner.xcworkspace\xcshareddata\WorkspaceSettings.xcsettings
ios\RunnerTests/
ios\RunnerTests\RunnerTests.swift
lib/
lib\main.dart
linux/
linux\.gitignore
linux\CMakeLists.txt
linux\flutter/
linux\flutter\CMakeLists.txt
linux\flutter\generated_plugins.cmake
linux\flutter\generated_plugin_registrant.cc
linux\flutter\generated_plugin_registrant.h
linux\runner/
linux\runner\CMakeLists.txt
linux\runner\main.cc
linux\runner\my_application.cc
linux\runner\my_application.h
macos/
macos\.gitignore
macos\Flutter/
macos\Flutter\ephemeral/
macos\Flutter\Flutter-Debug.xcconfig
macos\Flutter\Flutter-Release.xcconfig
macos\Flutter\GeneratedPluginRegistrant.swift
macos\Runner/
macos\Runner\AppDelegate.swift
macos\Runner\Assets.xcassets/
macos\Runner\Assets.xcassets\AppIcon.appiconset/
macos\Runner\Assets.xcassets\AppIcon.appiconset\app_icon_1024.png
macos\Runner\Assets.xcassets\AppIcon.appiconset\app_icon_128.png
macos\Runner\Assets.xcassets\AppIcon.appiconset\app_icon_16.png
macos\Runner\Assets.xcassets\AppIcon.appiconset\app_icon_256.png
macos\Runner\Assets.xcassets\AppIcon.appiconset\app_icon_32.png
macos\Runner\Assets.xcassets\AppIcon.appiconset\app_icon_512.png
macos\Runner\Assets.xcassets\AppIcon.appiconset\app_icon_64.png
macos\Runner\Assets.xcassets\AppIcon.appiconset\Contents.json
macos\Runner\Base.lproj/
macos\Runner\Base.lproj\MainMenu.xib
macos\Runner\Configs/
macos\Runner\Configs\AppInfo.xcconfig
macos\Runner\Configs\Debug.xcconfig
macos\Runner\Configs\Release.xcconfig
macos\Runner\Configs\Warnings.xcconfig
macos\Runner\DebugProfile.entitlements
macos\Runner\Info.plist
macos\Runner\MainFlutterWindow.swift
macos\Runner\Release.entitlements
macos\Runner.xcodeproj/
macos\Runner.xcodeproj\project.pbxproj
macos\Runner.xcodeproj\project.xcworkspace/
macos\Runner.xcodeproj\project.xcworkspace\xcshareddata/
macos\Runner.xcodeproj\project.xcworkspace\xcshareddata\IDEWorkspaceChecks.plist
macos\Runner.xcodeproj\xcshareddata/
macos\Runner.xcodeproj\xcshareddata\xcschemes/
macos\Runner.xcodeproj\xcshareddata\xcschemes\Runner.xcscheme
macos\Runner.xcworkspace/
macos\Runner.xcworkspace\contents.xcworkspacedata
macos\Runner.xcworkspace\xcshareddata/
macos\Runner.xcworkspace\xcshareddata\IDEWorkspaceChecks.plist
macos\RunnerTests/
macos\RunnerTests\RunnerTests.swift
pubspec.lock
pubspec.yaml
README.md
test/
test\widget_test.dart
web/
web\favicon.png
web\icons/
web\icons\Icon-192.png
web\icons\Icon-512.png
web\icons\Icon-maskable-192.png
web\icons\Icon-maskable-512.png
web\index.html
web\manifest.json
windows/
windows\.gitignore
windows\CMakeLists.txt
windows\flutter/
windows\flutter\CMakeLists.txt
windows\flutter\generated_plugins.cmake
windows\flutter\generated_plugin_registrant.cc
windows\flutter\generated_plugin_registrant.h
windows\runner/
windows\runner\CMakeLists.txt
windows\runner\flutter_window.cpp
windows\runner\flutter_window.h
windows\runner\main.cpp
windows\runner\resource.h
windows\runner\resources/
windows\runner\resources\app_icon.ico
windows\runner\runner.exe.manifest
windows\runner\Runner.rc
windows\runner\utils.cpp
windows\runner\utils.h
windows\runner\win32_window.cpp
windows\runner\win32_window.h
```
