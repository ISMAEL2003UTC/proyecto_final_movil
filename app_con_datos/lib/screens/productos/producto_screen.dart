import 'package:flutter/material.dart';

import '../../models/category_models.dart';
import '../../models/products_models.dart';
//se importan categorias por que nos serviara mas adalente para no nos de error ya que tienen una relacion
import '../../repositories/category_repository.dart';
import '../../repositories/products_repository.dart';

class ProductoScreen extends StatefulWidget {
  const ProductoScreen({super.key});

  @override
  State<ProductoScreen> createState() => _ProductoScreenState();
}

class _ProductoScreenState extends State<ProductoScreen> {
  final ProductsRepository repo = ProductsRepository();
  final CategoryRepository categoryRepo = CategoryRepository();

  List<ProductsModels> productos = [];
  List<CategoryModels> categorias = [];
  bool cargando = true;

//funcion que me permite cargar productos y categorias
  @override
  void initState() {
    super.initState();
    cargarProducto();
    cargarCategorias();
  }
//carga las categorias de la BD
  Future<void> cargarCategorias() async {
    categorias = await categoryRepo.getAll();
    setState(() {});
  }
//carga productos de bd
  Future<void> cargarProducto() async {
    setState(() => cargando = true);
    productos = await repo.getAll();
    setState(() => cargando = false);
  }
// esta funcion me permite obtener el nombre de la categoria 
  String obtenerNombreCategoria(int? id) {
    if (id == null) return 'Sin categoría';
    final cat = categorias.firstWhere(
          (c) => c.id == id,
      orElse: () => CategoryModels(
        id: 0,
        nombre: 'Desconocida',
        descripcion: '',
      ),
    );
    return cat.nombre;
  }


  void eliminarProducto(int id) async {
    // Verifico si el producto está en alguna venta
    final ventasRelacionadas = await repo.getSalesByProductId(id);

    if (ventasRelacionadas.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'No se puede eliminar el producto. Está relacionado con ventas.',
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
        title: const Text('Eliminar Producto'),
        content: const Text('¿Estás seguro que deseas eliminar este producto?'),
        actions: [
          TextButton(
            onPressed: () async {
              await repo.delete(id);
              Navigator.pop(context);
              await cargarProducto();
              ScaffoldMessenger.of(context).showSnackBar(

                // mensaje de eliminado con exito
               SnackBar(
                  content: const Text(
                    'Producto eliminado',
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
        title: const Text('Listado de Productos'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : productos.isEmpty
          ? const Center(child: Text('No existen productos'))
          : Padding(
        padding: const EdgeInsets.all(0),
        //abajito del contenido principal del appbar hacemos una cabecera tipo tabla
        child: Column(
          children: [
            //contenedor principal de encabezado tipo tabla
            Container(
              width: double.infinity,
              color: Colors.blueAccent, // Color azul
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'PRODUCTO', //producto
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'STOCK', //stock
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'TOTAL', //total
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
              //creacion de la card que contendra todos los datos a mosntrarse de un registro
              child: ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, i) {
                  final prod = productos[i];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              prod.nombre,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,

                              ),
                            ),
                          ),
                          //producto en stock
                          Expanded(
                            flex: 1,
                            child: Text(
                              prod.stock.toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          //stock
                          Expanded(
                            flex: 1,
                            child: Text(
                              (prod.costo * prod.stock).toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          //total
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.orange),
                                onPressed: () async {
                                  await Navigator.pushNamed(
                                    context,
                                    '/producto/form',
                                    arguments: prod,
                                  );
                                  cargarProducto();
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => eliminarProducto(prod.id as int),
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

            //en este contenido guardamos la suma de el total del todo el inventario
            Container(
              width: double.infinity,
              color: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'TOTAL INVENTARIO',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,color: Colors.white
                    ),
                  ),
                  Text(
                    productos.fold(0.0, (sum, prod) => sum + (prod.costo * prod.stock)) // este operador fold va recorriendo todos los productos y va acumulando su total
                        .toStringAsFixed(2), //muestra el resultado con dos decimales
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),


                ],
              ),
            ),


          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/producto/form');
          cargarProducto();
        },
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        child:
        const Icon(Icons.add_circle_outline, color: Colors.white),
      ),
      )
    );
  }
}
