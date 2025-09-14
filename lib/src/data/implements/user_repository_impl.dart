import 'package:dartz/dartz.dart';
import 'package:simple_register_app/src/core/errors/exceptions.dart';
import 'package:simple_register_app/src/core/errors/failures.dart';
import 'package:simple_register_app/src/data/sources/local/daos/user_dao.dart';
import 'package:simple_register_app/src/domain/entities/user_entity.dart';
import 'package:simple_register_app/src/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDao _userDao;

  UserRepositoryImpl(this._userDao);

  @override
  Future<Either<Failure, UserEntity>> getUserById(int id) async {
    try {
      final user = await _userDao.fetchById(id);

      return Right(user.toEntity());
    } on UserNotFoundException catch (e) {
      return Left(UserNotFoundFailure(message: e.message));
    } on LocalDatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(
        DatabaseFailure(message: 'Error inesperado: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserByEmail(String email) async {
    try {
      final user = await _userDao.fetchByEmail(email);

      return Right(user.toEntity());
    } on UserNotFoundException catch (e) {
      return Left(UserNotFoundFailure(message: e.message));
    } on LocalDatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(
        DatabaseFailure(message: 'Error inesperado: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> updateUser(UserEntity user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> deleteUser(int id) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }
}
