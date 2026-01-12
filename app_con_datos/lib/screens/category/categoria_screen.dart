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
    {
      categorias = await repo.getAll();
      setState(() => cargando = false);
    }
    ;
  }

  void eliminarCategoria(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Eliminar Categoria'),
        content: Text('Estas seguro que deseas eliminar esta categoría?'),
        actions: [
          TextButton(
            onPressed: () async {
              await repo.delete(id);
              Navigator.pop(context);
              cargarCategoria();
            },
            child: Text('Si'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('No'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de categorias'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),

      body: cargando
          ? Center(child: CircularProgressIndicator())
          : categorias.isEmpty
          ? Center(child: Text('No existen categorias'))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: categorias.length,
                itemBuilder: (context, i) {
                  final cat = categorias[i];
                  return Card(
                    child: ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.category),
                          SizedBox(width: 5),

                          Text(
                            cat.nombre,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Código: ${cat.codigo}"),
                          Text("Descripción: ${cat.descripcion}"),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              await Navigator.pushNamed(
                                context,
                                '/categoria/form',
                                arguments: cat,
                              );
                              cargarCategoria();
                            },
                            icon: Icon(Icons.edit, color: Colors.orange),
                          ),
                          IconButton(
                            onPressed: () => eliminarCategoria(cat.id as int),
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

      //Center(child: Text('Listado de categorías')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/categoria/form');
          cargarCategoria();
        },
        child: Icon(Icons.add_circle_outline, color: Colors.white),
        backgroundColor: Colors.black,
        shape: CircleBorder(),
      ),
    );
  }
}
