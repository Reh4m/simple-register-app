import 'package:flutter/foundation.dart';
import 'package:simple_register_app/src/core/di/index.dart';
import 'package:simple_register_app/src/domain/entities/sign_in_entity.dart';
import 'package:simple_register_app/src/domain/entities/sign_up_entity.dart';
import 'package:simple_register_app/src/domain/entities/user_entity.dart';
import 'package:simple_register_app/src/domain/usecases/authentication_usecases.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final SignInUseCase _loginUser = sl<SignInUseCase>();
  final SignUpUseCase _registerUser = sl<SignUpUseCase>();

  UserEntity? _currentUser;
  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;

  UserEntity? get currentUser => _currentUser;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;

  void _setUser(UserEntity user) {
    _currentUser = user;
    _setStatus(AuthStatus.authenticated);
  }

  void _setStatus(AuthStatus newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _setStatus(AuthStatus.error);
  }

  void clearError() {
    _errorMessage = null;

    if (_status == AuthStatus.error) {
      _setStatus(
        _currentUser != null
            ? AuthStatus.authenticated
            : AuthStatus.unauthenticated,
      );
    }
  }

  Future<void> signIn(SignInEntity data) async {
    try {
      _setStatus(AuthStatus.loading);

      final result = await _loginUser(
        SignInEntity(
          email: data.email.trim().toLowerCase(),
          password: data.password,
        ),
      );

      result.fold(
        (failure) => _setError(failure.message),
        (user) => _setUser(user),
      );
    } catch (e) {
      _setError('Error inesperado: ${e.toString()}');
    }
  }

  Future<void> signUp(SignUpEntity data) async {
    try {
      _setStatus(AuthStatus.loading);

      final result = await _registerUser(
        SignUpEntity(
          name: data.name.trim(),
          email: data.email.trim().toLowerCase(),
          password: data.password,
          confirmPassword: data.confirmPassword,
          pictureImagePath: data.pictureImagePath,
        ),
      );

      result.fold(
        (failure) => _setError(failure.message),
        (user) => _setUser(user),
      );
    } catch (e) {
      _setError('Error inesperado: ${e.toString()}');
    }
  }

  void signOut() {
    _currentUser = null;
    _errorMessage = null;
    _setStatus(AuthStatus.unauthenticated);
  }

  void initialize() {
    // TODO: Implement persistent login
    _setStatus(AuthStatus.unauthenticated);
  }
}
