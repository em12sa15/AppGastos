import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLdb {
  static final SQLdb instance = SQLdb._init();

  static Database? _database;

  SQLdb._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('gastos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE gastos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descripcion TEXT,
        cantidad INTEGER
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await database;
    return await db.query('gastos');
  }

  Future<int> createData(String descripcion, int cantidad) async {
    final db = await database;
    var res = await db.insert('gastos', {
      'descripcion': descripcion,
      'cantidad': cantidad,
    });
    return res;
  }

  Future<int> updateData(int id, String descripcion, int cantidad) async {
    final db = await database;
    return await db.update(
      'gastos',
      {'id': id, 'descripcion': descripcion, 'cantidad': cantidad},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteData(int id) async {
    final db = await database;
    await db.delete(
      'gastos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
