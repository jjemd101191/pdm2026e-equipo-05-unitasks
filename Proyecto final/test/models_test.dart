import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/course.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/course_summary.dart';
import 'package:pdm2026e_equipo_05_unitasks/models/task.dart';

import 'support/fakes.dart';

void main() {
  group('Task', () {
    test('el recordatorio se calcula restando minutos a la entrega', () {
      final entrega = DateTime(2026, 10, 30, 23, 59);

      expect(
        tareaPrueba(
          fechaEntrega: entrega,
          recordatorioMinutos: 60,
        ).fechaRecordatorio,
        DateTime(2026, 10, 30, 22, 59),
      );
      expect(
        tareaPrueba(
          fechaEntrega: entrega,
          recordatorioMinutos: 2 * 24 * 60,
        ).fechaRecordatorio,
        DateTime(2026, 10, 28, 23, 59),
      );
      expect(tareaPrueba(fechaEntrega: entrega).fechaRecordatorio, isNull);
    });

    test(
      'la etiqueta del recordatorio usa la opción conocida o los minutos',
      () {
        expect(
          tareaPrueba(recordatorioMinutos: 60).etiquetaRecordatorio,
          '1 hora antes',
        );
        expect(
          tareaPrueba(recordatorioMinutos: 45).etiquetaRecordatorio,
          '45 minutos antes',
        );
        expect(
          RecordatorioOpcion.desdeMinutos(24 * 60),
          RecordatorioOpcion.unDia,
        );
        expect(
          RecordatorioOpcion.desdeMinutos(null),
          RecordatorioOpcion.sinRecordatorio,
        );
        expect(RecordatorioOpcion.desdeMinutos(7), isNull);
      },
    );

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
      expect(tareaPrueba(estado: EstadoTarea.completada).progreso, 1);
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

    test('vencida depende de la fecha y de si ya se completó', () {
      final ahora = DateTime(2026, 10, 29, 12);
      final ayer = DateTime(2026, 10, 28, 23, 59);

      expect(tareaPrueba(fechaEntrega: ayer).vencidaEn(ahora), isTrue);
      expect(
        tareaPrueba(
          fechaEntrega: ayer,
          estado: EstadoTarea.completada,
        ).vencidaEn(ahora),
        isFalse,
      );
      expect(
        tareaPrueba(fechaEntrega: DateTime(2026, 10, 30)).vencidaEn(ahora),
        isFalse,
      );
    });

    test('copyWith cambia solo lo indicado y puede quitar el recordatorio', () {
      final original = tareaPrueba(recordatorioMinutos: 60);

      final renombrada = original.copyWith(titulo: 'Otro título');
      expect(renombrada.titulo, 'Otro título');
      expect(renombrada.recordatorioMinutos, 60);
      expect(renombrada.id, original.id);

      expect(original.copyWith().recordatorioMinutos, 60);
      expect(
        original.copyWith(quitarRecordatorio: true).recordatorioMinutos,
        isNull,
      );
    });

    test('dos tareas con los mismos datos son iguales', () {
      final fecha = DateTime(2026, 11, 3, 10);
      const subtareas = [Subtask(id: 's1', titulo: 'Uno')];
      final a = tareaPrueba(fechaEntrega: fecha, subtareas: subtareas);
      final b = tareaPrueba(fechaEntrega: fecha, subtareas: [...subtareas]);

      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(a.alternarSubtarea('s1')));
      expect(a, isNot(a.copyWith(cursoId: 'otro')));
    });

    test('la lista de subtareas no se puede modificar desde fuera', () {
      final tarea = tareaPrueba();
      expect(
        () => tarea.subtareas.add(const Subtask(id: 'x', titulo: 'x')),
        throwsUnsupportedError,
      );
    });
  });

  group('Course', () {
    test('la igualdad compara todos los campos, no solo el id', () {
      expect(cursoPrueba(), cursoPrueba());
      expect(cursoPrueba().hashCode, cursoPrueba().hashCode);
      expect(cursoPrueba(), isNot(cursoPrueba(nombre: 'Otro nombre')));
    });

    test('porId encuentra el curso o devuelve uno de reemplazo', () {
      final cursos = [cursoPrueba(), cursoPrueba(id: 'b', nombre: 'Curso B')];

      expect(cursos.porId('b').nombre, 'Curso B');
      final desconocido = cursos.porId('no-existe');
      expect(desconocido.id, 'no-existe');
      expect(desconocido.nombre, 'Curso no disponible');
    });
  });

  test('CourseSummary cuenta tareas y pendientes por curso', () {
    final cursos = [cursoPrueba(id: 'a'), cursoPrueba(id: 'b')];
    final tareas = [
      tareaPrueba(id: '1', cursoId: 'a'),
      tareaPrueba(id: '2', cursoId: 'a', estado: EstadoTarea.completada),
      tareaPrueba(id: '3', cursoId: 'a'),
    ];

    final resumenes = CourseSummary.deCursos(cursos, tareas);

    expect(resumenes.first.totalTareas, 3);
    expect(resumenes.first.pendientes, 2);
    expect(resumenes.first.avance, closeTo(1 / 3, 0.001));
    expect(resumenes.last.totalTareas, 0);
    expect(resumenes.last.avance, 0);
  });
}
