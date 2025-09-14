import 'package:dartz/dartz.dart';
import 'package:simple_register_app/src/core/errors/failures.dart';
import 'package:simple_register_app/src/domain/entities/sign_in_entity.dart';
import 'package:simple_register_app/src/domain/entities/sign_up_entity.dart';
import 'package:simple_register_app/src/domain/entities/user_entity.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
    SignInEntity signInData,
  );

  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword(
    SignUpEntity signUpData,
  );
}
