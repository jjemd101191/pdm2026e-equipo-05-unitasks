# ADR 0004 · Anuncios y plan Premium simulado

- **Estado:** aceptada
- **Fecha:** 2026-11-08
- **Relacionadas:** [ADR 0003](0003-flujo-de-datos-y-migraciones.md) (esquema y migraciones)

## Contexto

El plan de monetización de Mercadeo define dos ingresos: publicidad en la
versión gratuita y un pase Premium de pago único. El sondeo de ese curso
muestra que un límite de 3 tareas activas sería rechazado por el 46 % de las
personas, así que se decidió **no limitar tareas** y sostener la versión
gratuita con anuncios.

La app es local-first, no tiene backend ni pasarela de pago y también se
compila para web. AdMob solo funciona en Android/iOS.

## Decisión

### 1. Anuncios

- SDK: `google_mobile_ads` con los **IDs de prueba de Google**.
- Formato: **intersticial** después de completar una tarea, tanto desde Inicio
  como desde el detalle.
- Frecuencia: como máximo uno cada 90 segundos.
- Plataformas: solo Android/iOS. En web y escritorio la implementación es nula
  gracias a un import condicional (`lib/ads/anuncios.dart`).
- El anuncio no se muestra si el plan Premium está activo.

### 2. Premium

- La compra es **simulada**: no hay cobro real ni pasarela de pago.
- El flag `premium_activo` se guarda en la tabla `app_settings` (esquema v3).
- Efecto actual: quitar los anuncios. Nube, PDF y tableros quedan como trabajo
  futuro.
- La pantalla lo declara explícitamente y permite volver al plan gratis para
  repetir la demostración.

### 3. Esquema v3

```dart
onUpgrade: (m, from, to) async {
  if (from < 2) await m.addColumn(courses, courses.archivado);
  if (from < 3) await m.createTable(appSettings);
},
```

La migración v2 → v3 se prueba en `test/data/migracion_test.dart`. La tabla es
clave-valor para no volver a migrar el esquema con cada preferencia nueva.

## Consecuencias

**A favor**

- La monetización se puede demostrar en el teléfono sin cuentas ni pagos.
- El build web sigue funcionando y no incluye el SDK de anuncios.
- El plan sobrevive al cierre de la app.

**En contra**

- Los IDs de prueba no generan ingresos; para producción hay que registrar la
  app en AdMob y reemplazarlos en Android y iOS.
- AdMob requiere Internet; la app sigue funcionando sin conexión, pero sin
  anuncios.
- No hay cobro real: la compra de Play Store y la validación de licencias
  quedan pendientes.
- La web no muestra anuncios, así que la demostración de monetización debe
  hacerse en Android.
