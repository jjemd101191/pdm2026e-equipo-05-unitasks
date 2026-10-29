import '../models/categoria.dart';
import '../models/movimiento.dart';
import 'local_store.dart';
import 'serialization.dart';

/// Datos de ejemplo que se cargan una sola vez, en la primera apertura.
///
/// La marca `sembrado` evita que reaparezcan si el usuario borra todo.
Future<void> sembrarDatosIniciales(LocalStore store) async {
  if (store.sembrado) return;

  final categorias = <Categoria>[
    const Categoria(
      id: 'cat-gastos',
      nombre: 'Gastos',
      tipo: TipoCategoria.gasto,
    ),
    const Categoria(
      id: 'cat-super',
      nombre: 'Súper y comida',
      tipo: TipoCategoria.gasto,
    ),
    const Categoria(
      id: 'cat-viejo',
      nombre: 'Viejo',
      tipo: TipoCategoria.gasto,
      archivado: true,
    ),
  ];

  for (final categoria in categorias) {
    await store.guardarCategoria(categoria.id, categoriaAJson(categoria));
  }

  final hoy = DateTime.now();
  final movimientos = <Movimiento>[
    Movimiento(
      id: 'mov-1',
      categoriaId: 'cat-gastos',
      descripcion: 'Transporte',
      monto: -25,
      fecha: hoy.subtract(const Duration(days: 1)),
    ),
    Movimiento(
      id: 'mov-2',
      categoriaId: 'cat-gastos',
      descripcion: 'Internet',
      monto: -180,
      fecha: hoy.subtract(const Duration(days: 3)),
    ),
    Movimiento(
      id: 'mov-3',
      categoriaId: 'cat-gastos',
      descripcion: 'Luz',
      monto: -95,
      fecha: hoy.subtract(const Duration(days: 5)),
    ),
    Movimiento(
      id: 'mov-4',
      categoriaId: 'cat-super',
      descripcion: 'Despensa',
      monto: -210,
      fecha: hoy.subtract(const Duration(days: 2)),
    ),
    Movimiento(
      id: 'mov-5',
      categoriaId: 'cat-super',
      descripcion: 'Mercado',
      monto: -60,
      fecha: hoy.subtract(const Duration(days: 4)),
    ),
  ];

  for (final movimiento in movimientos) {
    await store.guardarMovimiento(movimiento.id, movimientoAJson(movimiento));
  }

  await store.marcarSembrado();
}
