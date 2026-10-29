import 'package:flutter/material.dart';

import 'course.dart';

/// Filtro inmutable del listado de cursos.
class CourseFilter {
  const CourseFilter({
    this.periodo = 'Todos',
    this.soloPendientes = false,
    this.texto = '',
  });

  final String periodo;
  final bool soloPendientes;
  final String texto;

  CourseFilter copyWith({
    String? periodo,
    bool? soloPendientes,
    String? texto,
  }) => CourseFilter(
    periodo: periodo ?? this.periodo,
    soloPendientes: soloPendientes ?? this.soloPendientes,
    texto: texto ?? this.texto,
  );

  bool acepta(Course curso) {
    final coincidePeriodo = periodo == 'Todos' || curso.periodo == periodo;
    final coincidePendientes = !soloPendientes || curso.pendientes > 0;
    final consulta = texto.trim().toLowerCase();
    final coincideTexto =
        consulta.isEmpty ||
        curso.nombre.toLowerCase().contains(consulta) ||
        curso.docente.toLowerCase().contains(consulta);
    return coincidePeriodo && coincidePendientes && coincideTexto;
  }

  @override
  bool operator ==(Object other) =>
      other is CourseFilter &&
      periodo == other.periodo &&
      soloPendientes == other.soloPendientes &&
      texto == other.texto;

  @override
  int get hashCode => Object.hash(periodo, soloPendientes, texto);
}

/// Notifica al listado para volver a consultar y filtrar cuando cambia el filtro.
class CourseFilterNotifier extends ValueNotifier<CourseFilter> {
  CourseFilterNotifier() : super(const CourseFilter());

  void actualizar(CourseFilter filtro) {
    if (value != filtro) value = filtro;
  }
}
