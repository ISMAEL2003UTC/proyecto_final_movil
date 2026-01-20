import 'package:flutter/material.dart';
import '../../models/compra_models.dart';
import '../../repositories/compra_repository.dart';

class CompraScreen extends StatefulWidget {
  const CompraScreen({super.key});

  @override
  State<CompraScreen> createState() => _CompraScreenState();
}

class _CompraScreenState extends State<CompraScreen> {
  final CompraRepository repo = CompraRepository();
  List<CompraModels> compras = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarCompras();
  }

  Future<void> cargarCompras() async {
    setState(() => cargando = true);
    compras = await repo.getAll();
    setState(() => cargando = false);
  }

  void eliminarCompra(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar Compra"),
        content: const Text("¿Estás seguro de eliminar esta compra?"),
        actions: [
          TextButton(
            onPressed: () async {
              await repo.delete(id);
              Navigator.pop(context);
              cargarCompras();
            },
            child: const Text("Sí"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listado de Compras"),
        backgroundColor: Colors.blue[800],
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : compras.isEmpty
              ? const Center(child: Text("No existen datos"))
              : ListView.builder(
                  itemCount: compras.length,
                  itemBuilder: (context, i) {
                    final compra = compras[i];
                    
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.shopping_cart, color: Colors.blue[800]),
                        title: Text("Compra #${compra.id}"),
                        subtitle: Text("Total: S/. ${compra.montoTotal.toStringAsFixed(2)}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () async {
                                await Navigator.pushNamed(
                                  context,
                                  '/compra/form',
                                  arguments: compra,
                                );
                                cargarCompras();
                              },
                              icon: const Icon(Icons.edit, color: Colors.orange),
                            ),
                            IconButton(
                              onPressed: () => eliminarCompra(compra.id!),
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/compra/form');
          cargarCompras();
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue[800],
        shape: const CircleBorder(),
      ),
    );
  }
}