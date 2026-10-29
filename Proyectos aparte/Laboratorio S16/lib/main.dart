import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/local_store.dart';
import 'data/providers.dart';
import 'data/seed_data.dart';
import 'models/categoria.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await LocalStore.abrir();
  await sembrarDatosIniciales(store);
  runApp(
    ProviderScope(
      overrides: [localStoreProvider.overrideWithValue(store)],
      child: const LaboratorioS16App(),
    ),
  );
}

class LaboratorioS16App extends StatelessWidget {
  const LaboratorioS16App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laboratorio S16',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
        useMaterial3: true,
      ),
      home: const CategoriasScreen(),
    );
  }
}

/// Lista de categorías guardadas.
///
/// Es el punto de partida del CRUD: el formulario, las reglas de borrado y las
/// pruebas de widget se construyen encima de este listado.
class CategoriasScreen extends ConsumerWidget {
  const CategoriasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categorias = ref.watch(categoriasProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      body: categorias.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _Estado(
          icono: Icons.error_outline,
          mensaje: 'No pudimos cargar tus categorías.',
        ),
        data: (lista) {
          if (lista.isEmpty) {
            return const _Estado(
              icono: Icons.category_outlined,
              mensaje: 'Aún no hay categorías.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: lista.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, indice) {
              final categoria = lista[indice];
              return ListTile(
                leading: Icon(
                  categoria.tipo == TipoCategoria.gasto
                      ? Icons.arrow_downward
                      : Icons.arrow_upward,
                ),
                title: Text(categoria.nombre),
                subtitle: Text(categoria.tipo.etiqueta),
              );
            },
          );
        },
      ),
    );
  }
}

class _Estado extends StatelessWidget {
  const _Estado({required this.icono, required this.mensaje});

  final IconData icono;
  final String mensaje;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 44, color: Colors.grey),
            const SizedBox(height: 12),
            Text(mensaje, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
