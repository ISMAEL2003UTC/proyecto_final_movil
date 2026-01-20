import 'package:flutter/material.dart';
import '../../models/clients_models.dart';
import '../../models/products_models.dart';
import '../../models/sale_detail_models.dart';
import '../../repositories/clients_repository.dart';
import '../../repositories/products_repository.dart';
import '../../repositories/sales_repository.dart';
import '../../repositories/sale_detail_repository.dart';
import '../../models/sales_models.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'barcode_scanner.dart';
import 'package:flutter/services.dart';

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
  Key autocompleteClienteKey = UniqueKey();

  final ProductsRepository productsRepo = ProductsRepository();
  List<ProductsModels> productos = [];
  ProductsModels? productoSeleccionado;

  final ClientsRepository clientsRepo = ClientsRepository();
  List<ClientsModels> clientes = [];
  ClientsModels? clienteSeleccionado;

  List<SaleDetailModels> carrito = [];
  final externalBarcodeController = TextEditingController();
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarProductos();
    cargarClientes();
  }

  Future<void> cargarProductos() async {
    setState(() => cargando = true);
    productos = await productsRepo.getAll();
    setState(() => cargando = false);
  }

  Future<void> cargarClientes() async {
    setState(() => cargando = true);
    clientes = await clientsRepo.getAll();
    setState(() => cargando = false);
  }

  void abrirScanner() async {
    final controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );

    bool flashOn = false;

    final codigo = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return BarcodeScanner(
              isFlashOn: flashOn,
              onFlashToggle: () async {
                await controller.toggleTorch();
                setModalState(() {
                  flashOn = !flashOn;
                });
              },
              scannerWidget: MobileScanner(
                controller: controller,
                onDetect: (capture) {
                  final barcode = capture.barcodes.first;
                  final value = barcode.rawValue;
                  if (value != null) {
                    Navigator.pop(context, value);
                  }
                },
              ),
            );
          },
        );
      },
    );
    controller.dispose();
    if (codigo != null) {
      buscarProductoPorCodigo(codigo);
    }
  }

  void buscarProductoPorCodigo(String codigo) {
    try {
      final producto = productos.firstWhere((p) => p.codigo == codigo);

      final index = carrito.indexWhere((item) => item.productoId == producto.id);

      setState(() {
        if (index >= 0) {
          carrito[index].cantidad += 1;
          carrito[index].subtotal = carrito[index].cantidad * carrito[index].precioUnitario;
        } else {
          carrito.add(
            SaleDetailModels(
              ventaId: 0,
              productoId: producto.id!,
              cantidad: 1,
              precioUnitario: producto.precio,
              subtotal: producto.precio,
            ),
          );
        }
        productoSeleccionado = null;
        productoController.clear();
        cantidadController.clear();
        precioController.clear();
        autocompleteKey = UniqueKey();
      });


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${producto.nombre} agregado', textAlign: TextAlign.center),
          duration: Duration(milliseconds: 1000),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Producto no encontrado', textAlign: TextAlign.center),
          duration: Duration(milliseconds: 1000),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );

    }
  }

  void agregarAlCarrito() {
    if (productoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Seleccione un producto', textAlign: TextAlign.center),
          duration: Duration(milliseconds: 1000),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
      return;
    }

    final cantidad = int.tryParse(cantidadController.text) ?? 1;
    final precio = double.tryParse(precioController.text) ?? productoSeleccionado!.precio;

    final index = carrito.indexWhere((item) => item.productoId == productoSeleccionado!.id);

    setState(() {
      if (index >= 0) {
        carrito[index].cantidad += cantidad;
        carrito[index].subtotal = carrito[index].cantidad * carrito[index].precioUnitario;
      } else {
        carrito.add(
          SaleDetailModels(
            ventaId: 0,
            productoId: productoSeleccionado!.id!,
            cantidad: cantidad,
            precioUnitario: precio,
            subtotal: cantidad * precio,
          ),
        );
      }

      productoSeleccionado = null;
      productoController.clear();
      cantidadController.clear();
      precioController.clear();
      autocompleteKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.enter) {
            final codigo = externalBarcodeController.text.trim();
            if (codigo.isNotEmpty) {
              buscarProductoPorCodigo(codigo);
              externalBarcodeController.clear();
            }
          } else if (event.character != null && event.character!.isNotEmpty) {
            externalBarcodeController.text += event.character!;
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Nueva Venta"),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
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
                        if (value.text.isEmpty) return Iterable<ClientsModels>.empty();
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                            Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: const [
                                  Icon(
                                    Icons.point_of_sale,
                                    color: Colors.blueAccent,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Productos',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {

                                        },
                                        icon: Icon(Icons.barcode_reader),
                                        color: Colors.blueAccent,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.camera_alt),
                                        color: Colors.blueAccent,
                                        onPressed: abrirScanner,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Autocomplete<ProductsModels>(
                                key: autocompleteKey,
                                optionsBuilder: (TextEditingValue value) {
                                  if (value.text.isEmpty) return Iterable<ProductsModels>.empty();
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
                                      prefixIcon: Icon(Icons.shopping_bag),
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
                                        prefixIcon: Icon(Icons.numbers),
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
                                        prefixIcon: Icon(Icons.monetization_on_outlined),
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
                              children: [
                                Icon(Icons.add_circle_outline_outlined, color: Colors.white, size: 40),
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
                    ? Center(child: Text('No hay productos agregados'))
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
                        icon: Icon(Icons.delete, color: Colors.red),
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
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${carrito.fold<double>(0, (sum, item) => sum + item.subtotal).toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                          content: Text('Seleccione un cliente', textAlign: TextAlign.center),
                          duration: Duration(milliseconds: 1000),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      );
                      return;
                    }
                    if (carrito.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('No hay productos agregados !', textAlign: TextAlign.center),
                          duration: Duration(milliseconds: 1000),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      );
                      return;
                    }
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
                        duration: Duration(milliseconds: 500),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    );
                    Future.delayed(Duration(milliseconds: 650), () {
                      Navigator.pop(context);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: Text(
                    'Finalizar Venta',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

