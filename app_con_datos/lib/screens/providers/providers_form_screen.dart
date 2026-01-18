import 'package:flutter/material.dart';


import '../../models/providers_model.dart';
import '../../repositories/providers_repository.dart';
class ProvidersFormScreen extends StatefulWidget {
  const ProvidersFormScreen({super.key});

  @override
  State<ProvidersFormScreen> createState() => _ProvidersFormScreenState();
}

class _ProvidersFormScreenState extends State<ProvidersFormScreen> {
  final formProvider = GlobalKey<FormState>();
  final cedulapController = TextEditingController();
  final nombrepController = TextEditingController();
  final direccionpController = TextEditingController();
  final telefonopController = TextEditingController();
  final correopController = TextEditingController();
  ProvidersModel ? proveedor;

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    //capturo parametros desde la interfaz anterior
    final args = ModalRoute.of(context)!.settings.arguments;
    if(args != null){
      proveedor = args as ProvidersModel;
      cedulapController.text = proveedor!.cedulap;
      nombrepController.text = proveedor!.nombrep;
      direccionpController.text = proveedor!.direccionp;
      telefonopController.text = proveedor!.telefonop;
      correopController.text = proveedor!.correop;
    }
  }
  Widget build(BuildContext context) {
    final esEditar = proveedor != null;

    return Scaffold(
      appBar: AppBar(title: Text(esEditar?"Editar Proveedor":"Formulario de Proveedores"),),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key:formProvider ,
          child: Column(
            children: [
              TextFormField(
                controller:cedulapController ,//crl espacio
                validator: (value) {
                  if (value == null || value.isEmpty){
                    return "EL CAMPO ES REQUERIDO";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Cédula",
                  hintText: "Ingrese la cédula del proveedor",
                  prefixIcon:Icon(Icons.qr_code),
                 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: nombrepController,
                validator: (value){
                  if(value ==null || value.isEmpty){
                    return "EL CAMPO ES REQUERIDO";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Nombre",
                  hintText: "Ingrese el nombre del proveedor",
                  prefixIcon:Icon(Icons.title),
                
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: direccionpController,
                validator: (value){
                  if(value ==null || value.isEmpty){
                    return "EL CAMPO ES REQUERIDO";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Dirección",
                  hintText: "Ingrese la dirección del proveedor",
                  prefixIcon:Icon(Icons.location_on),
                
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: telefonopController,
                keyboardType: TextInputType.phone,
                validator: (value){
                  if(value ==null || value.isEmpty){
                    return "EL CAMPO ES REQUERIDO";
                  }
                  int? num = int.tryParse(value);
                  if (num == null) {
                    return "El teléfono debe ser numérico";
                  }
                  if (value.length != 10) {
                    return "El teléfono debe tener 10 dígitos";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Teléfono",
                  hintText: "Ingrese el teléfono del proveedor",
                  prefixIcon:Icon(Icons.phone),
                
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: correopController,
                keyboardType: TextInputType.emailAddress,
                validator: (value){
                  if(value ==null || value.isEmpty){
                    return "EL CAMPO ES REQUERIDO";
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return "Ingrese un correo electrónico válido";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Correo",
                  hintText: "Ingrese el correo del proveedor",
                  prefixIcon:Icon(Icons.email),
                
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              SizedBox(height: 50,),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      if(formProvider.currentState!.validate()){
                        //almacenar los datos 
                        final repo = ProvidersRepository();
                        final provider = ProvidersModel(
                          cedulap: cedulapController.text,
                          nombrep: nombrepController.text,
                          direccionp: direccionpController.text,
                          telefonop: telefonopController.text,
                          correop: correopController.text,
                        );
                        if(esEditar){
                          provider.id = proveedor!.id;
                          await repo.edit(provider);// llamamos a insertar datos
                        }else{
                          await repo.create(
                            provider,
                          );// llamamos a insertar datos
                        }
                        //await repo.create(category); //llamamos el método de los repositories/funcion asyncrona
                        Navigator.pop(context);//muestra la interfaz del listado
                      }
                    },
                    child: Text('Guardar'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      
                    ),
                  ),
                  SizedBox(width: 30,),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancelar'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      
                    ),
                  ),
                ],
              )//input caja de texto
            ],
          
          ),
        ),
      ),
      
    );

  }
}