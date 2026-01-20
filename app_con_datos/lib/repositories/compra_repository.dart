import '../models/compra_models.dart';
import '../settings/database_connection.dart';


class CompraRepository {
  final tableName = "compras";
  final database = DatabaseConnection();

  Future<int> create(CompraModels data) async {
    final db = await database.db;  
    return await db.insert(tableName, data.toMap()); 
  }

  Future<int> edit(CompraModels data) async {
    final db = await database.db;  
    return await db.update(
      tableName, 
      data.toMap(), 
      where: 'id = ?',
      whereArgs: [data.id],
    ); 
  }

  Future<int> delete(int id) async {
    final db = await database.db;  
    return await db.delete(
      tableName,  
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<CompraModels>> getAll() async {
    final db = await database.db;
    final response = await db.query(tableName);
    return response
        .map((e) => CompraModels.fromMap(e))
        .toList(); 
  }
}