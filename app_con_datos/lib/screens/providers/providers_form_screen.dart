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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "EL CAMPO ES REQUERIDO";
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
                            final repo = ProvidersRepository();
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
                            Navigator.pop(context);
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
