class ClientsModels {
  int? id;
  String cedula;
  String nombre;
  String direccion;
  String telefono;
  String correo;
  String fechaNacimiento;
  ClientsModels({
    this.id,
    required this.cedula,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.correo,
    required this.fechaNacimiento,
  });

  //convertir de map a clase
  factory ClientsModels.fromMap(Map<String, dynamic> data) {
    return ClientsModels(
      id: data["id"],
      cedula: data["cedula"],
      nombre: data["nombre"],
      direccion: data["direccion"],
      telefono: data["telefono"],
      correo: data["correo"],
      fechaNacimiento: data["fechaNacimiento"],
    );
  }
  //convertir de clase a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cedula': cedula,
      'nombre': nombre,
      'direccion': direccion,
      'telefono': telefono,
      'correo': correo,
      'fechaNacimiento': fechaNacimiento,
    };
  }
}
