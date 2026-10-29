# Esquema y migración de categorías

## Por qué una versión nueva

El CRUD necesita una salida cuando una categoría tiene movimientos y no se puede
eliminar: **archivar**. Eso agrega un campo que la versión anterior no guarda.
Hive no ofrece `onUpgrade`; la versión del esquema se expresa en el nombre de la
caja, así que el cambio entra como `categorias_v2`.

## Versión 1 (`categorias_v1`)

```json
{
  "id": "cat-gastos",
  "nombre": "Gastos",
  "tipo": "gasto"
}
```

## Versión 2 (`categorias_v2`)

```json
{
  "id": "cat-gastos",
  "nombre": "Gastos",
  "tipo": "gasto",
  "archivado": false
}
```

`movimientos_v1` y `meta_v1` no cambian.

## Cómo se migra

En `LocalStore.abrir`, antes de abrir la caja activa:

1. Si la marca `migracion_categorias_v2` ya está en `meta_v1`, no se hace nada.
2. Se abre `categorias_v1` y se lee cada registro.
3. A cada JSON se le agrega `"archivado": false` si no lo trae.
4. Se copia el resultado a `categorias_v2` conservando la clave (`id`).
5. Se descarta `categorias_v1` y se escribe la marca.

La marca evita repetir la migración. Copiar con las mismas claves es
idempotente: si la app se cierra a medias, al volver a abrir el resultado es el
mismo.

## Regla del laboratorio

Una migración publicada **no se edita**. Si el esquema vuelve a cambiar, se crea
`categorias_v3` con su propia migración. Editar la v2 dejaría teléfonos que ya
la ejecutaron con un esquema distinto al que la app espera, y no habría forma de
detectarlo porque la versión ya quedó marcada.

## Alternativas descartadas

| Alternativa | Motivo |
|---|---|
| Editar los JSON dentro de `categorias_v1` | No distingue esquemas y deja equipos a medio migrar sin forma de detectarlo. |
| Abrir `categorias_v2` vacía y volver a sembrar | Se perderían las categorías y ediciones del usuario. |
| Confiar solo en `archivado as bool? ?? false` | Se mantiene como red de seguridad, pero no deja constancia de la versión ni permite auditar la migración. |
