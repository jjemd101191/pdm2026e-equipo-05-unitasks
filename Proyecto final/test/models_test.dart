import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/task.dart';

import 'support/fakes.dart';

void main() {
  test('el recordatorio calcula la hora de aviso desde la entrega', () {
    final entrega = DateTime(2026, 10, 30, 23, 59);

    expect(
      RecordatorioOpcion.unaHora.programadoPara(entrega),
      DateTime(2026, 10, 30, 22, 59),
    );
    expect(
      RecordatorioOpcion.mismoDia.programadoPara(entrega),
      DateTime(2026, 10, 30, 8),
    );
    expect(
      RecordatorioOpcion.unDia.programadoPara(entrega),
      DateTime(2026, 10, 29, 8),
    );
    expect(
      RecordatorioOpcion.dosDias.programadoPara(entrega),
      DateTime(2026, 10, 28, 8),
    );
    expect(RecordatorioOpcion.sinRecordatorio.programadoPara(entrega), isNull);
    expect(RecordatorioOpcion.unDia.programadoPara(null), isNull);
  });

  test('completar una tarea marca todas sus subtareas', () {
    final tarea = tareaPrueba(
      subtareas: const [
        Subtask(id: 's1', titulo: 'Uno', hecha: true),
        Subtask(id: 's2', titulo: 'Dos'),
      ],
    );

    final completada = tarea.alternarCompletada();
    expect(completada.completada, isTrue);
    expect(completada.completadas, 2);
    expect(completada.progreso, 1);

    final reabierta = completada.alternarCompletada();
    expect(reabierta.estado, EstadoTarea.enProgreso);
    expect(reabierta.completadas, 2);
  });

  test('una tarea completada sin subtareas muestra 100 %', () {
    final tarea = tareaPrueba(estado: EstadoTarea.completada);
    expect(tarea.progreso, 1);
    expect(tareaPrueba().progreso, 0);
  });

  test('desmarcar una subtarea reabre una tarea completada', () {
    final tarea = tareaPrueba(
      estado: EstadoTarea.completada,
      subtareas: const [
        Subtask(id: 's1', titulo: 'Uno', hecha: true),
        Subtask(id: 's2', titulo: 'Dos', hecha: true),
      ],
    );

    final reabierta = tarea.alternarSubtarea('s2');
    expect(reabierta.estado, EstadoTarea.enProgreso);
    expect(reabierta.completadas, 1);
    expect(reabierta.progreso, 0.5);
  });
}
