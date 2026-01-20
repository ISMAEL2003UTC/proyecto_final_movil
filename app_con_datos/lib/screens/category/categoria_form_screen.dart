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
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();

  CategoryModels? categoria;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final route = ModalRoute.of(context);
    if (route != null && route.settings.arguments != null) {
      categoria = route.settings.arguments as CategoryModels;
      nombreController.text = categoria!.nombre;
      descripcionController.text = categoria!.descripcion;
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool esEditar = categoria != null;

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
                  prefixIcon: const Icon(Icons.category, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 15),
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
                  hintText: 'Ingrese la descripción',
                  prefixIcon:
                      const Icon(Icons.description, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 70,
                      child: TextButton(
                        onPressed: () async {
                          if (!formCategory.currentState!.validate()) return;

                          final repo = CategoryRepository();
                          final allCategories = await repo.getAll();

                          final bool nombreRepetido = allCategories.any(
                            (c) =>
                                c.nombre.toLowerCase() ==
                                    nombreController.text.toLowerCase() &&
                                c.id != (categoria?.id ?? 0),
                          );

                          if (nombreRepetido) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('La categoría ya existe'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          final category = CategoryModels(
                            nombre: nombreController.text,
                            descripcion: descripcionController.text,
                          );

                          if (categoria != null) {
                            category.id = categoria!.id;
                            await repo.edit(category);
                          } else {
                            await repo.create(category);
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                esEditar
                                    ? 'Actualización exitosa'
                                    : 'Registro exitoso',
                                textAlign: TextAlign.center,
                              ),
                              duration:
                                  const Duration(milliseconds: 500),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                            ),
                          );

                          await Future.delayed(
                              const Duration(milliseconds: 650));
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save),
                            SizedBox(height: 5),
                            Text('Aceptar'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: SizedBox(
                      height: 70,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cancel),
                            SizedBox(height: 5),
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
