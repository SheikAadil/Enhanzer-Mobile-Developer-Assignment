import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('items.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Item_Details (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        price REAL NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE Transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        discount REAL NOT NULL,
        amount REAL NOT NULL
      );
    ''');
    await db.insert(
        'Item_Details', {'id': '001', 'name': 'Item 1', 'price': 50.00});
    await db.insert(
        'Item_Details', {'id': '002', 'name': 'Item 2', 'price': 60.00});
    await db.insert(
        'Item_Details', {'id': '003', 'name': 'Item 3', 'price': 70.00});
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    final db = await instance.database;
    return await db.query('Item_Details');
  }

  Future<void> saveTransaction(Map<String, dynamic> transaction) async {
    final db = await instance.database;
    await db.insert('Transactions', transaction);
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await instance.database;
    return await db.query('Transactions');
  }
}
