import 'package:flutter/material.dart';

import '../../models/products_models.dart';
import '../../models/category_models.dart';
import '../../repositories/products_repository.dart';
import '../../repositories/category_repository.dart';

class ProductoFormScreen extends StatefulWidget {
   ProductoFormScreen({super.key});

  @override
  State<ProductoFormScreen> createState() => _ProductoFormScreenState();
}

class _ProductoFormScreenState extends State<ProductoFormScreen> {
  final formProducts = GlobalKey<FormState>();
  final codigoController = TextEditingController();
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  final precioController = TextEditingController();
  final costoController = TextEditingController();
  final stockController = TextEditingController();

  ProductsModels? producto;

  // --- Variables para la categoría ---
  final categoryRepo = CategoryRepository();
  List<CategoryModels> categorias = [];
  int? selectedCategoriaId;

  @override
  void initState() {
    super.initState();
    cargarCategorias();
  }

  void cargarCategorias() async {
    categorias = await categoryRepo.getAll();
    // Si estamos editando, seleccionamos la categoría actual del producto
    if (producto != null) {
      selectedCategoriaId = producto!.categoriaId;
    }
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Capturo el producto si se envía por argumentos
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      producto = args as ProductsModels;
      codigoController.text = producto!.codigo;
      nombreController.text = producto!.nombre;
      descripcionController.text = producto!.descripcion;
      precioController.text = producto!.precio.toString();
      costoController.text = producto!.costo.toString();
      stockController.text = producto!.stock.toString();
      selectedCategoriaId = producto!.categoriaId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = producto != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? "Editar Producto" : "Agregar Producto"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding:  EdgeInsets.all(20),
        child: Form(
          key: formProducts,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Código
                TextFormField(
                  controller: codigoController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "El código es requerido";
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Código',
                    prefixIcon: Icon(Icons.barcode_reader, color: Colors.black),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                SizedBox(height: 15),

                // Nombre
                TextFormField(
                  controller: nombreController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "El nombre es requerido";
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    prefixIcon: Icon(Icons.inventory_2, color: Colors.black),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                SizedBox(height: 15),

                // Descripción
                TextFormField(
                  controller: descripcionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "La descripción es requerida";
                    return null;
                  },
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    prefixIcon: Icon(Icons.text_snippet, color: Colors.black),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                SizedBox(height: 15),

                // Precio
                TextFormField(
                  controller: precioController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "El precio es requerido";
                    return null;
                  },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Precio Venta',
                    prefixIcon: Icon(Icons.attach_money, color: Colors.black),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                SizedBox(height: 15),

                // Costo
                TextFormField(
                  controller: costoController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "El costo es requerido";
                    return null;
                  },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Costo',
                    prefixIcon: Icon(Icons.money_off, color: Colors.black),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                SizedBox(height: 15),

                // Stock
                TextFormField(
                  controller: stockController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "El stock es requerido";
                    return null;
                  },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Stock',
                    prefixIcon: Icon(Icons.storage, color: Colors.black),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                SizedBox(height: 15),

                // Categoría
                DropdownButtonFormField<int>(
                  value: selectedCategoriaId,
                  items: categorias.map((cat) {
                    return DropdownMenuItem<int>(
                      value: cat.id,
                      child: Text(cat.nombre),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategoriaId = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Categoría',
                    prefixIcon: Icon(Icons.category, color: Colors.black),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  validator: (value) {
                    if (value == null) return 'Seleccione una categoría';
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Botones
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 70,
                        child: TextButton(
                          onPressed: () async {
                            if (formProducts.currentState!.validate()) {
                              final repo = ProductsRepository();
                              final products = ProductsModels(
                                codigo: codigoController.text,
                                nombre: nombreController.text,
                                descripcion: descripcionController.text,
                                precio: double.parse(precioController.text),
                                costo: double.parse(costoController.text),
                                stock: double.parse(stockController.text),
                                categoriaId: selectedCategoriaId,
                              );

                              if (esEditar) {
                                products.id = producto!.id;
                                await repo.edit(products);
                              } else {
                                await repo.create(products);
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Padding(
                                    padding:  EdgeInsets.all(8.0),
                                    child: Text('Registro exitoso'),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );

                              Future.delayed(Duration(milliseconds: 500), () {
                                Navigator.pop(context);
                              });
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save, color: Colors.white),
                              SizedBox(height: 8),
                              Text('Aceptar'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: SizedBox(
                        height: 70,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cancel, color: Colors.white),
                              SizedBox(height: 8),
                              Text('Cancelar'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
