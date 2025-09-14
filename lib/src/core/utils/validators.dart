class Validators {
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPassword(String password) {
    // Password should be at least 6 characters long
    return password.length >= 6;
  }

  static bool isValidName(String name) {
    // Name should be at least 2 characters long and only contain letters and spaces
    return RegExp(r'^[a-zA-ZÀ-ÿ\u00f1\u00d1 ]+$').hasMatch(name) &&
        name.trim().length >= 2;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'El correo electrónico es requerido';
    }

    if (!isValidEmail(email)) {
      return 'Ingresa un correo electrónico válido';
    }

    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'La contraseña es requerida';
    }

    if (!isValidPassword(password)) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }

    return null;
  }

  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'El nombre es requerido';
    }

    if (!isValidName(name)) {
      return 'Ingresa un nombre válido (solo letras y espacios)';
    }

    return null;
  }

  static String? validateConfirmPassword(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirma tu contraseña';
    }

    if (password != confirmPassword) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }
}
