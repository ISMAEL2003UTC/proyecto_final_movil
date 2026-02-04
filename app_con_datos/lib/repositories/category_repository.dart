import '../models/category_models.dart';
import '../models/products_models.dart';
import '../settings/database_connection.dart';

class CategoryRepository {
  final tableName = "categories";
  final database = DatabaseConnection();

  // funcion para insertar datos
  Future<int> create(CategoryModels data) async {
    final db = await database.db;
    return await db.insert(tableName, data.toMap()); // ejecuto el sql
  }

  //funcion para poder editar
  Future<int> edit(CategoryModels data) async {
    final db = await database.db;
    return await db.update(
      tableName,
      data.toMap(),
      where: 'id=?',
      whereArgs: [data.id],
    ); // ejecuto el sql
  }

  //funcion para poder eliminar
  Future<int> delete(int id) async {
    final db = await database.db;
    return await db.delete(
      tableName,
      where: 'id=?',
      whereArgs: [id],
    ); // ejecuto el sql
  }

  //funcion para listar datos
  Future<List<CategoryModels>> getAll() async {
    final db = await database.db;
    final response = await db.query(tableName);
    return response.map((e) => CategoryModels.fromMap(e)).toList();
  }

  //obtener productos por id de categoría
  Future<List<ProductsModels>> getProductsByCategoryId(int categoryId) async {
    final db = await database.db;
    final response = await db.query(
      'products',
      where: 'categoriaId = ?',
      whereArgs: [categoryId],
    );
    return response.map((e) => ProductsModels.fromMap(e)).toList();
  }
}
