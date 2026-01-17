import 'package:flutter/material.dart';
import '../../models/products_models.dart';
import '../../models/sale_detail_models.dart';
import '../../repositories/products_repository.dart';

class VentasFormScreen extends StatefulWidget {
  const VentasFormScreen({super.key});

  @override
  State<VentasFormScreen> createState() => _VentasFormScreenState();
}

class _VentasFormScreenState extends State<VentasFormScreen> {
  final formKey = GlobalKey<FormState>();

  final productoController = TextEditingController();
  final cantidadController = TextEditingController();
  final precioController = TextEditingController();
  final clienteController = TextEditingController();

  final ProductsRepository productsRepo = ProductsRepository();

  List<ProductsModels> productos = [];
  ProductsModels? productoSeleccionado;

  @override
  void initState() {
    super.initState();
    cargarProductos();
  }

  Future<void> cargarProductos() async {
    productos = await productsRepo.getAll();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Venta"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              /// PRODUCTO (AUTOCOMPLETE)
              Autocomplete<ProductsModels>(
                optionsBuilder: (TextEditingValue value) {
                  if (value.text.isEmpty) {
                    return const Iterable<ProductsModels>.empty();
                  }
                  return productos.where(
                        (p) => p.nombre
                        .toLowerCase()
                        .contains(value.text.toLowerCase()),
                  );
                },
                displayStringForOption: (option) => option.nombre,
                onSelected: (selection) {
                  productoSeleccionado = selection;
                  productoController.text = selection.nombre;
                  precioController.text = selection.precio.toString();
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    validator: (_) => productoSeleccionado == null
                        ? 'Seleccione un producto'
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Producto',
                      prefixIcon: const Icon(Icons.shopping_bag),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 15),

              /// CANTIDAD
              TextFormField(
                controller: cantidadController,
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || value.isEmpty ? 'Ingrese cantidad' : null,
                decoration: InputDecoration(
                  labelText: 'Cantidad',
                  prefixIcon: const Icon(Icons.numbers),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              /// CLIENTE
              TextFormField(
                controller: clienteController,
                validator: (value) =>
                value == null || value.isEmpty ? "Ingrese el cliente" : null,
                decoration: InputDecoration(
                  labelText: 'Cliente',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// BOTONES ACEPTAR / CANCELAR
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: TextButton(
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;
                          if (productoSeleccionado == null) return;

                          final subtotal = productoSeleccionado!.precio *
                              int.parse(cantidadController.text);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Producto: ${productoSeleccionado!.nombre} - Total: \$${subtotal.toStringAsFixed(2)}"),
                              backgroundColor: Colors.green,
                            ),
                          );

                          // Aquí luego guardarás la venta y los detalles
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.save, color: Colors.white),
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
                      height: 60,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.cancel, color: Colors.white),
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
