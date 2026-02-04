import '../models/category_models.dart';
import '../models/products_models.dart';
import '../settings/database_connection.dart';

class CategoryRepository {
  final tableName = "categories"; //definimos el nombre de la tabla que se va a utilizar
  final database = DatabaseConnection(); //definimos coneccion a la base de datos 

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
      where: 'id=?',  // BUSCA EL ID A EDITAR
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
    final response = await db.query(tableName); // ejecuta el select
    return response.map((e) => CategoryModels.fromMap(e)).toList(); //Convierte datos sql en objetos flutter 
  }

  //obtener productos por id de categoría (esta funcion es para obtener los datos de la tabla relacionada)
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
