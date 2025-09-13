import 'package:path/path.dart';
import 'package:simple_register_app/src/data/sources/local/tables/user_table.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static Database? _database;
  static const String _dbName = 'app_database.db';
  static const int _dbVersion = 1;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();

    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _createDatabase,
    );
  }

  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute(UserTable.createTableQuery);
  }

  static Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();

      _database = null;
    }
  }

  static Future<void> deleteDatabaseFile() async {
    String path = join(await getDatabasesPath(), _dbName);

    await deleteDatabase(path);
  }
}
