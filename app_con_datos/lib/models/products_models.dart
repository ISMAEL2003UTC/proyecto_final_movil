class ProductsModels {
  int? id;
  String codigo;
  String nombre;
  String descripcion;
  double precio;
  double costo;
  double stock;
  int? categoriaId;


  ProductsModels({
    this.id,
    required this.codigo,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.costo,
    required this.stock,
    this.categoriaId,
  });

  //convertir de map a clase
  factory ProductsModels.fromMap(Map<String, dynamic> data) {
    return ProductsModels(
      id: data["id"],
      codigo: data["codigo"],
      nombre: data["nombre"],
      descripcion: data["descripcion"],
      precio: (data["precio"] as num).toDouble(),
      costo: (data["costo"] as num).toDouble(),
      stock: (data["stock"] as num).toDouble(),
      categoriaId: data["categoriaId"],
    );
  }
  //convertir de clase a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'codigo': codigo,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'costo': costo,
      'stock': stock,
      'categoriaId': categoriaId,
    };
  }
}
