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
}

final movementsProvider =
    AsyncNotifierProvider<MovementsNotifier, List<Movement>>(
      MovementsNotifier.new,
    );
