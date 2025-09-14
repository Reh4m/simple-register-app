import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [];
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure({required super.message});
}

class UserAlreadyExistsFailure extends Failure {
  const UserAlreadyExistsFailure({required super.message});
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure({required super.message});
}

class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure({required super.message});
}

class PasswordMismatchFailure extends Failure {
  const PasswordMismatchFailure({required super.message});
}
