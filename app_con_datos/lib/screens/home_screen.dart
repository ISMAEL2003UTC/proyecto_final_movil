import 'package:flutter/material.dart';

import '../models/products_models.dart';
import '../models/sales_models.dart';
import '../repositories/products_repository.dart';
import '../repositories/sale_detail_repository.dart';
import '../repositories/sales_repository.dart';

class HomeScreen extends StatefulWidget {
   HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SaleRepository saleRepo = SaleRepository();
  double totalVentas = 0;
  double totalGanancias = 0;

  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarTotales();
  }

  Future<void> cargarTotales() async {
    setState(() => cargando = true);

    List<SaleModels> ventas = await saleRepo.getAll();
    double sumaVentas = 0;
    double sumaGanancias = 0;

    final detailRepo = SaleDetailRepository();
    final productsRepo = ProductsRepository();
    final productos = await productsRepo.getAll();

    for (var venta in ventas) {
      sumaVentas += venta.montoTotal;

      // Obtener detalles de la venta
      final detalles = await detailRepo.getByVenta(venta.id!);
      for (var detalle in detalles) {
        final producto = productos.firstWhere(
              (p) => p.id == detalle.productoId,
          orElse: () => ProductsModels(
            id: 0,
            nombre: 'Desconocido',
            precio: 0,
            costo: 0,
            codigo: '',
            descripcion: '',
            stock: 0,
          ),
        );
        sumaGanancias += (detalle.precioUnitario - producto.costo) * detalle.cantidad;
      }
    }

    setState(() {
      totalVentas = sumaVentas;
      totalGanancias = sumaGanancias;
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        elevation: 3,
        title: Row(
          children:  [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.blueAccent),
            ),
            SizedBox(width: 30),
            Text(
              'Mauricio Alexander',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),

      body: Padding(
        padding:  EdgeInsets.all(8.0),
        child: Column(
          children: [
             SizedBox(height: 10),
            Column(
              children: [
                // Fila 1
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:  [
                          Icon(Icons.shopping_cart, color: Colors.blueAccent),
                          SizedBox(height: 4),
                          Text(
                            'Compras',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 2),
                          Text('90 \$', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 60, color: Colors.grey),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                           Icon(Icons.attach_money, color: Colors.green),
                           SizedBox(height: 4),
                           Text(
                            'Ventas',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                           SizedBox(height: 2),
                          // Mostrar total de ventas actualizado
                          cargando
                              ?  CircularProgressIndicator()
                              : Text(
                            '${totalVentas.toStringAsFixed(2)} \$',
                            style:  TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(thickness: 1),
                // Fila 2
                // Fila 2: Ganancias y Gastos
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                           Icon(Icons.show_chart, color: Colors.orange),
                           SizedBox(height: 4),
                           Text(
                            'Ganancias',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                           SizedBox(height: 2),
                          cargando
                              ?  CircularProgressIndicator()
                              : Text(
                            '${totalGanancias.toStringAsFixed(2)} \$',
                            style:  TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),

// ---------------------------------------------------------------------------------------

                    Container(width: 1, height: 60, color: Colors.grey),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:  [
                          Icon(Icons.money_off, color: Colors.purple), // Gastos
                          SizedBox(height: 4),
                          Text(
                            'Gastos',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 2),
                          Text('2', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

            // FILA 1
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/categoria');
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Container(
                    width: 160,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 6,
                          offset:  Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Icon(Icons.apartment, color: Colors.white, size: 36),
                        SizedBox(height: 8),
                        Text(
                          'Categoría',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/producto');
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Container(
                    width: 160,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 6,
                          offset:  Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Icon(
                          Icons.production_quantity_limits,
                          color: Colors.white,
                          size: 36,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Productos',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

             SizedBox(height: 10),

            // FILA 2
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/cliente');
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Container(
                    width: 160,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 6,
                          offset:  Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Icon(Icons.people, color: Colors.white, size: 36),
                        SizedBox(height: 8),
                        Text(
                          'Clientes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/provider');
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Container(
                    width: 160,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 6,
                          offset:  Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Icon(
                          Icons.local_shipping,
                          color: Colors.white,
                          size: 36,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Proveedores',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

             SizedBox(height: 10),

            // FILA 3 - VENTAS Y GASTOS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/ventas');
                    await cargarTotales();
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Container(
                    width: 160,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 6,
                          offset:  Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Icon(
                          Icons.point_of_sale,
                          color: Colors.white,
                          size: 36,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Ventas',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/lista_gastos');
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Container(
                    width: 160,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 6,
                          offset:  Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 36,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Gastos',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

             SizedBox(height: 10),

            // FILA 4 - COMPRAS (NUEVA FILA)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Botón de Compras
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/compras');
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Container(
                    width: 160,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.teal, // Color diferente para distinguir
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 6,
                          offset:  Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Icon(
                          Icons.shopping_bag, // Icono diferente para compras
                          color: Colors.white,
                          size: 36,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Compras',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Puedes agregar otro botón aquí o dejar un espacio vacío
                Container(
                  width: 160,
                  height: 110,
                  // Color transparente para mantener el diseño
                ),
              ],
            ),
          ],
        ),
        ],
      ),
      ),
    );
  }
}