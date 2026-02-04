import 'package:flutter/material.dart';

import '../../models/category_models.dart';
import '../../repositories/category_repository.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryRepository repo = CategoryRepository();
  List<CategoryModels> categorias = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarCategoria();
  }

  Future<void> cargarCategoria() async {
    setState(() => cargando = true);
    categorias = await repo.getAll();
    setState(() => cargando = false);
  }

  void eliminarCategoria(int id) async {
    // Verifico si hay productos asociados
    final productosRelacionados = await repo.getProductsByCategoryId(id);

    if (productosRelacionados.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'No se puede eliminar la categoría. Existen productos relacionados.',
            textAlign: TextAlign.center,
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar Categoría'),
        content: const Text(
          '¿Estás seguro que deseas eliminar esta categoría?',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await repo.delete(id);
              Navigator.pop(context);
              await cargarCategoria();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Categoría eliminada',
                    textAlign: TextAlign.center,
                  ),
                  duration: const Duration(milliseconds: 800),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: const Text('Sí'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Categorías'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : categorias.isEmpty
          ? const Center(child: Text('No existen categorías'))
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'CATEGORÍA',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'DESCRIPCIÓN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'ACCIONES',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: categorias.length,
                    itemBuilder: (context, i) {
                      final cat = categorias[i];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // CATEGORÍA
                              Expanded(
                                flex: 2,
                                child: Text(
                                  cat.nombre,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(flex: 2, child: Text(cat.descripcion)),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.orange,
                                    ),
                                    onPressed: () async {
                                      await Navigator.pushNamed(
                                        context,
                                        '/categoria/form',
                                        arguments: cat,
                                      );
                                      cargarCategoria();
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        eliminarCategoria(cat.id as int),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/categoria/form');
          cargarCategoria();
        },
        child: const Icon(Icons.add_circle_outline, color: Colors.white),
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
      ),
    );
  }
}
