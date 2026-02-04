
import '../models/compra_models.dart';
import '../settings/database_connection.dart';


// Repositorio encargado de todas las operaciones CRUD de la tabla compras
class CompraRepository {
  // Nombre de la tabla en la base de datos
  final tableName = "compras";
  final database = DatabaseConnection(); //conexion a la bdd
//funcion para insertar datos
  Future<int> create(CompraModels data) async {
    final db = await database.db;
    return await db.insert(tableName, data.toMap());
  }
  // EDITAR 
  Future<int> edit(CompraModels data) async {
    final db = await database.db;
    return await db.update(
      tableName,
      data.toMap(),          
      where: 'id = ?',     
      whereArgs: [data.id],
    );
  }
  // ELIMINAR
  Future<int> delete(int id) async {
    // Obtiene la conexión a la base de datos
    final db = await database.db;
    // Ejecuta el DELETE en la tabla compras
    return await db.delete(
      tableName,
      where: 'id = ?',   
      whereArgs: [id],   
    );
  }
  // LISTAR
  Future<List<CompraModels>> getAll() async {
    // Obtiene la conexión a la base de datos
    final db = await database.db;
    // Consulta todos los registros de la tabla compras
    final response = await db.query(tableName);
    return response
        .map((e) => CompraModels.fromMap(e))
        .toList();
  }
}
