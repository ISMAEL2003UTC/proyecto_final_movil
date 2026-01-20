import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConnection {
  // generando un consructor parael llamado
  static final DatabaseConnection instance = DatabaseConnection.internal();
  factory DatabaseConnection() => instance;
  //referencias internas
  DatabaseConnection.internal();
  static Database? database;
  //funcion para crear nlam conexion de la bdd
  Future<Database> get db async {
    if (database != null)
      return database!; //retorna la conexion si ya existia una antes
    database = await inicializarDb(); //inicializa la conexion en la funcion
    return database!;
  }

  Future<Database> inicializarDb() async {
    final rutaDb = await getDatabasesPath();
    final rutaFinal = join(rutaDb, 'gestion.db');

    return await openDatabase(
      rutaFinal,
      version: 1,
      onCreate: (Database db, int version) async {
        // Tabla de categorías
        await db.execute('''
        CREATE TABLE categories(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT NOT NULL,
          descripcion TEXT
        );
        ''');

        // Tabla de productos
        await db.execute('''
        CREATE TABLE products(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          codigo TEXT NOT NULL,
          nombre TEXT NOT NULL,
          descripcion TEXT,
          precio REAL NOT NULL,
          costo REAL NOT NULL,
          stock REAL NOT NULL,
          categoriaId INTEGER,
          FOREIGN KEY (categoriaId) REFERENCES categories(id)
        );
        ''');

        // Tabla de clientes
        await db.execute('''
        CREATE TABLE clients(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          cedula TEXT NOT NULL,
          nombre TEXT NOT NULL,
          direccion TEXT NOT NULL,
          telefono TEXT NOT NULL,
          correo TEXT NOT NULL
        );
        ''');

        // Tabla de proveedores
        await db.execute('''
        CREATE TABLE provider(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          cedulap TEXT NOT NULL,
          nombrep TEXT NOT NULL,
          direccionp TEXT NOT NULL,
          telefonop TEXT NOT NULL,
          correop TEXT NOT NULL
        );
        ''');
        // Tabla de gastos
        await db.execute('''
        CREATE TABLE gastos(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT NOT NULL,
          descripcion TEXT,
          monto REAL NOT NULL,
          fecha TEXT NOT NULL,
          tipo TEXT NOT NULL
        );
      ''');

        // Tabla de compras
        await db.execute('''
      CREATE TABLE purchases(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productoId INTEGER NOT NULL,
        cantidad INTEGER NOT NULL,
        precioCosto REAL NOT NULL,
        montoTotal REAL NOT NULL,
        fecha TEXT NOT NULL,
        FOREIGN KEY (productoId) REFERENCES products(id)
      );
      ''');
        // Tabla principal de ventas
        await db.execute('''
      CREATE TABLE sales(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        clienteId INTEGER NOT NULL,
        fecha TEXT NOT NULL,
        montoTotal REAL NOT NULL,
        FOREIGN KEY (clienteId) REFERENCES clients(id)
      );
      ''');

        // Tabla de detalles de ventas
        await db.execute('''
      CREATE TABLE sale_details(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ventaId INTEGER NOT NULL,
        productoId INTEGER NOT NULL,
        cantidad INTEGER NOT NULL,
        precioUnitario REAL NOT NULL,
        subtotal REAL NOT NULL,
        FOREIGN KEY (ventaId) REFERENCES sales(id),
        FOREIGN KEY (productoId) REFERENCES products(id)
      );
      ''');
      },
    );
  }
}
