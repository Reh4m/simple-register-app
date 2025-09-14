import 'package:dartz/dartz.dart';
import 'package:simple_register_app/src/core/errors/failures.dart';
import 'package:simple_register_app/src/core/utils/validators.dart';
import 'package:simple_register_app/src/domain/entities/sign_in_entity.dart';
import 'package:simple_register_app/src/domain/entities/sign_up_entity.dart';
import 'package:simple_register_app/src/domain/entities/user_entity.dart';
import 'package:simple_register_app/src/domain/repositories/authentication_repository.dart';

class SignInUseCase {
  final AuthenticationRepository repository;

  SignInUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(SignInEntity signInData) async {
    // Validate email and password before proceeding
    final emailVerification = Validators.validateEmail(signInData.email);

    if (emailVerification != null) {
      return Left(ValidationFailure(message: emailVerification));
    }

    final passwordValidation = Validators.validatePassword(signInData.password);

    if (passwordValidation != null) {
      return Left(ValidationFailure(message: passwordValidation));
    }

    return await repository.signInWithEmailAndPassword(signInData);
  }
}

class SignUpUseCase {
  final AuthenticationRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(SignUpEntity signUpData) async {
    // Validate name, email, password, and confirm password before proceeding
    final nameValidation = Validators.validateName(signUpData.name);

    if (nameValidation != null) {
      return Left(ValidationFailure(message: nameValidation));
    }

    final emailValidation = Validators.validateEmail(signUpData.email);

    if (emailValidation != null) {
      return Left(ValidationFailure(message: emailValidation));
    }

    final passwordValidation = Validators.validatePassword(signUpData.password);

    if (passwordValidation != null) {
      return Left(ValidationFailure(message: passwordValidation));
    }

    final confirmPasswordValidation = Validators.validateConfirmPassword(
      signUpData.password,
      signUpData.confirmPassword,
    );

    if (confirmPasswordValidation != null) {
      return Left(ValidationFailure(message: confirmPasswordValidation));
    }

    final emailExists = await repository.checkIfEmailExists(signUpData.email);

    return emailExists.fold((failure) => Left(failure), (exists) async {
      if (exists) {
        return Left(
          UserAlreadyExistsFailure(
            message: 'Ya existe un usuario con este correo electrónico',
          ),
        );
      }

      return await repository.signUpWithEmailAndPassword(signUpData);
    });
  }
}
