# Laboratorio S16 · Categorías

Aplicación Flutter del Equipo 05 para el laboratorio de **CRUD completo y
migración probada**. Trabaja una sola entidad, `Categoría`, con sus movimientos
relacionados.

## Entidad

`Categoria` tiene `id`, `nombre`, `tipo` (gasto o ingreso) y `archivado`.
`Movimiento` guarda `categoriaId`, que es la relación que permite demostrar la
regla «no se borra lo que está en uso».

Los movimientos todavía se leen desde los datos de ejemplo; el CRUD de este
laboratorio es el de categorías.

## Esquema y migración

Hive no tiene `onUpgrade`, así que la versión del esquema vive en el nombre de
la caja:

| Versión | Caja | Contenido |
|---|---|---|
| 1 | `categorias_v1` | Categorías sin el campo `archivado`. |
| 2 | `categorias_v2` | Categorías con `archivado`. |

En la primera apertura, `LocalStore` copia las categorías de `categorias_v1` a
`categorias_v2` agregando `archivado: false`, descarta la caja vieja y marca la
migración en `meta_v1`. La caja vieja nunca se edita. Los detalles y las
alternativas descartadas están en
[`docs/adr/0001-migracion-categorias-v2.md`](docs/adr/0001-migracion-categorias-v2.md).

## Estructura

```text
lib/
  models/
    categoria.dart          Entidad del laboratorio y tipo de categoría.
    movimiento.dart         Registro relacionado (regla de uso).
  data/
    local_store.dart        Cajas Hive y migración v1 → v2.
    serialization.dart      JSON de categorías y movimientos.
    categoria_repository.dart    Contrato, incluido el error de nombre repetido.
    hive_categoria_repository.dart  Implementación sobre Hive.
    providers.dart          Riverpod: repositorio y lista de categorías.
    seed_data.dart          Datos de ejemplo de la primera apertura.
  utils/id.dart             Generador de ids locales.
  main.dart                 App y listado de categorías.
test/
  widget_test.dart          La app abre y muestra solo las categorías visibles.
```

## Ejecución

```bash
flutter pub get
flutter run -d chrome
```

## Verificación

```bash
dart format --output=none --set-exit-if-changed .
dart analyze
flutter test
```
