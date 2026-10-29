import '../models/categoria.dart';
import '../utils/id.dart';
import 'categoria_repository.dart';
import 'local_store.dart';
import 'serialization.dart';

/// Implementación de [CategoriaRepository] sobre el almacenamiento local Hive.
class HiveCategoriaRepository implements CategoriaRepository {
  HiveCategoriaRepository(this._store);

  final LocalStore _store;

  @override
  Future<List<Categoria>> listar({bool incluirArchivadas = false}) async {
    final categorias = _store.categoriasJson
        .map(categoriaDesdeJson)
        .where((categoria) => incluirArchivadas || !categoria.archivado)
        .toList();
    categorias.sort(
      (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()),
    );
    return categorias;
  }

  @override
  Future<Categoria?> obtener(String id) async {
    for (final json in _store.categoriasJson) {
      if (json['id'] == id) return categoriaDesdeJson(json);
    }
    return null;
  }

  @override
  Future<Categoria> crear({
    required String nombre,
    required TipoCategoria tipo,
  }) async {
    final limpio = nombre.trim();
    if (limpio.isEmpty) {
      throw ArgumentError.value(nombre, 'nombre', 'No puede estar vacío');
    }
    if (await existeNombre(limpio)) {
      throw CategoriaDuplicadaException(limpio);
    }
    final categoria = Categoria(id: nuevoId('cat'), nombre: limpio, tipo: tipo);
    await _guardar(categoria);
    return categoria;
  }

  @override
  Future<void> actualizar(Categoria categoria) async {
    final limpio = categoria.nombre.trim();
    if (limpio.isEmpty) {
      throw ArgumentError.value(
        categoria.nombre,
        'nombre',
        'No puede estar vacío',
      );
    }
    if (await existeNombre(limpio, exceptoId: categoria.id)) {
      throw CategoriaDuplicadaException(limpio);
    }
    // El id no se toca: editar es el mismo registro con los datos nuevos.
    await _guardar(categoria.copyWith(nombre: limpio));
  }

  @override
  Future<void> archivar(String id) async {
    final categoria = await obtener(id);
    // Si ya no existe, archivar no es un error: la lista ya está como debía.
    if (categoria == null) return;
    await _guardar(categoria.copyWith(archivado: true));
  }

  @override
  Future<void> desarchivar(String id) async {
    final categoria = await obtener(id);
    if (categoria == null) return;
    await _guardar(categoria.copyWith(archivado: false));
  }

  @override
  Future<void> eliminar(String id) async {
    final movimientos = await movimientosDe(id);
    if (movimientos > 0) {
      throw CategoriaEnUsoException(movimientos);
    }
    await _store.eliminarCategoria(id);
  }

  @override
  Future<int> movimientosDe(String id) async =>
      _store.movimientosJson.where((json) => json['categoriaId'] == id).length;

  @override
  Future<bool> existeNombre(String nombre, {String? exceptoId}) async {
    final buscado = nombre.trim().toLowerCase();
    for (final json in _store.categoriasJson) {
      final categoria = categoriaDesdeJson(json);
      if (categoria.id == exceptoId) continue;
      if (categoria.nombre.trim().toLowerCase() == buscado) return true;
    }
    return false;
  }

  Future<void> _guardar(Categoria categoria) =>
      _store.guardarCategoria(categoria.id, categoriaAJson(categoria));
}
