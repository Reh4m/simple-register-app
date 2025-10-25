import 'package:simple_register_app/src/core/errors/exceptions.dart';
import 'package:simple_register_app/src/data/models/sign_in_model.dart';
import 'package:simple_register_app/src/data/models/sign_up_model.dart';
import 'package:simple_register_app/src/data/models/user_model.dart';
import 'package:simple_register_app/src/data/sources/local/daos/user_dao.dart';

class AuthenticationDao {
  final UserDao _userDao;

  AuthenticationDao(this._userDao);

  Future<UserModel> signInUser(SignInModel data) async {
    try {
      final user = await _userDao.fetchByEmail(data.email);

      if (user.password != data.password) {
        throw const InvalidCredentialsException(
          message: 'Invalid email or password',
        );
      }

      return user;
    } catch (e) {
      if (e is UserNotFoundException || e is InvalidCredentialsException) {
        rethrow;
      }

      throw LocalDatabaseException(
        message: 'Error signing in: ${e.toString()}',
      );
    }
  }

  Future<UserModel> signUpUser(SignUpModel data) async {
    try {
      final now = DateTime.now();

      final newUser = UserModel(
        name: data.name,
        email: data.email,
        password: data.password,
        pictureImagePath: data.pictureImagePath,
        createdAt: now,
        updatedAt: now,
      );

      final userId = await _userDao.insert(newUser);

      return newUser.copyWith(id: userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkIfEmailExists(String email) async {
    try {
      await _userDao.fetchByEmail(email);

      return true;
    } on UserNotFoundException {
      return false;
    } catch (e) {
      throw LocalDatabaseException(
        message: 'Error verifying email address: ${e.toString()}',
      );
    }
  }
}
