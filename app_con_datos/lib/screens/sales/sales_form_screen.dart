import 'package:flutter/material.dart';

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
              // Producto
              TextFormField(
                controller: productoController,
                validator: (value) => value == null || value.isEmpty
                    ? "Ingrese el producto"
                    : null,
                decoration: InputDecoration(
                  labelText: 'Producto',
                  hintText: 'Ingrese el nombre del producto',
                  prefixIcon: const Icon(
                    Icons.shopping_bag,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Cantidad
              TextFormField(
                controller: cantidadController,
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty
                    ? "Ingrese la cantidad"
                    : null,
                decoration: InputDecoration(
                  labelText: 'Cantidad',
                  hintText: 'Ingrese la cantidad',
                  prefixIcon: const Icon(
                    Icons.confirmation_number,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Precio
              TextFormField(
                controller: precioController,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? "Ingrese el precio" : null,
                decoration: InputDecoration(
                  labelText: 'Precio',
                  hintText: 'Ingrese el precio unitario',
                  prefixIcon: const Icon(
                    Icons.attach_money,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Cliente
              TextFormField(
                controller: clienteController,
                validator: (value) => value == null || value.isEmpty
                    ? "Ingrese el cliente"
                    : null,
                decoration: InputDecoration(
                  labelText: 'Cliente',
                  hintText: 'Ingrese el nombre del cliente',
                  prefixIcon: const Icon(Icons.person, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Botones Aceptar / Cancelar
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Venta registrada"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
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
