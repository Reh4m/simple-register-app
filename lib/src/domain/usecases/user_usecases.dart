import 'package:dartz/dartz.dart';
import 'package:simple_register_app/src/core/errors/failures.dart';
import 'package:simple_register_app/src/domain/entities/user_entity.dart';
import 'package:simple_register_app/src/domain/repositories/user_repository.dart';

class GetUserById {
  final UserRepository repository;

  GetUserById({required this.repository});

  Future<Either<Failure, UserEntity>> call(int userId) async {
    if (userId <= 0) {
      return Left(ValidationFailure(message: 'ID de usuario inválido'));
    }

    return await repository.getUserById(userId);
  }
}

class GetUserByEmail {
  final UserRepository repository;

  GetUserByEmail({required this.repository});

  Future<Either<Failure, UserEntity>> call(String email) async {
    if (email.isEmpty) {
      return Left(
        ValidationFailure(message: 'El correo electrónico es requerido'),
      );
    }

    return await repository.getUserByEmail(email);
  }
}
