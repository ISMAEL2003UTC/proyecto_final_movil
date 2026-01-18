import 'package:app_con_datos/models/category_models.dart';
import 'package:flutter/material.dart';

import '../../repositories/category_repository.dart';

class CategoryFormScreen extends StatefulWidget {
  const CategoryFormScreen({super.key});

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final formCategory = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  CategoryModels? categoria;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //capturo
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      categoria = args as CategoryModels;
      nombreController.text = categoria!.nombre;
      descripcionController.text = categoria!.descripcion;
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = categoria != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? "Editar Categoría" : "Agregar Categoría"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formCategory,
          child: Column(
            children: [
              TextFormField(
                controller: nombreController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El nombre es requerido";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Categoría',
                  hintText: 'Ingrese el nombre de la categoría',
                  prefixIcon: Icon(Icons.category, color: Colors.black),
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
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Ingrese el nombre de la descripción',
                  prefixIcon: Icon(Icons.description, color: Colors.black),
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
                          if (formCategory.currentState!.validate()) {
                            //almacenar datos
                            final repo = CategoryRepository();
                            final category = CategoryModels(
                              nombre: nombreController.text,
                              descripcion: descripcionController.text,
                            );
                            if (esEditar) {
                              category.id = categoria!.id;
                              await repo.edit(category);
                            } else {
                              await repo.create(category);
                            }


                          //await repo.create(category);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Registro exitoso'),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                            Navigator.pop(context);
                          }
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
