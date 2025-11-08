import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyisLoggedIn = 'is_logged_in';
  static const String _keyLoginTimestamp = 'login_timestamp';
  static const String _keyRememberMe = 'remember_me';

  final SharedPreferences _prefs;

  SessionManager(this._prefs);

  int? get userId => _prefs.getInt(_keyUserId);
  String? get userEmail => _prefs.getString(_keyUserEmail);
  bool get isLoggedIn => _prefs.getBool(_keyisLoggedIn) ?? false;
  bool get rememberMe => _prefs.getBool(_keyRememberMe) ?? false;

  Future<bool> saveUserSession({
    required int userId,
    required String email,
    bool rememberMe = true,
  }) async {
    try {
      final loginTimestamp = DateTime.now().millisecondsSinceEpoch;

      await Future.wait([
        _prefs.setInt(_keyUserId, userId),
        _prefs.setString(_keyUserEmail, email),
        _prefs.setBool(_keyisLoggedIn, true),
        _prefs.setInt(_keyLoginTimestamp, loginTimestamp),
        _prefs.setBool(_keyRememberMe, rememberMe),
      ]);

      return true;
    } catch (_) {
      return false;
    }
  }

  DateTime? getLoginTimestamp() {
    final timestamp = _prefs.getInt(_keyLoginTimestamp);

    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  bool isSessionExpired({int expirationDays = 30}) {
    final loginTime = getLoginTimestamp();

    if (loginTime == null) return true;

    final exprirationTime = loginTime.add(Duration(days: expirationDays));

    return DateTime.now().isAfter(exprirationTime);
  }

  Future<bool> updateLastActivity() async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      return await _prefs.setInt(_keyLoginTimestamp, timestamp);
    } catch (_) {
      return false;
    }
  }

  Future<bool> clearSession() async {
    try {
      await Future.wait([
        _prefs.remove(_keyUserId),
        _prefs.remove(_keyUserEmail),
        _prefs.setBool(_keyisLoggedIn, false),
        _prefs.remove(_keyLoginTimestamp),
      ]);

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> clearAllSession() async {
    try {
      await _prefs.clear();

      return true;
    } catch (_) {
      return false;
    }
  }

  bool isSessionValid({int expirationDays = 30}) {
    if (!isLoggedIn ||
        userId == null ||
        isSessionExpired(expirationDays: expirationDays)) {
      return false;
    }

    return true;
  }

  Map<String, dynamic> getSessionData() {
    return {
      'userId': userId,
      'userEmail': userEmail,
      'isLoggedIn': isLoggedIn,
      'loginTimestamp': getLoginTimestamp()?.toIso8601String(),
      'rememberMe': rememberMe,
      'isExpired': isSessionExpired(),
      'isValid': isSessionValid(),
    };
  }
}
