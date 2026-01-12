import '../models/clients_models.dart';
import '../settings/database_connection.dart';

class ClientsRepository {
  final tableName = "clients";
  final database = DatabaseConnection();
  // funcion para insertar datos
  Future<int> create(ClientsModels data) async {
    final db = await database.db; //1. llamar a la conexion
    return await db.insert(tableName, data.toMap()); // ejecuto el sql
  }

  //funcion para poder editar
  Future<int> edit(ClientsModels data) async {
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
  Future<List<ClientsModels>> getAll() async {
    final db = await database.db;
    final response = await db.query(tableName);
    return response.map((e) => ClientsModels.fromMap(e)).toList();
  }

  //funcion para eliminar
}
