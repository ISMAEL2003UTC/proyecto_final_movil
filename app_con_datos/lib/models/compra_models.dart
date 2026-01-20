class CompraModels {
  int? id;
  int productoId;
  int cantidad;
  double precioCosto;
  double montoTotal;
  String fecha;

  CompraModels({
    this.id,
    required this.productoId,
    required this.cantidad,
    required this.precioCosto,
    required this.montoTotal,
    required this.fecha,
  });

  factory CompraModels.fromMap(Map<String, dynamic> map) {
    return CompraModels(
      id: map['id'],
      productoId: map['productoId'],
      cantidad: map['cantidad'],
      precioCosto: map['precioCosto'],
      montoTotal: map['montoTotal'],
      fecha: map['fecha'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "productoId": productoId,
      "cantidad": cantidad,
      "precioCosto": precioCosto,
      "montoTotal": montoTotal,
      "fecha": fecha,
    };
  }
}