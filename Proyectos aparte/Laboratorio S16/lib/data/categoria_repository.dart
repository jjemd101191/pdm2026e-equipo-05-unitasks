import '../models/categoria.dart';

/// Acceso a las categorías guardadas en el dispositivo.
///
/// La interfaz no conoce Hive ni Riverpod: las pantallas y el formulario
/// trabajan contra estos métodos, y las pruebas pueden sustituirla por un
/// doble en memoria.
abstract class CategoriaRepository {
  /// Categorías visibles, ordenadas por nombre.
  ///
  /// Por defecto deja fuera las archivadas: archivar es la forma de quitar una
  /// categoría de la lista sin borrar sus movimientos. Con [incluirArchivadas]
  /// se obtienen todas, como en la sección «Archivadas».
  Future<List<Categoria>> listar({bool incluirArchivadas = false});

  Future<Categoria?> obtener(String id);

  /// Crea una categoría con un id nuevo.
  ///
  /// Lanza [CategoriaDuplicadaException] si ya existe una con ese nombre.
  Future<Categoria> crear({
    required String nombre,
    required TipoCategoria tipo,
  });

  /// Actualiza la categoría conservando su id.
  ///
  /// Lanza [CategoriaDuplicadaException] si el nombre ya lo usa otra.
  Future<void> actualizar(Categoria categoria);

  /// Marca la categoría como archivada. No borra nada: los movimientos siguen.
  Future<void> archivar(String id);

  /// Devuelve la categoría a la lista principal.
  Future<void> desarchivar(String id);

  /// Elimina la categoría solo si no tiene movimientos.
  ///
  /// Se lanza [CategoriaEnUsoException] cuando aún hay movimientos: borrarlos
  /// en cascada sin avisar perdería el histórico.
  Future<void> eliminar(String id);

  /// Cantidad de movimientos asociados; es la regla de «está en uso».
  Future<int> movimientosDe(String id);

  /// `true` si otra categoría ya usa ese nombre (sin distinguir mayúsculas).
  /// Es el equivalente a la restricción UNIQUE de una base relacional.
  Future<bool> existeNombre(String nombre, {String? exceptoId});
}

/// El nombre de la categoría ya está ocupado.
class CategoriaDuplicadaException implements Exception {
  const CategoriaDuplicadaException(this.nombre);

  final String nombre;

  @override
  String toString() => 'Ya existe una categoría llamada «$nombre».';
}

/// La categoría tiene movimientos y no se puede eliminar.
class CategoriaEnUsoException implements Exception {
  const CategoriaEnUsoException(this.cantidadMovimientos);

  final int cantidadMovimientos;

  @override
  String toString() =>
      'La categoría tiene $cantidadMovimientos movimientos asociados.';
}
