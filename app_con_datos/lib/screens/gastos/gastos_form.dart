import 'package:flutter/material.dart';

import '../../models/gastos_model.dart';
import '../../repositories/gastos_repository.dart';


class GastoFormScreen extends StatefulWidget {
  const GastoFormScreen({super.key});

  @override
  State<GastoFormScreen> createState() => _GastoFormScreenState();
}

class _GastoFormScreenState extends State<GastoFormScreen> {
  final formGastos = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  final montoController = TextEditingController();
  final fechaController = TextEditingController();
  final tipoController = TextEditingController();

  GastosModel? gasto;
//edicion de Datos
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // capturo datos para editar
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      gasto = args as GastosModel;
      nombreController.text = gasto!.nombre;
      descripcionController.text = gasto!.descripcion;
      montoController.text = gasto!.monto.toString();
      fechaController.text = gasto!.fecha;
      tipoController.text = gasto!.tipo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = gasto != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? "Editar Gasto" : "Agregar Gasto"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formGastos,
          child: Column(
            children: [
              // Nombre
              TextFormField(
                controller: nombreController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "El nombre es requerido";
                  }

                  if (RegExp(r'[0-9]').hasMatch(value)) {
                    return "El nombre no debe tener números";
                  }

                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Ingrese el nombre del gasto',
                  prefixIcon: Icon(Icons.receipt_long, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),

              // Descripción
              TextFormField(
                controller: descripcionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "La descripción es requerida";
                  }
                  if (RegExp(r'[0-9]').hasMatch(value)) {
                    return "La descripción no debe contener números";
                  }
                  return null;
                },
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Ingrese la descripción',
                  prefixIcon: Icon(Icons.description, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),

              // Monto
              TextFormField(
                controller: montoController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "El monto es requerido";
                  }

                  final monto = double.tryParse(value);
                  if (monto == null) {
                    return "Ingrese un valor numérico válido";
                  }

                  if (monto <= 0) {
                    return "El monto debe ser mayor a 0";
                  }

                  return null;
                },  
                decoration: InputDecoration(
                  labelText: 'Monto',
                  hintText: 'Ingrese el monto',
                  prefixIcon: Icon(Icons.attach_money, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),

              // Fecha
              TextFormField(
                controller: fechaController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "La fecha es requerida";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  hintText: 'YYYY-MM-DD',
                  prefixIcon: Icon(Icons.date_range, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),

              // Tipo
              TextFormField(
                controller: tipoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El tipo es requerido";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Tipo',
                  hintText: 'Ej: Alimentación, Transporte',
                  prefixIcon: Icon(Icons.category, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),

              // Botones
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 70,
                      child: TextButton(
                        onPressed: () async { //se preciona en guardar y valida todos los datos
                          if (formGastos.currentState!.validate()) {
                            final repo = GastosRepository();

                            final gastoData = GastosModel(
                              nombre: nombreController.text,
                              descripcion: descripcionController.text,
                              monto: double.parse(montoController.text),
                              fecha: fechaController.text,
                              tipo: tipoController.text,
                            );

                            if (esEditar) {
                              gastoData.id = gasto!.id;
                              await repo.edit(gastoData);
                            } else {
                              await repo.create(gastoData);
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                             //mensaje de exito al guardar
                              SnackBar(
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Registro exitoso'),
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );

                            Future.delayed(Duration(milliseconds: 500), () {
                              Navigator.pop(context);
                            });
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
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
                            borderRadius: BorderRadius.circular(10),
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
