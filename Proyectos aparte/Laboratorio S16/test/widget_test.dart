import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio_s16/data/categoria_repository.dart';
import 'package:laboratorio_s16/data/providers.dart';
import 'package:laboratorio_s16/main.dart';
import 'package:laboratorio_s16/models/categoria.dart';

/// Repositorio en memoria: el widget test no toca Hive.
///
/// El I/O real dentro de `testWidgets` corre en tiempo simulado y se cuelga;
/// las pruebas de almacenamiento usan `test()` y van aparte.
class _RepositorioMemoria implements CategoriaRepository {
  @override
  Future<List<Categoria>> listar({bool incluirArchivadas = false}) async => [
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
  ];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('la app abre y muestra las categorías visibles', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          categoriaRepositoryProvider.overrideWithValue(_RepositorioMemoria()),
        ],
        child: const LaboratorioS16App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Gastos'), findsOneWidget);
    expect(find.text('Súper y comida'), findsOneWidget);
  });
}
