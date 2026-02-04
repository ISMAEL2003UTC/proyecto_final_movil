import '../models/products_models.dart';
import '../models/sale_detail_models.dart';
import '../settings/database_connection.dart';

class ProductsRepository {
  final tableName = "products";
  final database = DatabaseConnection();
  
  // funcion para insertar datos
  Future<int> create(ProductsModels data) async {
    final db = await database.db; //1. llamar a la conexion
    return await db.insert(tableName, data.toMap()); // ejecuto el sql
  }

  //funcion para poder editar
  Future<int> edit(ProductsModels data) async {
    final db = await database.db; //1. llamar a la conexion
    return await db.update(
      tableName,
      data.toMap(),
      where: 'id=?',
      whereArgs: [data.id],
    ); // ejecuto el sql
  }

  //funcion para poder eliminar
  Future<int> delete(int id) async {
    final db = await database.db; //1. llamar a la conexion
    return await db.delete(
      tableName,
      where: 'id=?',
      whereArgs: [id],
    ); // ejecuto el sql
  }

  //funcion para listar datos
  Future<List<ProductsModels>> getAll() async {
    final db = await database.db;
    final response = await db.query(tableName);
    return response.map((e) => ProductsModels.fromMap(e)).toList();
  }

  // NUEVO: obtener ventas relacionadas con un producto
  Future<List<SaleDetailModels>> getSalesByProductId(int productId) async {
    final db = await database.db;
    final response = await db.query(
      'sale_details',
      where: 'productoId = ?',
      whereArgs: [productId],
    );
    return response.map((e) => SaleDetailModels.fromMap(e)).toList();
  }

  // MÉTODO PARA ACTUALIZAR STOCK(aqui se actualiza el stock luego de una compra)
  Future<int> updateStock(int productId, double newStock) async {
    final db = await database.db;
    return await db.update(
      tableName,
      {'stock': newStock},
      where: 'id = ?',
      whereArgs: [productId],
    );
  }
}