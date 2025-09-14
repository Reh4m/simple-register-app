import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class DatabaseFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class UserNotFoundFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class UserAlreadyExistsFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class InvalidCredentialsFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class WeakPasswordFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class PasswordMismatchFailure extends Failure {
  @override
  List<Object?> get props => [];
}
