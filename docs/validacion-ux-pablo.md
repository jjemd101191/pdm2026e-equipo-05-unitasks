# Verificación técnica del aporte UX - 2026-11-01

Rama local: codex/ux-perfil-reintentos. Base: origin/main en 4263e6b, actualizada con git fetch. No se hizo push, commit, merge ni revisión publicada.

## Alcance

Solo se modifican las pantallas asignadas de Perfil y arranque, sus pruebas, la sección de capturas del README y documentos UX. No se modifican tablas, DAOs, repositorios, providers, tema global, buscador ni CI. Las carpetas Proyectos aparte quedan fuera de este aporte.

## Verificación

- dart analyze lib test: sin observaciones.
- flutter test --no-pub: 80 pruebas aprobadas, incluidas las existentes de datos y migración, búsqueda, navegación y flujos. Se agregan seis pruebas de Perfil y dos de arranque.
- Las pruebas de recuperación usan fábricas y repositorios controlados: no modifican la base del usuario ni simulan que fueron entrevistas.
- Se conserva la apertura AppDatabase.abrir(alCrear: sembrarDatosIniciales), verificar y el ProviderScope existentes. Se añade un contenedor de arranque comprobable y recuperable.
- El error inmediato de una fábrica se maneja mientras FutureBuilder cambia de frame; no queda una excepción sin manejar durante el reintento.

Limitaciones del entorno: flutter pub get resuelve paquetes, pero al preparar plugins de Windows mostró un aviso de soporte de symlinks. No se cambió Developer Mode ni configuraciones del sistema. Esto no impidió la suite automatizada. Android, su APK y el cierre formal de QA corresponden a Marco y no se certifican aquí.

## Inspección de estados existentes

Inicio, Calendario y Cursos ya contienen carga, vacío y error con Reintentar. No se reescribieron. Perfil carecía del error recuperable y no distinguía vacío de fallo; esta es la corrección realizada.

## Investigación pendiente

0/3 participantes documentados al momento del cambio. La revisión técnica de JM no sustituye las tres sesiones requeridas. usuarios.md tiene un protocolo y registros pendientes, no resultados sintéticos. Falta aplicar al menos una mejora basada en sesiones reales y enlazar el PR correspondiente.

## Verificación web y capturas

flutter build web --no-pub compiló correctamente (incluido el dry run WASM). Se arrancó la app con flutter run -d chrome --no-pub --web-port=52817 y se navegó con Chrome a Inicio, Calendario, Cursos y Perfil; las cuatro capturas están en docs/capturas a 390 x 844. Perfil muestra la identidad neutra y 4 cursos, 6 activas y 2 completadas de la base semilla en el contexto aislado del navegador de pruebas. No se registraron excepciones JavaScript durante ese recorrido. Los datos de prueba provienen de seed_data.dart; no son usuarios entrevistados.

Observación para coordinar con Demy: Inicio todavía contiene el saludo fijo Hola, Diego. No se editó task_list_screen.dart para no interferir con su búsqueda y confirmaciones. No presentar este cambio como eliminación de toda identidad fija en toda la app: se corrigió Perfil, tal como asigna el plan.
