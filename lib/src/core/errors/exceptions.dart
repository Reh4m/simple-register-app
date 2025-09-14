abstract class Exception {}

class LocalDatabaseException implements Exception {
  final String message;
  const LocalDatabaseException({required this.message});

  @override
  String toString() => 'DatabaseException: $message';
}

class ValidationException implements Exception {
  final String message;
  const ValidationException({required this.message});

  @override
  String toString() => 'ValidationException: $message';
}

class UserNotFoundException implements Exception {
  final String message;
  const UserNotFoundException({required this.message});

  @override
  String toString() => 'UserNotFoundException: $message';
}

class UserAlreadyExistsException implements Exception {
  final String message;
  const UserAlreadyExistsException({required this.message});

  @override
  String toString() => 'UserAlreadyExistsException: $message';
}

class InvalidCredentialsException implements Exception {
  final String message;
  const InvalidCredentialsException({required this.message});

  @override
  String toString() => 'InvalidCredentialsException: $message';
}

class WeakPasswordException implements Exception {
  final String message;
  const WeakPasswordException({required this.message});

  @override
  String toString() => 'WeakPasswordException: $message';
}

class PasswordMismatchException implements Exception {
  final String message;
  const PasswordMismatchException({required this.message});

  @override
  String toString() => 'PasswordMismatchException: $message';
}
