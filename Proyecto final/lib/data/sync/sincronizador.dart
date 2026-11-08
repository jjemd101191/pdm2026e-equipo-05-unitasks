import 'dart:async';

import 'package:flutter/foundation.dart';

import '../db/app_database.dart';
import '../db/tareas_dao.dart';
import '../drift_course_repository.dart';
import '../drift_task_repository.dart';
import '../seed_data.dart';
import 'estado_sync.dart';
import 'modelos_remotos.dart';
import 'remoto_sync.dart';

/// Mantiene al día la copia local de una cuenta con la de Firestore.
///
/// Estrategia:
/// - Al empezar, lee la nube una vez. Si la cuenta está vacía, adopta las
///   filas locales sin dueño o siembra la cuenta nueva y las sube. Si no,
///   descarga y aplica.
/// - Después escucha los cambios remotos y los aplica a Drift.
/// - Los cambios locales los sube el repositorio sincronizado, así que aquí
///   no se vuelve a escribir lo que llega de vuelta (no hay bucle de eco).
///
/// Conflicto: gana la marca `actualizadaEn` más reciente. Las escrituras que
/// llegan de la nube no reescriben su propia marca de tiempo.
class Sincronizador {
  Sincronizador({
    required this.db,
    required this.remoto,
    required this.usuarioId,
  });

  final AppDatabase db;
  final RemotoSync remoto;
  final String usuarioId;

  /// Lo observa el Perfil para mostrar «Al día», «Sin conexión»…
  final ValueNotifier<EstadoSync> estado = ValueNotifier(
    EstadoSync.sincronizando,
  );

  StreamSubscription<List<CursoRemoto>>? _subCursos;
  StreamSubscription<List<TareaRemota>>? _subTareas;
  List<TareaRemota> _ultimasTareas = const [];
  bool _iniciado = false;
  bool _detenido = false;

  /// Primera pasada + escucha de cambios. No bloquea: si falla, la app sigue
  /// funcionando con los datos locales.
  Future<void> iniciar() async {
    if (_iniciado) return;
    _iniciado = true;
    await sincronizarAhora();
  }

  /// Reintenta la sincronización (botón «Sincronizar ahora» del Perfil).
  Future<void> sincronizarAhora() async {
    if (_detenido) return;
    estado.value = EstadoSync.sincronizando;
    try {
      final cursos = await remoto
          .observarCursos(usuarioId)
          .first
          .timeout(const Duration(seconds: 12));
      final tareas = await remoto
          .observarTareas(usuarioId)
          .first
          .timeout(const Duration(seconds: 12));

      if (cursos.isEmpty && tareas.isEmpty) {
        await _subirTodo();
      } else {
        await _aplicarCursos(cursos);
        await _aplicarTareas(tareas);
      }
      _escuchar();
      if (!_detenido) estado.value = EstadoSync.alDia;
    } on TimeoutException {
      if (!_detenido) estado.value = EstadoSync.sinConexion;
    } catch (_) {
      if (!_detenido) estado.value = EstadoSync.error;
    }
  }

  void _escuchar() {
    if (_subCursos != null || _detenido) return;
    _subCursos = remoto
        .observarCursos(usuarioId)
        .listen(
          (cursos) => unawaited(_aplicarCursos(cursos)),
          onError: (_) => estado.value = EstadoSync.error,
        );
    _subTareas = remoto
        .observarTareas(usuarioId)
        .listen(
          (tareas) => unawaited(_aplicarTareas(tareas)),
          onError: (_) => estado.value = EstadoSync.error,
        );
  }

  /// Cuenta nueva o base recién instalada: adopta lo local sin dueño, siembra
  /// si no hay nada y sube todo.
  Future<void> _subirTodo() async {
    final cursosLocales = await db.cursosDao.todos(usuarioId);
    final tareasLocales = await db.tareasDao.todos(usuarioId);
    if (cursosLocales.isEmpty && tareasLocales.isEmpty) {
      final adoptadosCursos = await db.cursosDao.reclamarSinDueno(usuarioId);
      final adoptadasTareas = await db.tareasDao.reclamarSinDueno(usuarioId);
      if (adoptadosCursos == 0 && adoptadasTareas == 0) {
        await sembrarDatosIniciales(db, usuarioId: usuarioId);
      }
    }

    for (final fila in await db.cursosDao.todos(usuarioId)) {
      await remoto.guardarCurso(usuarioId, _cursoRemoto(fila));
    }
    for (final fila in await db.tareasDao.todos(usuarioId)) {
      await remoto.guardarTarea(usuarioId, _tareaRemota(fila));
    }
  }

  Future<void> _aplicarCursos(List<CursoRemoto> remotos) async {
    if (_detenido) return;
    final ids = <String>{};
    for (final remotoCurso in remotos) {
      final id = remotoCurso.curso.id;
      ids.add(id);
      final local = await db.cursosDao.buscar(id);
      final marcaLocal = local == null
          ? null
          : (local.actualizadaEn ?? local.creadoEn);
      final esDeOtroUsuario = local != null && local.usuarioId != usuarioId;
      final remotoEsMasNuevo =
          marcaLocal == null || remotoCurso.actualizadaEn.isAfter(marcaLocal);
      if (local == null || esDeOtroUsuario || remotoEsMasNuevo) {
        await db.cursosDao.guardarDesdeRemoto(
          cursoAFila(
            remotoCurso.curso,
            usuarioId: usuarioId,
            actualizadaEn: remotoCurso.actualizadaEn,
            creadaEn: remotoCurso.creadaEn,
          ),
        );
      }
    }

    for (final local in await db.cursosDao.todos(usuarioId)) {
      if (ids.contains(local.id)) continue;
      try {
        await db.cursosDao.eliminarDeUsuario(usuarioId, local.id);
      } on Exception {
        // Todavía tiene tareas locales; se reintenta cuando lleguen a borrarse.
      }
    }

    // Si alguna tarea había llegado antes que su curso, ahora ya se puede.
    if (_ultimasTareas.isNotEmpty) await _aplicarTareas(_ultimasTareas);
  }

  Future<void> _aplicarTareas(List<TareaRemota> remotos) async {
    if (_detenido) return;
    _ultimasTareas = remotos;
    final ids = <String>{};
    for (final remotaTarea in remotos) {
      final id = remotaTarea.tarea.id;
      ids.add(id);
      final local = await db.tareasDao.buscar(id);
      final marcaLocal = local?.tarea.actualizadaEn;
      final esDeOtroUsuario =
          local != null && local.tarea.usuarioId != usuarioId;
      final remotoEsMasNuevo =
          marcaLocal == null || remotaTarea.actualizadaEn.isAfter(marcaLocal);
      if (local == null || esDeOtroUsuario || remotoEsMasNuevo) {
        try {
          await db.tareasDao.guardarDesdeRemoto(
            tareaAFila(
              remotaTarea.tarea,
              usuarioId: usuarioId,
              actualizadaEn: remotaTarea.actualizadaEn,
              creadaEn: remotaTarea.creadaEn,
            ),
            subtareasAFilas(remotaTarea.tarea),
            remotaTarea.tarea.recordatorioMinutos,
          );
        } on Exception {
          // El curso aún no existe localmente (clave foránea). Se reintenta
          // en la siguiente pasada.
        }
      }
    }

    for (final local in await db.tareasDao.todos(usuarioId)) {
      if (ids.contains(local.tarea.id)) continue;
      await db.tareasDao.eliminarDeUsuario(usuarioId, local.tarea.id);
    }
  }

  CursoRemoto _cursoRemoto(CursoFila fila) => CursoRemoto(
    curso: cursoDesdeFila(fila),
    actualizadaEn: fila.actualizadaEn ?? fila.creadoEn,
    creadaEn: fila.creadoEn,
  );

  TareaRemota _tareaRemota(TareaConDetalle fila) => TareaRemota(
    tarea: tareaDesdeFilas(fila),
    actualizadaEn: fila.tarea.actualizadaEn,
    creadaEn: fila.tarea.creadaEn,
  );

  Future<void> detener() async {
    _detenido = true;
    await _subCursos?.cancel();
    await _subTareas?.cancel();
    _subCursos = null;
    _subTareas = null;
  }
}
