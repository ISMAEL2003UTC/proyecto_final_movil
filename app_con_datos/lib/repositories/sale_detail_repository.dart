import '../models/sale_detail_models.dart';
import '../settings/database_connection.dart';

class SaleDetailRepository {
  final tableName = "sale_details";
  final database = DatabaseConnection();

  Future<int> create(SaleDetailModels data) async {
    final db = await database.db;
    return await db.insert(tableName, data.toMap());
  }

  Future<List<SaleDetailModels>> getByVenta(int ventaId) async {
    final db = await database.db;
    final response = await db.query(
      tableName,
      where: 'ventaId=?',
      whereArgs: [ventaId],
    );
    return response.map((e) => SaleDetailModels.fromMap(e)).toList();
  }
}
