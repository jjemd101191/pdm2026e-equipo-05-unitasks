import '../models/movement.dart';
import 'sample_movements.dart';

/// Fuente de datos del laboratorio. Se mantiene en memoria porque la app
/// todavía no tiene base local; el alcance de la S15 permite esta alternativa.
abstract class MovementRepository {
  Future<List<Movement>> fetchMovements();
  Future<void> deleteMovement(String id);
  Future<void> restoreMovement(Movement movement, {int? index});
}

class DemoMovementRepository implements MovementRepository {
  DemoMovementRepository({List<Movement>? movements})
    : _movements = List<Movement>.of(movements ?? sampleMovements);

  final List<Movement> _movements;

  @override
  Future<List<Movement>> fetchMovements() async {
    // Simula la consulta a una base de datos para ejercitar los estados de UI.
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return List<Movement>.of(_movements);
  }

  @override
  Future<void> deleteMovement(String id) async {
    final index = _movements.indexWhere((movement) => movement.id == id);
    if (index == -1) throw StateError('No existe el movimiento $id');
    _movements.removeAt(index);
  }

  @override
  Future<void> restoreMovement(Movement movement, {int? index}) async {
    if (_movements.any((actual) => actual.id == movement.id)) {
      throw StateError('El movimiento ${movement.id} ya existe');
    }
    final position = (index ?? _movements.length).clamp(0, _movements.length);
    _movements.insert(position, movement);
  }
}

final demoMovementRepository = DemoMovementRepository();
