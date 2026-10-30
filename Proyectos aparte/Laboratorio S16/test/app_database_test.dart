import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:laboratorio_s16/data/local_store.dart';

void main() {
  test(
    'migra categorías v1 a v2 y conserva los movimientos relacionados',
    () async {
      final directorio = await Directory.systemTemp.createTemp(
        'laboratorio_s16_migracion_',
      );
      const sufijo = '_app_database_test';
      LocalStore? store;

      addTearDown(() async {
        if (store != null) await store.cerrar();
        await Hive.close();
        if (await directorio.exists()) {
          await directorio.delete(recursive: true);
        }
      });

      Hive.init(directorio.path);

      final categoriasV1 = <Map<String, dynamic>>[
        {'id': 'cat-comida', 'nombre': 'Comida', 'tipo': 'gasto'},
        {'id': 'cat-transporte', 'nombre': 'Transporte', 'tipo': 'gasto'},
        {'id': 'cat-beca', 'nombre': 'Beca', 'tipo': 'ingreso'},
      ];
      final movimientosV1 = <Map<String, dynamic>>[
        {
          'id': 'mov-1',
          'categoriaId': 'cat-comida',
          'descripcion': 'Almuerzo',
          'monto': 4.5,
          'fecha': '2026-10-01T12:00:00.000',
        },
        {
          'id': 'mov-2',
          'categoriaId': 'cat-comida',
          'descripcion': 'Mercado',
          'monto': 25.0,
          'fecha': '2026-10-02T09:30:00.000',
        },
        {
          'id': 'mov-3',
          'categoriaId': 'cat-transporte',
          'descripcion': 'Autobús',
          'monto': 1.25,
          'fecha': '2026-10-03T07:15:00.000',
        },
        {
          'id': 'mov-4',
          'categoriaId': 'cat-transporte',
          'descripcion': 'Taxi',
          'monto': 8.0,
          'fecha': '2026-10-04T18:45:00.000',
        },
        {
          'id': 'mov-5',
          'categoriaId': 'cat-beca',
          'descripcion': 'Pago de beca',
          'monto': 150.0,
          'fecha': '2026-10-05T10:00:00.000',
        },
        {
          'id': 'mov-6',
          'categoriaId': 'cat-beca',
          'descripcion': 'Bono académico',
          'monto': 20.0,
          'fecha': '2026-10-06T14:20:00.000',
        },
      ];

      final cajaCategoriasV1 = await Hive.openBox<String>(
        '${LocalStore.nombreCajaCategoriasAnterior}$sufijo',
      );
      for (final categoria in categoriasV1) {
        await cajaCategoriasV1.put(
          categoria['id'] as String,
          jsonEncode(categoria),
        );
      }

      final cajaMovimientos = await Hive.openBox<String>(
        '${LocalStore.nombreCajaMovimientos}$sufijo',
      );
      for (final movimiento in movimientosV1) {
        await cajaMovimientos.put(
          movimiento['id'] as String,
          jsonEncode(movimiento),
        );
      }
      await cajaCategoriasV1.close();
      await cajaMovimientos.close();

      Map<String, Map<String, dynamic>> porId(
        List<Map<String, dynamic>> registros,
      ) => {
        for (final registro in registros) registro['id'] as String: registro,
      };

      store = await LocalStore.abrir(ruta: directorio.path, sufijo: sufijo);

      final categoriasEsperadas = porId([
        for (final categoria in categoriasV1)
          {...categoria, 'archivado': false},
      ]);
      expect(store.categoriasJson, hasLength(3));
      expect(porId(store.categoriasJson), equals(categoriasEsperadas));
      expect(
        store.categoriasJson.every(
          (categoria) => categoria['archivado'] == false,
        ),
        isTrue,
      );
      expect(store.movimientosJson, hasLength(6));
      expect(porId(store.movimientosJson), equals(porId(movimientosV1)));

      await store.cerrar();
      store = null;

      // Si la migración se repitiera, estos registros cambiarían o se añadirían.
      final cajaCategoriasV1Recreada = await Hive.openBox<String>(
        '${LocalStore.nombreCajaCategoriasAnterior}$sufijo',
      );
      await cajaCategoriasV1Recreada.put(
        'cat-comida',
        jsonEncode({
          'id': 'cat-comida',
          'nombre': 'Registro antiguo conflictivo',
          'tipo': 'gasto',
        }),
      );
      await cajaCategoriasV1Recreada.put(
        'cat-extra',
        jsonEncode({'id': 'cat-extra', 'nombre': 'Extra', 'tipo': 'ingreso'}),
      );
      await cajaCategoriasV1Recreada.close();

      store = await LocalStore.abrir(ruta: directorio.path, sufijo: sufijo);

      expect(store.categoriasJson, hasLength(3));
      expect(porId(store.categoriasJson), equals(categoriasEsperadas));
      expect(store.movimientosJson, hasLength(6));
      expect(porId(store.movimientosJson), equals(porId(movimientosV1)));
    },
  );
}
