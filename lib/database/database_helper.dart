import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/folio_model.dart';

class DatabaseHelper {
  // Instancia única (Singleton) para no abrir múltiples conexiones
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Getter para obtener la base de datos (la abre si no existe)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('compuseg.db');
    return _database!;
  }

  // Inicializar la BD
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Crear las tablas (Solo se ejecuta la primera vez que se instala la app)
  Future _createDB(Database db, int version) async {
    // Tabla de Usuarios
    // id: Autoincremental
    // username: Texto único (no puede haber dos iguales)
    // password: Texto
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT UNIQUE,
      password TEXT
    )
    ''');
    // Tabla de Folios
    await db.execute('''
    CREATE TABLE folios (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      folioCode TEXT,
      nombreCliente TEXT,
      telefono TEXT,
      equipo TEXT,
      descripcion TEXT,
      estado TEXT,
      userId INTEGER
    )
    ''');

    // NOTA: Aquí agregaremos la tabla de 'folios' más adelante
  }

  // --- MÉTODOS DE USUARIO ---

  // 1. Registrar Usuario
  Future<int> registerUser(User user) async {
    final db = await instance.database;
    try {
      // insert devuelve el ID del nuevo usuario
      return await db.insert('users', user.toMap());
    } catch (e) {
      // Si falla (ej. usuario duplicado), devuelve -1
      return -1;
    }
  }

  // 2. Login de Usuario (Verificar credenciales)
  Future<User?> loginUser(String username, String password) async {
    final db = await instance.database;
    
    // Busca un usuario que coincida con el nombre Y la contraseña
    final maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null; // Credenciales incorrectas
    }
  }
  // --- FOLIOS (NUEVO) ---
  Future<int> createFolio(Folio folio) async {
    final db = await instance.database;
    return await db.insert('folios', folio.toMap());
  }
  
  // Obtener folios SOLO del usuario actual
  Future<List<Folio>> getFoliosByUserId(int userId) async {
    final db = await instance.database;
    final result = await db.query(
      'folios',
      where: 'userId = ?', // Filtro mágico
      whereArgs: [userId],
    );
    return result.map((json) => Folio.fromMap(json)).toList();
  }
  Future<int> updateFolioStatus(int id, String newStatus) async {
    final db = await instance.database;
    return await db.update(
      'folios',
      {'estado': newStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 2. Contar cuántos folios tiene un usuario (Para el autollenado)
  Future<int> getFolioCount(int userId) async {
    final db = await instance.database;
    // Sqflite devuelve una lista, usamos Sqflite.firstIntValue para obtener el número
    var x = await db.rawQuery('SELECT COUNT (*) from folios WHERE userId = ?', [userId]);
    return Sqflite.firstIntValue(x) ?? 0;
  }
}