import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

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
}