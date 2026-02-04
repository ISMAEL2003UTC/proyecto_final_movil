class GastosModel {
  int? id;
  String nombre;
  String descripcion;
  double monto;
  String fecha;
  String tipo;

  GastosModel({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.monto,
    required this.fecha,
    required this.tipo,
  });

  factory GastosModel.fromMap(Map<String, dynamic> data) {
    return GastosModel(
      id: data["id"],
      nombre: data["nombre"],
      descripcion: data["descripcion"],
      monto: (data["monto"] as num).toDouble(), // de igual manera convierte numeros a double
      fecha: data["fecha"],
      tipo: data["tipo"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      
      'nombre': nombre,
      'descripcion': descripcion,
      'monto': monto,
      'fecha': fecha,
      'tipo': tipo,
    };
  }
}
