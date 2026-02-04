import 'package:flutter/material.dart';

import '../../models/clients_models.dart';
import '../../repositories/clients_repository.dart';

class ClienteFormScreen extends StatefulWidget {
   ClienteFormScreen({super.key});
  @override
  State<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
  final formClients = GlobalKey<FormState>();
  final cedulaController = TextEditingController();
  final nombreController = TextEditingController();
  final direccionController = TextEditingController();
  final telefonoController = TextEditingController();
  final correoController = TextEditingController();
  ClientsModels? cliente;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //capturo
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      cliente = args as ClientsModels;
      cedulaController.text = cliente!.cedula;
      nombreController.text = cliente!.nombre;
      direccionController.text = cliente!.direccion;
      telefonoController.text = cliente!.telefono;
      correoController.text = cliente!.correo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = cliente != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? "Editar Cliente" : "Agregar Cliente"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding:  EdgeInsets.all(20),
        child: Form(
          key: formClients,
          child: Column(
            children: [
              //son los numeritos de validacion de los campos que controla
              TextFormField(
                controller: cedulaController, //validador de cedula
                keyboardType: TextInputType.number,
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "La cédula es requerida";
                  }
                  if (value.length != 10) {
                    return "La cédula debe tener 10 dígitos";
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return "La cédula solo debe contener números";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Cédula',
                  hintText: 'Ingrese la cédula',
                  prefixIcon: Icon(Icons.badge_outlined, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 15),

              TextFormField(
                controller: nombreController,
                keyboardType: TextInputType.text,
                maxLength: 50,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El nombre es requerido";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Ingrese el nombre',
                  prefixIcon: Icon(Icons.person_outline, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 15),

              TextFormField(
                controller: direccionController,
                keyboardType: TextInputType.text,
                maxLength: 15, // delimitador numerito pequenio que sale por interfaz
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "La dirección es requerido";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Dirección',
                  hintText: 'Ingrese la dirección',
                  prefixIcon: Icon(
                    Icons.location_on_outlined,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),
              TextFormField(
                controller: telefonoController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El teléfono es requerido";
                  }
                  if (value.length != 10) {
                    return "El teléfono debe tener 10 dígitos";
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return "El teléfono solo debe contener números";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  hintText: 'Ingrese el teléfono',
                  prefixIcon: Icon(Icons.phone_outlined, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: correoController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El correo es requerido";
                  }
                  //validador para correo electronico
                  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                  if (!emailRegex.hasMatch(value)) {
                    return "Ingrese un correo válido";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Correo',
                  hintText: 'Ingrese el correo',
                  prefixIcon: Icon(Icons.email_outlined, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 70,
                      child: TextButton(
                        onPressed: () async {
                          if (formClients.currentState!.validate()) {
                            final repo = ClientsRepository();
                            // Traigo todos los clientes
                            final allClients = await repo.getAll();
                            // Verifico si la cedula ya existe y si no emito mensaje 
                            bool cedulaRepetida = allClients.any(
                                    (c) => c.cedula == cedulaController.text && c.id != (cliente?.id ?? 0)
                            );

                            if (cedulaRepetida) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                //funcion para mensajes
                                SnackBar(
                                  content: Text('La cédula ya está registrada'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            // Verifico si el correo ya existe y si se comprueba que ya existe vota el mensaje
                            bool correoRepetido = allClients.any(
                                    (c) => c.correo.toLowerCase() == correoController.text.toLowerCase() && c.id != (cliente?.id ?? 0)
                            );

                            if (correoRepetido) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                // funcion para mensajes
                                SnackBar(
                                  content: Text('El correo ya está registrado'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }


                            final clients = ClientsModels(
                              cedula: cedulaController.text,
                              nombre: nombreController.text,
                              direccion: direccionController.text,
                              telefono: telefonoController.text,
                              correo: correoController.text,
                            );
                            if (cliente != null) {
                              clients.id = cliente!.id;
                              await repo.edit(clients);
                            } else {
                              await repo.create(clients);
                            }
                            //mensajes de exito
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  esEditar ? 'Actualización exitosa' : 'Registro Exitoso',
                                  textAlign: TextAlign.center,
                                ),
                                duration: Duration(milliseconds: 500),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );

                            await Future.delayed(Duration(milliseconds: 650));
                            Navigator.pop(context);
                          }
                        },


                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(10),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Aceptar'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),

                  Expanded(
                    child: SizedBox(
                      height: 70,

                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(10),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cancel, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Cancelar'),
                          ],
                        ),
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
