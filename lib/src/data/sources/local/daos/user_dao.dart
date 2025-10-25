import 'package:simple_register_app/src/core/errors/exceptions.dart';
import 'package:simple_register_app/src/data/models/user_model.dart';
import 'package:simple_register_app/src/data/sources/local/database.dart';
import 'package:simple_register_app/src/data/sources/local/tables/user_table.dart';
import 'package:sqflite/sqflite.dart';

class UserDao {
  final DatabaseProvider _databaseProvider;

  UserDao(this._databaseProvider);

  Future<int> insert(UserModel user) async {
    try {
      final db = await _databaseProvider.database;

      return await db.insert(
        UserTable.tableName,
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } on DatabaseException catch (e) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        throw const UserAlreadyExistsException(
          message: 'Ya existe un usuario con este correo electrónico',
        );
      }

      throw LocalDatabaseException(
        message: 'Error al registrar usuario: ${e.toString()}',
      );
    } catch (e) {
      throw LocalDatabaseException(
        message: 'Error inesperado al registrar usuario: ${e.toString()}',
      );
    }
  }

  Future<UserModel> fetchById(int id) async {
    try {
      final db = await _databaseProvider.database;

      final results = await db.query(
        UserTable.tableName,
        where: '${UserTable.idColumn} = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (results.isEmpty) {
        throw const UserNotFoundException(message: 'Usuario no encontrado');
      }

      return UserModel.fromMap(results.first);
    } catch (e) {
      if (e is UserNotFoundException) {
        rethrow;
      }

      throw LocalDatabaseException(
        message: 'Error al obtener usuario: ${e.toString()}',
      );
    }
  }

  Future<UserModel> fetchByEmail(String email) async {
    try {
      final db = await _databaseProvider.database;

      final results = await db.query(
        UserTable.tableName,
        where: '${UserTable.emailColumn} = ?',
        whereArgs: [email],
        limit: 1,
      );

      if (results.isEmpty) {
        throw const UserNotFoundException(message: 'Usuario no encontrado');
      }

      return UserModel.fromMap(results.first);
    } catch (e) {
      if (e is UserNotFoundException) {
        rethrow;
      }

      throw LocalDatabaseException(
        message: 'Error al obtener usuario: ${e.toString()}',
      );
    }
  }
}
