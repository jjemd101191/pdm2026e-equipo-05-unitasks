import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/movement_repository.dart';
import '../models/movement.dart';

/// Permite sustituir la fuente de datos en las pruebas.
final movementRepositoryProvider = Provider<MovementRepository>(
  (ref) => demoMovementRepository,
);

class MovementsNotifier extends AsyncNotifier<List<Movement>> {
  MovementRepository get _repository => ref.read(movementRepositoryProvider);

  @override
  Future<List<Movement>> build() => _repository.fetchMovements();

  /// Vuelve a consultar la fuente y expone carga o error según el resultado.
  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.fetchMovements);
  }

  /// Borra primero en el repositorio. La fila se retira del estado en
  /// [confirmDeletion], cuando Dismissible ya terminó su animación.
  Future<bool> deleteInRepository(String id) async {
    try {
      await _repository.deleteMovement(id);
      return true;
    } catch (_) {
      return false;
    }
  }

  void confirmDeletion(String id) {
    final movements = state.value;
    if (movements == null) return;
    state = AsyncData(
      movements.where((movement) => movement.id != id).toList(growable: false),
    );
  }

  /// Restaura el registro con el mismo id y los mismos datos en su posición.
  Future<bool> restore(Movement movement, {int? index}) async {
    try {
      await _repository.restoreMovement(movement, index: index);
    } catch (_) {
      return false;
    }
    final movements = [...?state.value];
    final position = (index ?? movements.length).clamp(0, movements.length);
    movements.insert(position, movement);
    state = AsyncData(movements);
    return true;
  }
}

final movementsProvider =
    AsyncNotifierProvider<MovementsNotifier, List<Movement>>(
      MovementsNotifier.new,
    );
