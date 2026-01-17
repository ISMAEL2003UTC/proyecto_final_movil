class SaleModels {
  int? id;
  int clienteId;
  String fecha;
  double montoTotal;

  SaleModels({
    this.id,
    required this.clienteId,
    required this.fecha,
    required this.montoTotal,
  });

  // Map → Clase
  factory SaleModels.fromMap(Map<String, dynamic> data) {
    return SaleModels(
      id: data['id'],
      clienteId: data['clienteId'],
      fecha: data['fecha'],
      montoTotal: data['montoTotal'],
    );
  }

  // Clase → Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clienteId': clienteId,
      'fecha': fecha,
      'montoTotal': montoTotal,
    };
  }
}
