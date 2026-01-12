import 'package:flutter/material.dart';

import '../../models/clients_models.dart';
import '../../repositories/clients_repository.dart';

class ClienteFormScreen extends StatefulWidget {
  const ClienteFormScreen({super.key});
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
  final fechaController = TextEditingController();
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
      fechaController.text = cliente!.fechaNacimiento;
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
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formClients,
          child: Column(
            children: [
              TextFormField(
                controller: cedulaController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "La cédula es requerido";
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El teléfono es requerido";
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El correo es requerido";
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

              TextFormField(
                controller: fechaController,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "La fecha de nacimiento es requerido";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Fecha de nacimiento',
                  hintText: 'Ingrese la fecha de nacimiento',
                  prefixIcon: Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 70,
                      child: TextButton(
                        onPressed: () async {
                          if (formClients.currentState!.validate()) {
                            //almacenar datos
                            final repo = ClientsRepository();
                            final clients = ClientsModels(
                              cedula: cedulaController.text,
                              nombre: nombreController.text,
                              direccion: direccionController.text,
                              telefono: telefonoController.text,
                              correo: correoController.text,
                              fechaNacimiento: fechaController.text,
                            );
                            if (esEditar) {
                              clients.id = cliente!.id;
                              await repo.edit(clients);
                            } else {
                              await repo.create(clients);
                            }
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Registro exitoso'),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Future.delayed(Duration(microseconds: 500), () {
                            Navigator.pop(context);
                          });
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
