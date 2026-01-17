import 'package:flutter/material.dart';
import '../../models/products_models.dart';
import '../../models/sale_detail_models.dart';
import '../../models/sales_models.dart';
import '../../models/clients_models.dart';
import '../../repositories/products_repository.dart';
import '../../repositories/sale_detail_repository.dart';
import '../../repositories/sales_repository.dart';
import '../../repositories/clients_repository.dart';

class SalesScreen extends StatefulWidget {
   SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final SaleRepository saleRepo = SaleRepository();
  final ClientsRepository clientsRepo = ClientsRepository();

  List<SaleModels> ventas = [];
  List<ClientsModels> clientes = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarVentas();
  }
  Future<double> calcularGanancia(int ventaId) async {
    final detailRepo = SaleDetailRepository();
    final productsRepo = ProductsRepository();

    // Usamos tu método existente getByVenta
    List<SaleDetailModels> detalles = await detailRepo.getByVenta(ventaId);
    List<ProductsModels> productos = await productsRepo.getAll();

    double ganancia = 0;
    for (var detalle in detalles) {
      final producto = productos.firstWhere(
            (p) => p.id == detalle.productoId,
        orElse: () => ProductsModels(
          id: 0,
          nombre: 'Producto desconocido',
          precio: 0,
          costo: 0,
          codigo: '',
          descripcion: '',
          stock: 0,
        ),
      );
      ganancia += (detalle.precioUnitario - producto.costo) * detalle.cantidad;
    }

    return ganancia;
  }



  Future<void> cargarVentas() async {
    setState(() => cargando = true);

    clientes = await clientsRepo.getAll();
    ventas = await saleRepo.getAll();

    setState(() => cargando = false);
  }
  String formatFecha(String fecha) {
    final dt = DateTime.parse(fecha);
    // YYYY-MM-DD HH:MM
    final anio = dt.year.toString().padLeft(4, '0');
    final mes = dt.month.toString().padLeft(2, '0');
    final dia = dt.day.toString().padLeft(2, '0');
    final hora = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');

    return '$anio-$mes-$dia $hora:$min';
  }


  void eliminarVenta(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Eliminar Venta'),
        content: Text('¿Estás seguro de eliminar esta venta?'),
        actions: [
          TextButton(
            onPressed: () async {
              await saleRepo.delete(id);
              Navigator.pop(context);
              cargarVentas();
            },
            child: Text('Sí'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Ventas'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: cargando
          ? Center(child: CircularProgressIndicator())
          : ventas.isEmpty
          ? Center(child: Text('No existen ventas'))
          : Padding(
        padding:  EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: ventas.length,
          itemBuilder: (context, i) {
            final venta = ventas[i];
            final cliente = clientes.firstWhere(
                  (c) => c.id == venta.clienteId,
              orElse: () => ClientsModels(
                id: 0,
                cedula: '',
                nombre: 'Cliente desconocido',
                direccion: '',
                telefono: '',
                correo: '',
              ),
            );

            return Card(
              child: ListTile(
                title: Text(
                  '${cliente.nombre}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fecha: ${formatFecha(venta.fecha)}'),
                    Text('Total: \$${venta.montoTotal.toStringAsFixed(2)}'),
                    FutureBuilder<double>(
                      future: calcularGanancia(venta.id!),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return Text('Ganancia: ...');
                        return Text('Ganancia: \$${snapshot.data!.toStringAsFixed(2)}');
                      },
                    ),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () => eliminarVenta(venta.id!),
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              ),
            );

          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/ventas/form');
          cargarVentas();
        },
        child: Icon(Icons.add_circle_outline, color: Colors.white),
        backgroundColor: Colors.black,
        shape: CircleBorder(),
      ),
    );
  }
}
