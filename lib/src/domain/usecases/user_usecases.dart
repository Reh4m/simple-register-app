import 'package:dartz/dartz.dart';
import 'package:simple_register_app/src/core/errors/failures.dart';
import 'package:simple_register_app/src/domain/entities/user_entity.dart';
import 'package:simple_register_app/src/domain/repositories/user_repository.dart';

class GetUserById {
  final UserRepository _repository;

  GetUserById(this._repository);

  Future<Either<Failure, UserEntity>> call(int userId) async {
    if (userId <= 0) {
      return const Left(ValidationFailure(message: 'ID de usuario inválido'));
    }

    return await _repository.getUserById(userId);
  }
}

class GetUserByEmail {
  final UserRepository _repository;

  GetUserByEmail(this._repository);

  Future<Either<Failure, UserEntity>> call(String email) async {
    if (email.isEmpty) {
      return const Left(
        ValidationFailure(message: 'El correo electrónico es requerido'),
      );
    }

    return await _repository.getUserByEmail(email);
  }
}
