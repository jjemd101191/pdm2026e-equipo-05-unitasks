import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/sample_movements.dart';
import '../models/movement.dart';

// Punto de integración: el equipo podrá sustituir los datos por su estado real.
final movementsProvider = Provider<List<Movement>>((ref) => sampleMovements);
