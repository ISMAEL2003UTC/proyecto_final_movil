import '../models/gastos_model.dart';
import '../settings/database_connection.dart';

class GastosRepository {
  final tableName = "gastos";
  final database = DatabaseConnection();

  // funcion para insertar datos
  Future<int> create(GastosModel data) async {
    final db = await database.db; //1. llamar a la conexion
    return await db.insert(tableName, data.toMap()); // ejecuto el sql
  }

  // funcion para poder editar
  Future<int> edit(GastosModel data) async {
    final db = await database.db; //1. llamar a la conexion
    return await db.update(
      tableName,
      data.toMap(),
      where: 'id=?',
      whereArgs: [data.id],
    ); // ejecuto el sql
  }

  // funcion para poder eliminar
  Future<int> delete(int id) async {
    final db = await database.db; //1. llamar a la conexion
    return await db.delete(
      tableName,
      where: 'id=?',
      whereArgs: [id],
    ); // ejecuto el sql
  }

  // funcion para listar datos
  Future<List<GastosModel>> getAll() async {
    final db = await database.db;
    final response = await db.query(tableName);
    return response.map((e) => GastosModel.fromMap(e)).toList();
  }

}
