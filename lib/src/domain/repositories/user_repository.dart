import 'package:dartz/dartz.dart';
import 'package:simple_register_app/src/core/errors/failures.dart';
import 'package:simple_register_app/src/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getUserById(int id);

  Future<Either<Failure, UserEntity>> getUserByEmail(String email);

  Future<Either<Failure, bool>> updateUser(UserEntity user);

  Future<Either<Failure, bool>> deleteUser(int id);

  Future<Either<Failure, bool>> checkIfEmailExists(String email);
}
