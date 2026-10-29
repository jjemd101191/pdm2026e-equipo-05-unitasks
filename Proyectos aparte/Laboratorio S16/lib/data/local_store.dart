import 'dart:convert';
import 'dart:developer' as developer;

import 'package:hive_ce_flutter/hive_flutter.dart';

/// Almacenamiento local del laboratorio sobre Hive Community Edition.
///
/// Cada registro se guarda como una cadena JSON en un `Box<String>` con el id
/// como clave. La versión del esquema vive en el nombre de la caja, que es el
/// equivalente de Hive a `onUpgrade` en SQLite: la caja actual es
/// `categorias_v2` y la anterior, `categorias_v1`, nunca se edita; se copia
/// una sola vez y se descarta.
class LocalStore {
  LocalStore._(this._categorias, this._movimientos, this._meta);

  final Box<String> _categorias;
  final Box<String> _movimientos;
  final Box<String> _meta;

  /// Versión del esquema de las categorías.
  static const int versionCategorias = 2;

  static const String nombreCajaCategorias = 'categorias_v2';

  /// Caja de la versión anterior. Solo la lee la migración.
  static const String nombreCajaCategoriasAnterior = 'categorias_v1';

  static const String nombreCajaMovimientos = 'movimientos_v1';
  static const String nombreCajaMeta = 'meta_v1';
  static const String _claveSembrado = 'sembrado';
  static const String _claveMigracion = 'migracion_categorias_v2';

  /// Abre las cajas de la app.
  ///
  /// Sin [ruta] usa el directorio de documentos de la plataforma (en web,
  /// IndexedDB). Con [ruta] se usa esa carpeta, como en las pruebas.
  /// [sufijo] permite abrir cajas aisladas en pruebas sin borrar datos.
  static Future<LocalStore> abrir({String? ruta, String sufijo = ''}) async {
    if (ruta == null) {
      await Hive.initFlutter();
    } else {
      Hive.init(ruta);
    }
    // La meta se abre antes que las categorías: guarda la marca de migración.
    final meta = await Hive.openBox<String>('$nombreCajaMeta$sufijo');
    await _migrarCategoriasAV2(sufijo: sufijo, meta: meta);
    final categorias = await Hive.openBox<String>(
      '$nombreCajaCategorias$sufijo',
    );
    final movimientos = await Hive.openBox<String>(
      '$nombreCajaMovimientos$sufijo',
    );
    return LocalStore._(categorias, movimientos, meta);
  }

  /// Copia las categorías de `categorias_v1` a `categorias_v2` agregando
  /// `archivado`.
  ///
  /// Se ejecuta una sola vez por dispositivo. La marca en `meta_v1` evita
  /// repetirla y hace la operación segura si la app se cierra a medias: copiar
  /// con las mismas claves es idempotente.
  static Future<void> _migrarCategoriasAV2({
    required String sufijo,
    required Box<String> meta,
  }) async {
    if (meta.get(_claveMigracion) == 'true') return;

    final anterior = await Hive.openBox<String>(
      '$nombreCajaCategoriasAnterior$sufijo',
    );
    if (anterior.isNotEmpty) {
      final actualizadas = <String, String>{};
      for (final clave in anterior.keys) {
        final texto = anterior.get(clave);
        if (texto == null) continue;
        try {
          final dato = jsonDecode(texto);
          if (dato is! Map<String, dynamic>) continue;
          // La columna nueva: las categorías que ya existían no están
          // archivadas.
          dato['archivado'] = dato['archivado'] ?? false;
          actualizadas[clave as String] = jsonEncode(dato);
        } catch (error, stackTrace) {
          // Un registro corrupto no debe impedir la migración del resto.
          developer.log(
            'No se pudo migrar la categoría $clave',
            name: 'LaboratorioS16.LocalStore',
            error: error,
            stackTrace: stackTrace,
          );
        }
      }
      final actual = await Hive.openBox<String>('$nombreCajaCategorias$sufijo');
      await actual.putAll(actualizadas);
    }

    // `deleteFromDisk` ya cierra y desregistra la caja; llamar antes a
    // `close()` provoca un doble cierre del archivo en hive_ce.
    await anterior.deleteFromDisk();
    await meta.put(_claveMigracion, 'true');
  }

  /// `true` cuando ya se cargaron los datos de ejemplo la primera vez.
  bool get sembrado => _meta.get(_claveSembrado) == 'true';

  Future<void> marcarSembrado() => _meta.put(_claveSembrado, 'true');

  List<Map<String, dynamic>> get categoriasJson => _leer(_categorias);

  List<Map<String, dynamic>> get movimientosJson => _leer(_movimientos);

  Future<void> guardarCategoria(String id, Map<String, dynamic> json) =>
      _categorias.put(id, jsonEncode(json));

  Future<void> eliminarCategoria(String id) => _categorias.delete(id);

  Future<void> guardarMovimiento(String id, Map<String, dynamic> json) =>
      _movimientos.put(id, jsonEncode(json));

  Future<void> eliminarMovimiento(String id) => _movimientos.delete(id);

  /// Cierra las cajas. Necesario antes de reabrir el almacenamiento en pruebas
  /// y al cerrar la app de forma ordenada.
  Future<void> cerrar() async {
    await _categorias.close();
    await _movimientos.close();
    await _meta.close();
  }

  static List<Map<String, dynamic>> _leer(Box<String> caja) {
    final registros = <Map<String, dynamic>>[];
    for (final texto in caja.values) {
      try {
        final dato = jsonDecode(texto);
        if (dato is Map<String, dynamic>) registros.add(dato);
      } catch (error, stackTrace) {
        // Un registro corrupto no debe impedir que abra el resto de la app.
        developer.log(
          'Registro inválido en la caja ${caja.name}',
          name: 'LaboratorioS16.LocalStore',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
    return registros;
  }
}
