import '../models/providers_model.dart';
import '../settings/database_connection.dart';

class ProvidersRepository{
  final tableName="provider";
  final database = DatabaseConnection();
  //funcion para insertar datos
  Future<int> create(ProvidersModel data ) async{
    final db = await database.db; //1.llama ala conexion
    return await db.insert(tableName,data.toMap()); //2.ejecuto el sql
  }
  //funcion para editar datos
  Future<int> edit(ProvidersModel data ) async{
    final db = await database.db; //1.llamar ala conexion
    return await db.update(
      tableName,
      data.toMap(),
      where:'id=?',
      whereArgs: [data.id],

      ); //2.ejecuto el sql
  }
  //funcion para eliminar datos
  Future<int> delete(int id  ) async{
    final db = await database.db; //1.llamar ala conexion
    return await db.delete(
      tableName,
      where:'id=?',
      whereArgs: [id],
      ); //2.ejecuto el sql
  }
  //funcion para listar datos
  Future<List<ProvidersModel>> getAll() async{
    final db = await database.db; //1.- llamar ala conexion
    final response = await db.query(tableName);//2.ejecuto el sql 
    return response
    .map((e)=>ProvidersModel.fromMap(e))
    .toList();//3.transformar de json a clase
  }
}