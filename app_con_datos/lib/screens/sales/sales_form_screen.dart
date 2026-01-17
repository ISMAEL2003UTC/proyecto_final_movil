import 'package:flutter/material.dart';
import '../../models/clients_models.dart';
import '../../models/products_models.dart';
import '../../models/sale_detail_models.dart';
import '../../repositories/clients_repository.dart';
import '../../repositories/products_repository.dart';
import '../../repositories/sales_repository.dart';
import '../../repositories/sale_detail_repository.dart';
import '../../models/sales_models.dart';

class VentasFormScreen extends StatefulWidget {
   VentasFormScreen({super.key});
  @override
  State<VentasFormScreen> createState() => _VentasFormScreenState();
}

class _VentasFormScreenState extends State<VentasFormScreen> {
  final formKey = GlobalKey<FormState>();
  final productoController = TextEditingController();
  final cantidadController = TextEditingController();
  final precioController = TextEditingController();
  final clienteController = TextEditingController();
  Key autocompleteKey = UniqueKey();
  final ProductsRepository productsRepo = ProductsRepository();
  List<ProductsModels> productos = [];
  ProductsModels? productoSeleccionado;
  final ClientsRepository clientsRepo = ClientsRepository();
  List<ClientsModels> clientes = [];
  ClientsModels? clienteSeleccionado;
  Key autocompleteClienteKey = UniqueKey();
  List<SaleDetailModels> carrito = [];
  @override
  void initState() {
    super.initState();
    cargarProductos();
    cargarClientes();

  }

  Future<void> cargarProductos() async {
    productos = await productsRepo.getAll();
    setState(() {});
  }
  Future<void> cargarClientes() async {
    clientes = await clientsRepo.getAll();
    setState(() {});
  }
  void agregarAlCarrito() {
    if (productoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text('Seleccione un producto'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (cantidadController.text.isEmpty || int.tryParse(cantidadController.text) == null || int.parse(cantidadController.text) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text('Ingrese una cantidad válida'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (precioController.text.isEmpty || double.tryParse(precioController.text) == null || double.parse(precioController.text) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text('Ingrese un precio válido'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final cantidad = int.parse(cantidadController.text);
    final subtotal = productoSeleccionado!.precio * cantidad;

    final detalle = SaleDetailModels(
      ventaId: 0,
      productoId: productoSeleccionado!.id!,
      cantidad: cantidad,
      precioUnitario: productoSeleccionado!.precio,
      subtotal: subtotal,
    );

    setState(() {
      carrito.add(detalle);
      cantidadController.clear();
      precioController.clear();
      productoSeleccionado = null;
      autocompleteKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Nueva Venta"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding:  EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                   SizedBox(height: 15),
                  Autocomplete<ClientsModels>(
                    key: autocompleteClienteKey,
                    optionsBuilder: (TextEditingValue value) {
                      if (value.text.isEmpty) return  Iterable<ClientsModels>.empty();
                      return clientes.where((c) =>
                          c.nombre.toLowerCase().contains(value.text.toLowerCase()));
                    },
                    displayStringForOption: (option) => option.nombre,
                    onSelected: (selection) {
                      clienteSeleccionado = selection;
                      clienteController.text = selection.nombre;
                    },
                    fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                      return TextFormField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: 'Cliente',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (_) =>
                        clienteSeleccionado == null ? 'Seleccione un cliente' : null,
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Autocomplete<ProductsModels>(
                              key: autocompleteKey,
                              optionsBuilder: (TextEditingValue value) {
                                if (value.text.isEmpty) return  Iterable<ProductsModels>.empty();
                                return productos.where((p) =>
                                    p.nombre.toLowerCase().contains(value.text.toLowerCase()));
                              },
                              displayStringForOption: (option) => option.nombre,
                              onSelected: (selection) {
                                productoSeleccionado = selection;
                                cantidadController.text = '1';
                                precioController.text = selection.precio.toStringAsFixed(2);
                              },
                              fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                                return TextFormField(
                                  controller: textEditingController,
                                  focusNode: focusNode,
                                  decoration: InputDecoration(
                                    labelText: 'Producto',
                                    prefixIcon:  Icon(Icons.shopping_bag),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),

                                    ),
                                  ),
                                );
                              },
                            ),
                             SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: cantidadController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Cantidad',
                                      prefixIcon:  Icon(Icons.numbers),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                ),
                                 SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: precioController,
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                    decoration: InputDecoration(
                                      labelText: 'Precio',
                                      prefixIcon:  Icon(Icons.monetization_on_outlined),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                       SizedBox(width: 15),
                      SizedBox(
                        height: 120,
                        child: TextButton(
                          onPressed: agregarAlCarrito,
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:  [
                              Icon(Icons.add_circle_outline_outlined, color: Colors.white,size: 40,),
                              SizedBox(height: 5),
                              Text('Agregar'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                   SizedBox(height: 20),
                ],
              ),
            ),
            Expanded(
              child: carrito.isEmpty
                  ?  Center(child: Text('No hay productos agregados'))
                  : ListView.builder(
                itemCount: carrito.length,
                itemBuilder: (context, index) {
                  final item = carrito[index];
                  final producto = productos.firstWhere(
                        (p) => p.id == item.productoId,
                    orElse: () => ProductsModels(
                      id: 0,
                      nombre: 'Producto desconocido',
                      precio: 0,
                      codigo: '',
                      costo: 0,
                      descripcion: '',
                      stock: 0,
                    ),
                  );

                  return ListTile(
                    title: Text(producto.nombre),
                    subtitle: Text(
                      '${item.cantidad} x \$${item.precioUnitario.toStringAsFixed(2)} = \$${item.subtotal.toStringAsFixed(2)}',
                    ),
                    trailing: IconButton(
                      icon:  Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          carrito.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            Container(
              padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${carrito.fold<double>(0, (sum, item) => sum + item.subtotal).toStringAsFixed(2)}',
                    style:  TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () async {
                  if (clienteSeleccionado == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Seleccione un cliente'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (carrito.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('El carrito está vacío'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  // Crear venta
                  final total = carrito.fold<double>(0, (sum, item) => sum + item.subtotal);
                  final sale = SaleModels(
                    clienteId: clienteSeleccionado!.id!,
                    fecha: DateTime.now().toIso8601String(),
                    montoTotal: total,
                  );

                  final saleRepo = SaleRepository();
                  final ventaId = await saleRepo.create(sale);

                  final detailRepo = SaleDetailRepository();
                  for (var item in carrito) {
                    final detalle = SaleDetailModels(
                      ventaId: ventaId,
                      productoId: item.productoId,
                      cantidad: item.cantidad,
                      precioUnitario: item.precioUnitario,
                      subtotal: item.subtotal,
                    );
                    await detailRepo.create(detalle);
                  }
                  setState(() {
                    carrito.clear();
                    clienteController.clear();
                    productoController.clear();
                    cantidadController.clear();
                    precioController.clear();
                    clienteSeleccionado = null;
                    productoSeleccionado = null;
                    autocompleteKey = UniqueKey();
                    autocompleteClienteKey = UniqueKey();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Venta registrada. Total: \$${total.toStringAsFixed(2)}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Future.delayed(Duration(milliseconds: 500), () {
                    Navigator.pop(context);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                child:  Text(
                  'Finalizar Venta',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
