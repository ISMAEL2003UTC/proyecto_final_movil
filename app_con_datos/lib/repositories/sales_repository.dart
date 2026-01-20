import '../models/sales_models.dart';
import '../settings/database_connection.dart';

class SaleRepository {
  final tableName = "sales";
  final database = DatabaseConnection();

  Future<int> create(SaleModels data) async {
    final db = await database.db;
    return await db.insert(tableName, data.toMap());
  }

  Future<List<SaleModels>> getAll() async {
    final db = await database.db;
    final response = await db.query(tableName);
    return response.map((e) => SaleModels.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    final db = await database.db;
    return await db.delete(
      tableName,
      where: 'id=?',
      whereArgs: [id],
    );
  }
}
