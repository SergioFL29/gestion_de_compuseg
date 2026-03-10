import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/folio_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('compuseg.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // Subimos la versión para que ejecute cambios
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    // 1. Tabla de Usuarios
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // 2. NUEVA Tabla de Clientes
    await db.execute('''
      CREATE TABLE clientes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        telefono TEXT NOT NULL,
        userId INTEGER NOT NULL
      )
    ''');

    // 3. Tabla de Folios (Vinculada a clienteId)
    await db.execute('''
      CREATE TABLE folios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        folioCode TEXT NOT NULL,
        clienteId INTEGER NOT NULL,
        equipo TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        estado TEXT NOT NULL,
        userId INTEGER NOT NULL
      )
    ''');
  }
   // --- MÉTODOS DE USUARIO (REINSTALADOS) ---
  Future<int> registerUser(User user) async {
    final db = await instance.database;
    try {
      return await db.insert('users', user.toMap());
    } catch (e) {
      return -1;
    }
  }

  Future<User?> loginUser(String username, String password) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }
  // Función para manejar la actualización de la BD sin borrar todo
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS folios'); // Borramos la vieja para evitar conflictos de columnas
      await _createDB(db, newVersion);
    }
  }

  // --- MÉTODOS PARA CLIENTES ---
  Future<int> createCliente(String nombre, String telefono, int userId) async {
    final db = await instance.database;
    // Verificamos si ya existe por teléfono para no duplicar
    final res = await db.query('clientes', where: 'telefono = ? AND userId = ?', whereArgs: [telefono, userId]);
    if (res.isNotEmpty) return res.first['id'] as int;
    
    return await db.insert('clientes', {
      'nombre': nombre,
      'telefono': telefono,
      'userId': userId,
    });
  }

  Future<List<Map<String, dynamic>>> getClientes(int userId) async {
    final db = await instance.database;
    return await db.query('clientes', where: 'userId = ?', whereArgs: [userId]);
  }

  // --- MÉTODOS PARA FOLIOS (CON JOIN PARA TRAER NOMBRE DEL CLIENTE) ---
  Future<int> createFolio(Map<String, dynamic> folioData) async {
    final db = await instance.database;
    return await db.insert('folios', folioData);
  }

  Future<List<Map<String, dynamic>>> getFoliosFull(int userId) async {
    final db = await instance.database;
    // Hacemos un JOIN para obtener los datos del cliente junto con el folio
    return await db.rawQuery('''
      SELECT folios.*, clientes.nombre, clientes.telefono 
      FROM folios 
      INNER JOIN clientes ON folios.clienteId = clientes.id
      WHERE folios.userId = ?
    ''', [userId]);
  }

  Future<int> updateFolioStatus(int id, String newStatus) async {
    final db = await instance.database;
    return await db.update('folios', {'estado': newStatus}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getFolioCount(int userId) async {
    final db = await instance.database;
    var x = await db.rawQuery('SELECT COUNT (*) from folios WHERE userId = ?', [userId]);
    return Sqflite.firstIntValue(x) ?? 0;
  }
} 