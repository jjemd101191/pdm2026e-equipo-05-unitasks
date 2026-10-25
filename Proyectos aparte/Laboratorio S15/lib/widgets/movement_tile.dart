import 'package:flutter/material.dart';
import '../models/movement.dart';

class MovementTile extends StatelessWidget {
  const MovementTile({super.key, required this.movement});
  final Movement movement;

  @override
  Widget build(BuildContext context) {
    final color = movement.isIncome
        ? const Color(0xFF256B55)
        : const Color(0xFF424858);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: movement.isIncome
            ? const Color(0xFFE0F1E8)
            : const Color(0xFFEBEDF3),
        foregroundColor: color,
        child: Icon(movement.isIncome ? Icons.south_west : Icons.north_east),
      ),
      title: Text(
        movement.title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text('${movement.category} · ${movement.formattedDate}'),
      trailing: Text(
        movement.formattedAmount,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
      isThreeLine: true,
    );
  }
}
