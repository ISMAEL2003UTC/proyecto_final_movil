import 'package:flutter/material.dart';

import '../../models/products_models.dart';
import '../../repositories/products_repository.dart';

class ProductoScreen extends StatefulWidget {
  const ProductoScreen({super.key});

  @override
  State<ProductoScreen> createState() => _ProductoScreenState();
}

class _ProductoScreenState extends State<ProductoScreen> {
  final ProductsRepository repo = ProductsRepository();
  List<ProductsModels> productos = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarProducto();
  }

  Future<void> cargarProducto() async {
    setState(() => cargando = true);
    {
      productos = await repo.getAll();
      setState(() => cargando = false);
    }
    ;
  }

  void eliminarProducto(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Eliminar Producto'),
        content: Text('Estas seguro que deseas eliminar este Producto?'),
        actions: [
          TextButton(
            onPressed: () async {
              await repo.delete(id);
              Navigator.pop(context);
              cargarProducto();
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
        title: Text('Listado de Productos'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: cargando
          ? Center(child: CircularProgressIndicator())
          : productos.isEmpty
          ? Center(child: Text('No existen productos'))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, i) {
                  final prod = productos[i];
                  return Card(
                    child: ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.inventory_2),
                          SizedBox(width: 5),
                          Text(
                            prod.nombre,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Código: ${prod.codigo}"),
                          Text("Descripción: ${prod.descripcion}"),
                          Text("Precio: ${prod.precio.toString()}"),
                          Text("Costo: ${prod.costo.toString()}"),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              await Navigator.pushNamed(
                                context,
                                '/producto/form',
                                arguments: prod,
                              );
                              cargarProducto();
                            },
                            icon: Icon(Icons.edit, color: Colors.orange),
                          ),
                          IconButton(
                            onPressed: () => eliminarProducto(prod.id as int),
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/producto/form');
          cargarProducto();
        },
        child: Icon(Icons.add_circle_outline, color: Colors.white),
        backgroundColor: Colors.black,
        shape: CircleBorder(),
      ),
    );
  }
}
