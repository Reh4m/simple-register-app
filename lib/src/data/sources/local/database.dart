import 'package:path/path.dart';
import 'package:simple_register_app/src/data/sources/local/tables/user_table.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static Database? _database;
  static const String _dbName = 'app_database.db';
  static const int _dbVersion = 1;

  // Singleton pattern:
  // This ensures that only one instance of the database is created
  // and used throughout the app.
  static final DatabaseProvider _instance = DatabaseProvider._internal();

  // Returns the singleton instance of the database provider.
  factory DatabaseProvider() => _instance;

  DatabaseProvider._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute(UserTable.createTableQuery);
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();

      _database = null;
    }
  }

  Future<void> deleteDatabaseFile() async {
    String path = join(await getDatabasesPath(), _dbName);

    await deleteDatabase(path);
  }
}
