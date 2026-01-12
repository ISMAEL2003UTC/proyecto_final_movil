import 'package:flutter/material.dart';

import '../../models/products_models.dart';
import '../../repositories/products_repository.dart';

class ProductoFormScreen extends StatefulWidget {
  const ProductoFormScreen({super.key});

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
  ProductsModels? producto;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //capturo
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      producto = args as ProductsModels;
      codigoController.text = producto!.codigo;
      nombreController.text = producto!.nombre;
      descripcionController.text = producto!.descripcion;
      precioController.text = producto!.precio.toString();
      costoController.text = producto!.costo.toString();
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
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formProducts,
          child: Column(
            children: [
              TextFormField(
                controller: codigoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El código es requerido";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Código',
                  hintText: 'Ingrese el código de la categoría',
                  prefixIcon: Icon(Icons.barcode_reader, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),
              TextFormField(
                controller: nombreController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El nombre es requerido";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Ingrese el nombre del producto',
                  prefixIcon: Icon(Icons.inventory_2, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),
              TextFormField(
                controller: descripcionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "La descripción es requerida";
                  }
                  return null;
                },
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Ingrese el nombre de la descripción',
                  prefixIcon: Icon(Icons.text_snippet, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: precioController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El precio es requerido";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Precio',
                  hintText: 'Ingrese el precio del producto',
                  prefixIcon: Icon(Icons.attach_money, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: costoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El costo es requerido";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Costo',
                  hintText: 'Ingrese el costo del producto',
                  prefixIcon: Icon(Icons.money_off, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 70,
                      child: TextButton(
                        onPressed: () async {
                          if (formProducts.currentState!.validate()) {
                            //almacenar datos
                            final repo = ProductsRepository();
                            final products = ProductsModels(
                              codigo: codigoController.text,
                              nombre: nombreController.text,
                              descripcion: descripcionController.text,
                              precio: double.parse(precioController.text),
                              costo: double.parse(costoController.text),
                            );

                            if (esEditar) {
                              products.id = producto!.id;
                              await repo.edit(products);
                            } else {
                              await repo.create(products);
                            }
                          }
                          //llama a insertar datos
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Registro exitoso'),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Future.delayed(Duration(microseconds: 500), () {
                            Navigator.pop(context);
                          });
                        },

                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(10),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save, color: Colors.white),
                            SizedBox(width: 8),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(10),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cancel, color: Colors.white),
                            SizedBox(width: 8),
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
    );
  }
}
