class SaleDetailModels {
  int? id;
  int ventaId;
  int productoId;
  int cantidad;
  double precioUnitario;
  double subtotal;

  SaleDetailModels({
    this.id,
    required this.ventaId,
    required this.productoId,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });

  factory SaleDetailModels.fromMap(Map<String, dynamic> data) {
    return SaleDetailModels(
      id: data['id'],
      ventaId: data['ventaId'],
      productoId: data['productoId'],
      cantidad: data['cantidad'],
      precioUnitario: data['precioUnitario'],
      subtotal: data['subtotal'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ventaId': ventaId,
      'productoId': productoId,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      'subtotal': subtotal,
    };
  }
}
