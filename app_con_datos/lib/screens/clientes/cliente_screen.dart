import 'package:flutter/material.dart';

import '../../models/clients_models.dart';
import '../../repositories/clients_repository.dart';

class ClienteScreen extends StatefulWidget {
   ClienteScreen({super.key});

  @override
  State<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  final ClientsRepository repo = ClientsRepository();
  List<ClientsModels> clientes = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarClientes();
  }

  Future<void> cargarClientes() async {
    setState(() => cargando = true);
    {
      clientes = await repo.getAll();
      setState(() => cargando = false);
    }
    ;
  }

  void eliminarCliente(int id) async {
    // Verifico si el cliente tiene ventas
    final ventasRelacionadas = await repo.getSalesByClientId(id);

    if (ventasRelacionadas.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'No se puede eliminar el cliente. Tiene ventas registradas.',
            textAlign: TextAlign.center,
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar Cliente'),
        content: const Text('¿Estás seguro que deseas eliminar este cliente?'),
        actions: [
          TextButton(
            onPressed: () async {
              await repo.delete(id);
              Navigator.pop(context);
              await cargarClientes();
              // SnackBar de éxito
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Cliente eliminado',
                    textAlign: TextAlign.center,
                  ),
                  duration: const Duration(milliseconds: 800),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: const Text('Sí'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Clientes'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: cargando
          ? Center(child: CircularProgressIndicator())
          : clientes.isEmpty
          ? Center(child: Text('No existen clientes'))
          : Padding(
              padding:  EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: clientes.length,
                itemBuilder: (context, i) {
                  final cli = clientes[i];
                  return Card(
                    child: ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.person, size: 16,fontWeight: FontWeight.bold),
                          SizedBox(width: 5),
                          Text("${cli.nombre}"),
                        ],
                      ),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                      Row(
                      children: [
                      Icon(Icons.badge, size: 16),
                      SizedBox(width: 5),
                      Text("${cli.cedula}"),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.home, size: 16),
                        SizedBox(width: 5),
                        Text("${cli.direccion}"),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 16),
                        SizedBox(width: 5),
                        Text("${cli.telefono}"),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.email, size: 16),
                        SizedBox(width: 5),
                        Text("${cli.correo}"),
                      ],
                    ),
                      ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              await Navigator.pushNamed(
                                context,
                                '/cliente/form',
                                arguments: cli,
                              );
                              cargarClientes();
                            },
                            icon: Icon(Icons.edit, color: Colors.orange),
                          ),
                          IconButton(
                            onPressed: () => eliminarCliente(cli.id as int),
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/cliente/form');
          cargarClientes();
        },
        child: Icon(Icons.add_circle_outline, color: Colors.white),
        backgroundColor: Colors.black,
        shape: CircleBorder(),
      ),
    );
  }
}
