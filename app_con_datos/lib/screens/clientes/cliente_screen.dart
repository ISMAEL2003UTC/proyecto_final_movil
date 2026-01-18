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

  void eliminarCliente(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Eliminar Cliente'),
        content: Text('Estas seguro que deseas eliminar este Cliente?'),
        actions: [
          TextButton(
            onPressed: () async {
              await repo.delete(id);
              Navigator.pop(context);
              cargarClientes();
            },
            child: Text('Si'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
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
                      Icon(Icons.badge, size: 16), // para Cédula
                      SizedBox(width: 5),
                      Text("${cli.cedula}"),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.home, size: 16), // para Dirección
                        SizedBox(width: 5),
                        Text("${cli.direccion}"),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 16), // para Teléfono
                        SizedBox(width: 5),
                        Text("${cli.telefono}"),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.email, size: 16), // para Correo
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
