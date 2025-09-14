import 'package:dartz/dartz.dart';
import 'package:simple_register_app/src/core/errors/failures.dart';
import 'package:simple_register_app/src/domain/entities/sign_in_entity.dart';
import 'package:simple_register_app/src/domain/entities/sign_up_entity.dart';
import 'package:simple_register_app/src/domain/entities/user_entity.dart';
import 'package:simple_register_app/src/domain/repositories/authentication_repository.dart';

class SignInUseCase {
  final AuthenticationRepository repository;

  SignInUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(SignInEntity signInData) async {
    return await repository.signInWithEmailAndPassword(signInData);
  }
}

class SignUpUseCase {
  final AuthenticationRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(SignUpEntity signUpData) async {
    return await repository.signUpWithEmailAndPassword(signUpData);
  }
}
