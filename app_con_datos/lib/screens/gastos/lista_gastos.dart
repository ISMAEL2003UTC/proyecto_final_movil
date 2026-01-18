import 'package:flutter/material.dart';

import '../../models/gastos_model.dart';
import '../../repositories/gastos_repository.dart';

class GastoScreen extends StatefulWidget {
  const GastoScreen({super.key});

  @override
  State<GastoScreen> createState() => _GastoScreenState();
}

class _GastoScreenState extends State<GastoScreen> {
  final GastosRepository repo = GastosRepository();
  List<GastosModel> gastos = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarGastos();
  }

  Future<void> cargarGastos() async {
    setState(() => cargando = true);
    {
      gastos = await repo.getAll();
      setState(() => cargando = false);
    }
    ;
  }


  void eliminarGasto(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Eliminar Gasto'),
        content: Text('Estas seguro que deseas eliminar este Gasto?'),
        actions: [
          TextButton(
            onPressed: () async {
              await repo.delete(id);
              Navigator.pop(context);
              cargarGastos();
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
        title: Text('Listado de Gastos'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: cargando
          ? Center(child: CircularProgressIndicator())
          : gastos.isEmpty
              ? Center(child: Text('No existen gastos'))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: gastos.length,
                    itemBuilder: (context, i) {
                      final gasto = gastos[i];
                      return Card(
                        child: ListTile(
                          title: Row(
                            children: [
                              Icon(Icons.attach_money),
                              SizedBox(width: 5),
                              Text(
                                gasto.nombre,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Descripción: ${gasto.descripcion}"),
                              Text("Monto: ${gasto.monto.toString()}"),
                              Text("Fecha: ${gasto.fecha}"),
                              Text("Tipo: ${gasto.tipo}"),
                            ],
                          ),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  await Navigator.pushNamed(
                                    context,
                                    '/gastos/form',
                                    arguments: gasto,
                                  );
                                  cargarGastos();
                                },
                                icon: Icon(Icons.edit, color: Colors.orange),
                              ),
                              IconButton(
                                onPressed: () =>
                                    eliminarGasto(gasto.id as int),
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
          await Navigator.pushNamed(context, '/gastos/form');
          cargarGastos();
        },
        child: Icon(Icons.add_circle_outline, color: Colors.white),
        backgroundColor: Colors.black,
        shape: CircleBorder(),
      ),
    );
  }
}
