import 'package:dartz/dartz.dart';
import 'package:simple_register_app/src/core/errors/exceptions.dart';
import 'package:simple_register_app/src/core/errors/failures.dart';
import 'package:simple_register_app/src/data/models/sign_in_model.dart';
import 'package:simple_register_app/src/data/models/sign_up_model.dart';
import 'package:simple_register_app/src/data/sources/local/daos/authentication_dao.dart';
import 'package:simple_register_app/src/domain/entities/sign_in_entity.dart';
import 'package:simple_register_app/src/domain/entities/sign_up_entity.dart';
import 'package:simple_register_app/src/domain/entities/user_entity.dart';
import 'package:simple_register_app/src/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationDao _authenticationDao;

  AuthenticationRepositoryImpl(this._authenticationDao);

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
    SignInEntity signInData,
  ) async {
    try {
      final model = SignInModel(
        email: signInData.email,
        password: signInData.password,
      );

      final user = await _authenticationDao.signInUser(model);

      return Right(user.toEntity());
    } on UserNotFoundException catch (e) {
      return Left(UserNotFoundFailure(message: e.message));
    } on InvalidCredentialsException catch (e) {
      return Left(InvalidCredentialsFailure(message: e.message));
    } on LocalDatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(
        DatabaseFailure(message: 'Unexpected database error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword(
    SignUpEntity signUpData,
  ) async {
    try {
      final model = SignUpModel(
        name: signUpData.name,
        email: signUpData.email,
        password: signUpData.password,
        confirmPassword: signUpData.confirmPassword,
      );

      final user = await _authenticationDao.signUpUser(model);

      return Right(user.toEntity());
    } on UserAlreadyExistsException catch (e) {
      return Left(UserAlreadyExistsFailure(message: e.message));
    } on LocalDatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(
        DatabaseFailure(message: 'Unexpected database error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> checkIfEmailExists(String email) async {
    try {
      final exists = await _authenticationDao.checkIfEmailExists(email);

      return Right(exists);
    } on LocalDatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(
        DatabaseFailure(message: 'Unexpected database error: ${e.toString()}'),
      );
    }
  }
}
