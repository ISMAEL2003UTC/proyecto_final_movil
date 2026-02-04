import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  ProvidersModel? proveedor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Capturo parámetros desde la interfaz anterior
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      proveedor = args as ProvidersModel;
      cedulapController.text = proveedor!.cedulap;
      nombrepController.text = proveedor!.nombrep;
      direccionpController.text = proveedor!.direccionp;
      telefonopController.text = proveedor!.telefonop;
      correopController.text = proveedor!.correop;
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = proveedor != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? "Editar Proveedor" : "Agregar Proveedores"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formProvider,
          child: Column(
            children: [
              TextFormField(
                controller: cedulapController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "EL CAMPO ES REQUERIDO";
                  }
                  if (value.length != 10) {
                    return "La cédula debe tener exactamente 10 dígitos";
                  }
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return "La cédula solo debe contener números";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Cédula",
                  hintText: "Ingrese la cédula del proveedor",
                  prefixIcon: Icon(Icons.qr_code),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nombrepController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "EL CAMPO ES REQUERIDO";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Nombre",
                  hintText: "Ingrese el nombre del proveedor",
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: direccionpController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "EL CAMPO ES REQUERIDO";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Dirección",
                  hintText: "Ingrese la dirección del proveedor",
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: telefonopController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
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
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: correopController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
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
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 70,
                      child: TextButton(
                        onPressed: () async {
                          if (formProvider.currentState!.validate()) {
                            // aqui vald que no exist una cedula duplicada
                            final repo = ProvidersRepository();
                            final proveedores = await repo.getAll();
                            final cedulaActual = cedulapController.text;
                            
                            final correoActual = correopController.text;
                            bool cedulaDuplicada = false;
                            bool correoDuplicado = false;
                            for (var p in proveedores) {
                              if (p.cedulap == cedulaActual && p.id != proveedor?.id) {
                                cedulaDuplicada = true;
                                break;
                              }
                            }
                            if (!cedulaDuplicada) {
                              for (var p in proveedores) {
                                if (p.correop.toLowerCase() == correoActual.toLowerCase() && p.id != proveedor?.id) {
                                  correoDuplicado = true;
                                  break;
                                }
                              }
                            }

                            if (cedulaDuplicada) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Ya existe un proveedor con esta cédula"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                              return;
                            }
                            if (correoDuplicado) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Ya existe un proveedor con este correo"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                              return;
                            }
                            
                            final provider = ProvidersModel(
                              cedulap: cedulapController.text,
                              nombrep: nombrepController.text,
                              direccionp: direccionpController.text,
                              telefonop: telefonopController.text,
                              correop: correopController.text,
                            );
                            if (esEditar) {
                              provider.id = proveedor!.id;
                              await repo.edit(provider);
                            } else {
                              await repo.create(provider);
                            }
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save),
                            SizedBox(height: 5),
                            Text('Aceptar'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: SizedBox(
                      height: 70,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cancel),
                            SizedBox(height: 5),
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
