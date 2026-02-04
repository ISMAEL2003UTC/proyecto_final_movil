import 'package:flutter/material.dart';
import '../../models/compra_models.dart';
import '../../models/products_models.dart';
import '../../repositories/compra_repository.dart';
//importamos el repository del producto relacionado para que pueda ser servido y no de errores
import '../../repositories/products_repository.dart';

class CompraFormScreen extends StatefulWidget {
  const CompraFormScreen({super.key});

  @override
  State<CompraFormScreen> createState() => _CompraFormScreenState();
}

class _CompraFormScreenState extends State<CompraFormScreen> {
  final formCompra = GlobalKey<FormState>();
  final fechaController = TextEditingController();
  final cantidadController = TextEditingController();
  final precioCostoController = TextEditingController();
  final montoTotalController = TextEditingController();

  CompraModels? compra;
  ProductsModels? productoSeleccionado; //se utiliza para que el usuario seleccione en el dropdown
  List<ProductsModels> productos = []; // esta es la lista que alimenta al drop down
  bool cargandoProductos = true;
  bool _compraCargada = false; //evita cargar datos dos veces

//cuando se abre la pantalla este componente pone fecha actual y carga los productos
  @override
  void initState() {
    super.initState();
    fechaController.text = _getFechaActual();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      await cargarProductos();
    } catch (e) {
      // Si ocurre un error al cargar, simplemente mostrar lista vacía
      setState(() {
        cargandoProductos = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (!_compraCargada) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null) {
        compra = args as CompraModels;
        fechaController.text = compra!.fecha;
        cantidadController.text = compra!.cantidad.toString();
        precioCostoController.text = compra!.precioCosto.toStringAsFixed(2);
        montoTotalController.text = compra!.montoTotal.toStringAsFixed(2);
        _compraCargada = true;
      }
    }
  }

//este tramo optiene la fecha actual
  String _getFechaActual() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

//esta es la funcion que consulta los productos y los carga (productos es relacionado)
  Future< void> cargarProductos() async {
    try {
      if (mounted) setState(() => cargandoProductos = true);
      
      final productoRepo = ProductsRepository();
      final lista = await productoRepo.getAll();
      
      if (mounted) {
        setState(() {
          productos = lista;
          cargandoProductos = false;
        });
        
        if (compra != null) {
          _seleccionarProductoPorId(compra!.productoId);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          cargandoProductos = false;
        });
      }
    }
  }
// esto hace que al editar el drop down muestre el producto correcto
  void _seleccionarProductoPorId(int productoId) {
    try {
      ProductsModels? productoEncontrado;
      for (var p in productos) {
        if (p.id == productoId) {
          productoEncontrado = p;
          break;
        }
      }
      
      if (productoEncontrado != null) {
        if (mounted) {
          setState(() {
            productoSeleccionado = productoEncontrado;
          });
        }
        
        if (compra == null && precioCostoController.text.isEmpty) {
          precioCostoController.text = productoEncontrado.costo.toStringAsFixed(2);
          calcularMontoTotal();
        }
      }
      //esto nos sirve para capturar errores al cargar los productos
    } catch (e) {
      print("Error en _seleccionarProductoPorId: $e");
    }
  }
// esta funcion me permite calcular el monto total al seleccionar un producto
  void calcularMontoTotal() {
    try {
      if (cantidadController.text.isNotEmpty && precioCostoController.text.isNotEmpty) {
        final cantidad = int.tryParse(cantidadController.text) ?? 0;
        final precioCosto = double.tryParse(precioCostoController.text) ?? 0;
        final montoTotal = cantidad * precioCosto;
        montoTotalController.text = montoTotal.toStringAsFixed(2);
      }
    } catch (e) {
      print("Error en calcularMontoTotal: $e");
    }
  }
// aqui es donde se actualiza el stock pero una ves una ves creado la compra
  Future<bool> _actualizarStockProducto() async {
    try {
      if (productoSeleccionado != null && compra == null) {
        final productoRepo = ProductsRepository();
        final cantidadComprada = int.tryParse(cantidadController.text) ?? 0;
        
        if (cantidadComprada <= 0) {
          throw Exception("Cantidad inválida: $cantidadComprada");
        }
        
        final nuevoStock = productoSeleccionado!.stock + cantidadComprada;
        // aqui es donde interactua con la base de datos y modifca el stock del producti
        final resultado = await productoRepo.updateStock(
          productoSeleccionado!.id!,
          nuevoStock,
        );
        
        return resultado > 0;
      }
      return true;
      //analizador de errores y los evita
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al actualizar stock: ${e.toString()}"),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = compra != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? "Formulario de Compra" : "Insertar Compra"),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formCompra,
          child: Column(
            children: [
              // Campo de Fecha
              TextFormField(
                controller: fechaController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La fecha es requerida';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Fecha de Compra",
                  hintText: "YYYY-MM-DD",
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onTap: () async {
                  final fecha = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (fecha != null) {
                    fechaController.text =
                        "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";
                  }
                },
              ),
              const SizedBox(height: 15),

              // Selector de Producto
              if (cargandoProductos)
                const CircularProgressIndicator()
              else if (productos.isEmpty)

              //esta card muestra cuando no existe datos de productos
                Card(
                  color: Colors.orange[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.warning, color: Colors.orange, size: 40),
                        const SizedBox(height: 10),
                        const Text(
                          "No hay productos disponibles",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Debe registrar productos primero",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/producto/form')
                                .then((_) => cargarProductos());
                          },
                          icon: const Icon(Icons.add),
                          label: const Text("Ir a Registrar Producto"),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                FutureBuilder(
                  future: Future.value(productos),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }

                    final productos = snapshot.data as List<ProductsModels>;
                   //dropdown que se muestra los productos
                    return DropdownButtonFormField<ProductsModels>(
                      value: productoSeleccionado,
                      validator: (value) {
                        if (value == null) {
                          return "Seleccione un producto";
                        }
                        return null;
                      },
                      items: productos.map((producto) {
                        return DropdownMenuItem<ProductsModels>(
                          value: producto,
                          child: Text(producto.nombre),
                        );
                      }).toList(),
                      onChanged: (ProductsModels? value) {
                        setState(() {
                          productoSeleccionado = value;
                          if (value != null && !esEditar) {
                            precioCostoController.text = value.costo.toStringAsFixed(2);
                            calcularMontoTotal();
                          }
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Producto",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        prefixIcon: const Icon(Icons.shopping_cart),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 15),

              // Campos de Cantidad
              TextFormField(
                controller: cantidadController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La cantidad es requerida';
                  }//valida que la cantidad no sea 0
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Cantidad inválida';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Cantidad",
                  hintText: "Ingrese la cantidad",
                  prefixIcon: const Icon(Icons.numbers),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onChanged: (_) => calcularMontoTotal(),
              ),
              const SizedBox(height: 15),

              // Campo de Precio Costo
              TextFormField(
                controller: precioCostoController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El precio es requerido';
                  }//valida que el precio no sea 0
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Precio inválido';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Precio Costo",
                  hintText: "Ingrese el precio costo",
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onChanged: (_) => calcularMontoTotal(),
              ),
              const SizedBox(height: 15),

              // Campo de Monto Total (solo lectura) aqui se va sumando la cantodad que se va sumando
              TextFormField(
                controller: montoTotalController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Monto Total",
                  hintText: "Monto total calculado",
                  prefixIcon: const Icon(Icons.calculate),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        if (formCompra.currentState!.validate() && productoSeleccionado != null) {
                          try {
                            final repo = CompraRepository();
                            //aqui se guarda la nueva compra
                            final nuevaCompra = CompraModels(
                              productoId: productoSeleccionado!.id!,
                              cantidad: int.parse(cantidadController.text),
                              precioCosto: double.parse(precioCostoController.text),
                              montoTotal: double.parse(montoTotalController.text),
                              fecha: fechaController.text,
                            );

                            if (esEditar) {
                              nuevaCompra.id = compra!.id;
                              await repo.edit(nuevaCompra);
                            } else {
                              await repo.create(nuevaCompra);
                              
                              final stockActualizado = await _actualizarStockProducto();
                              if (!stockActualizado) {
                                print("Advertencia: Stock no actualizado correctamente");
                              }
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  esEditar
                                      ? "¡Compra actualizada exitosamente!"
                                      : "¡Compra registrada exitosamente!",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );

                            Navigator.pop(context);
                            
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                             //aqui se definen los mensajes de error
                              SnackBar(
                                content: Text("Error al guardar: ${e.toString()}"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } else if (productoSeleccionado == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Debe seleccionar un producto"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: const Text("Aceptar"),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancelar"),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
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