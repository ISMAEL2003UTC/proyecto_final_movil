class CategoryModels {
  int? id;
  String nombre;
  String descripcion;

  CategoryModels({
    this.id,
    required this.nombre,
    required this.descripcion,
  });
  //convertir de map a clase
  factory CategoryModels.fromMap(Map<String, dynamic> data) {
    return CategoryModels(
      id: data["id"],
      nombre: data["nombre"],
      descripcion: data["descripcion"],
    );
  }
  //convertir de clase a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
    };
  }
}
