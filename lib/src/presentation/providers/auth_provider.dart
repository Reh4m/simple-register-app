import 'package:flutter/foundation.dart';
import 'package:simple_register_app/src/core/di/index.dart';
import 'package:simple_register_app/src/core/session/session_manager.dart';
import 'package:simple_register_app/src/domain/entities/sign_in_entity.dart';
import 'package:simple_register_app/src/domain/entities/sign_up_entity.dart';
import 'package:simple_register_app/src/domain/entities/user_entity.dart';
import 'package:simple_register_app/src/domain/usecases/authentication_usecases.dart';
import 'package:simple_register_app/src/domain/usecases/user_usecases.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final SignInUseCase _signInUser = sl<SignInUseCase>();
  final SignUpUseCase _signUpUser = sl<SignUpUseCase>();
  final GetUserById _getUserById = sl<GetUserById>();
  final UpdatePictureImagePath _setUserPicturePath =
      sl<UpdatePictureImagePath>();

  final SessionManager _sessionManager = sl<SessionManager>();

  UserEntity? _currentUser;
  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;
  // Indicates whether the user session has been initialized
  bool _isInitialized = false;

  UserEntity? get currentUser => _currentUser;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  AuthStatus get status => _status;
  bool get isLoading => _status == AuthStatus.loading;
  String? get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;

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

  Future<void> signIn({
    required SignInEntity data,
    required bool rememberMe,
  }) async {
    try {
      _setStatus(AuthStatus.loading);

      final result = await _signInUser(
        data.copyWith(email: data.email.trim().toLowerCase()),
      );

      result.fold((failure) => _setError(failure.message), (user) async {
        if (user.id == null) {
          _setError('Invalid user data received.');
          return;
        }

        final saveSessionSuccess = await _sessionManager.saveUserSession(
          userId: user.id!,
          email: user.email,
          rememberMe: rememberMe,
        );

        if (!saveSessionSuccess) {
          _setError('Failed to save user session.');
          return;
        }

        _setUser(user);
      });
    } catch (e) {
      _setError('Unexpected database error: ${e.toString()}');
    }
  }

  Future<void> signUp({
    required SignUpEntity data,
    required bool rememberMe,
  }) async {
    try {
      _setStatus(AuthStatus.loading);

      final result = await _signUpUser(
        data.copyWith(
          name: data.name.trim(),
          email: data.email.trim().toLowerCase(),
        ),
      );

      result.fold((failure) => _setError(failure.message), (user) async {
        if (user.id == null) {
          _setError('Invalid user data received.');
          return;
        }

        final saveSessionSuccess = await _sessionManager.saveUserSession(
          userId: user.id!,
          email: user.email,
          rememberMe: rememberMe,
        );

        if (!saveSessionSuccess) {
          _setError('Failed to save user session.');
          return;
        }

        _setUser(user);
      });
    } catch (e) {
      _setError('Unexpected database error: ${e.toString()}');
    }
  }

  Future<void> setUserPicturePath(String path) async {
    if (_currentUser == null || _currentUser!.id == null) {
      _setError('No authenticated user to update picture path.');
      return;
    }

    try {
      _setStatus(AuthStatus.loading);

      final result = await _setUserPicturePath(_currentUser!.id!, path);

      result.fold((failure) => _setError(failure.message), (success) {
        if (success) {
          _currentUser = _currentUser!.copyWith(pictureImagePath: path);
          _setStatus(AuthStatus.authenticated);
        } else {
          _setError('Failed to update picture path.');
        }
      });
    } catch (e) {
      _setError('Unexpected error: ${e.toString()}');
    }
  }

  void signOut() async {
    try {
      _setStatus(AuthStatus.loading);

      final result = await _sessionManager.clearSession();

      if (!result) {
        _setError('Failed to clear user session.');
        return;
      }

      _currentUser = null;
      _errorMessage = null;
      _setStatus(AuthStatus.unauthenticated);
    } catch (e) {
      _setError('Error signing out: ${e.toString()}');
    }
  }

  void initialize() async {
    if (_isInitialized) return;

    try {
      _setStatus(AuthStatus.loading);

      if (!_sessionManager.isSessionValid(expirationDays: 30)) {
        if (_sessionManager.isLoggedIn) {
          _sessionManager.clearSession();
        }

        _setStatus(AuthStatus.unauthenticated);

        return;
      }

      final userId = _sessionManager.userId;

      if (userId == null) {
        _sessionManager.clearSession();
        _setStatus(AuthStatus.unauthenticated);
        return;
      }

      final currentUser = await _getUserById(userId);

      currentUser.fold(
        (failure) {
          _sessionManager.clearSession();
          _setStatus(AuthStatus.unauthenticated);
        },
        (user) {
          _setUser(user);

          _sessionManager.updateLastActivity();
        },
      );
    } catch (e) {
      _setError('Error initializing session: ${e.toString()}');

      _setStatus(AuthStatus.unauthenticated);
    } finally {
      _isInitialized = true;
    }
  }

  bool checkSessionValidity() {
    return _sessionManager.isSessionValid();
  }
}
