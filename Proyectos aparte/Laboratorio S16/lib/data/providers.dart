import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/categoria.dart';
import 'categoria_repository.dart';
import 'hive_categoria_repository.dart';
import 'local_store.dart';

/// Almacenamiento ya abierto.
///
/// `main` lo sobrescribe con la instancia real y las pruebas con una caja
/// temporal, para que nadie dependa de la plataforma al construir la app.
final localStoreProvider = Provider<LocalStore>(
  (ref) => throw UnimplementedError(
    'localStoreProvider debe sobrescribirse en main o en la prueba.',
  ),
);

/// Punto único de sustitución del repositorio en las pruebas.
final categoriaRepositoryProvider = Provider<CategoriaRepository>(
  (ref) => HiveCategoriaRepository(ref.watch(localStoreProvider)),
);

/// Lista de categorías visibles.
///
/// Después de guardar, editar, archivar o borrar, la pantalla debe llamar a
/// `ref.invalidate(categoriasProvider)`: la lista se vuelve a construir desde
/// el repositorio y nunca se agrega a mano.
class CategoriasNotifier extends AsyncNotifier<List<Categoria>> {
  @override
  Future<List<Categoria>> build() =>
      ref.watch(categoriaRepositoryProvider).listar();
}

final categoriasProvider =
    AsyncNotifierProvider<CategoriasNotifier, List<Categoria>>(
      CategoriasNotifier.new,
    );
