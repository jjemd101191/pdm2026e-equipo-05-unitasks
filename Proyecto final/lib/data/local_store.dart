import 'dart:convert';
import 'dart:developer' as developer;

import 'package:hive_ce_flutter/hive_flutter.dart';

/// Almacenamiento local de TaskU sobre Hive Community Edition.
///
/// Cada registro se guarda como una cadena JSON en un `Box<String>` con el id
/// como clave. Guardar JSON (en lugar de adaptadores generados) mantiene el
/// esquema legible, evita `build_runner` y permite evolucionar los modelos sin
/// migraciones binarias. Los nombres de caja incluyen la versión del esquema
/// (`cursos_v1`, `tareas_v1`).
class LocalStore {
  LocalStore._(this._cursos, this._tareas, this._meta);

  final Box<String> _cursos;
  final Box<String> _tareas;
  final Box<String> _meta;

  static const String _nombreCursos = 'cursos_v1';
  static const String _nombreTareas = 'tareas_v1';
  static const String _nombreMeta = 'meta_v1';
  static const String _claveSembrado = 'sembrado';

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
    final cursos = await Hive.openBox<String>('$_nombreCursos$sufijo');
    final tareas = await Hive.openBox<String>('$_nombreTareas$sufijo');
    final meta = await Hive.openBox<String>('$_nombreMeta$sufijo');
    return LocalStore._(cursos, tareas, meta);
  }

  /// `true` cuando ya se cargaron los datos de ejemplo la primera vez.
  bool get sembrado => _meta.get(_claveSembrado) == 'true';

  Future<void> marcarSembrado() => _meta.put(_claveSembrado, 'true');

  List<Map<String, dynamic>> get cursosJson => _leer(_cursos);

  List<Map<String, dynamic>> get tareasJson => _leer(_tareas);

  Future<void> guardarCurso(String id, Map<String, dynamic> json) =>
      _cursos.put(id, jsonEncode(json));

  Future<void> eliminarCurso(String id) => _cursos.delete(id);

  Future<void> guardarTarea(String id, Map<String, dynamic> json) =>
      _tareas.put(id, jsonEncode(json));

  Future<void> eliminarTarea(String id) => _tareas.delete(id);

  /// Cierra las cajas. Necesario antes de reabrir el almacenamiento en pruebas
  /// y al cerrar la app de forma ordenada.
  Future<void> cerrar() async {
    await _cursos.close();
    await _tareas.close();
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
          name: 'TaskU.LocalStore',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
    return registros;
  }
}
