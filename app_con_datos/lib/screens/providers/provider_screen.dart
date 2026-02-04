import 'package:flutter/material.dart';

import '../../models/providers_model.dart';
import '../../repositories/providers_repository.dart';




class ProviderScreen extends StatefulWidget {
  const ProviderScreen({super.key});

  @override
  State<ProviderScreen> createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen> {

  final ProvidersRepository repo = ProvidersRepository();

  List<ProvidersModel> providers =[];
  bool cargando = true;
  @override
  void initState(){
    super.initState();
    cargarProviders();
  }
  Future<void> cargarProviders()async{
    setState(()=>cargando=true);
    providers = await repo.getAll(); //consultar el listado
    setState(()=>cargando=false);
  }
  void eliminarProviders(int id){
    //aqui va la lógica del modal 
    showDialog(
      context:context,
      builder: (_) => AlertDialog(
      title: Text("Eliminar Proveedor"),
      content: Text("¿Estás seguro de que deseas eliminar este registro?"),
      actions: [
        TextButton(
          onPressed: () async {
            await repo.delete(id);
            Navigator.pop(context);
            cargarProviders();
          },
          child: Text("Sí"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("No"),
        ),
      ],
    )

    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Listado de Proveedores"),
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,),
      body: cargando ? Center(child: CircularProgressIndicator(),):
        providers.isEmpty ? Center(child: Text("No existen datos"),):
        ListView.builder(
          itemCount: providers.length,
          itemBuilder: (context,i){
            final cat = providers[i];
            return Card(
            child: ListTile(
              title: Text("${cat.id} "),   // ID y nombre juntos
              
              subtitle: Column(
                
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Cédula: ${cat.cedulap}"),
                  Text("Nombre: ${cat.nombrep}"),
                  Text("Dirección: ${cat.direccionp ?? ''}"),
                  Text("Teléfono: ${cat.telefonop}"),
                  Text("Correo: ${cat.correop }"),
                  
                ],
                
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: ()async{
                    await Navigator.pushNamed(
                      context,
                      '/provider/form',
                      arguments: cat,
                    );
                    await cargarProviders();
                  }, 
                  icon: Icon(Icons.edit,color:Colors.amber),),
                  IconButton(
                    onPressed: () => eliminarProviders(cat.id!),
                    icon: Icon(Icons.delete,color:Colors.red),
                  ),
                ],
                
              ),
            ),
          );

          },

        ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async {
         await Navigator.pushNamed(context, '/provider/form');
          cargarProviders();
        },
        child: Icon(Icons.add_circle_outlined,color: Colors.white,),
        backgroundColor: Colors.black,
        shape: CircleBorder(),
      ),
    );
  }
}
