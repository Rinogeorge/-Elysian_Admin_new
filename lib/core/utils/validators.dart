class Validators {
  // Email validation
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email is required';
    }

    final trimmedEmail = email.trim();

    // Check for spaces in email
    if (trimmedEmail.contains(' ')) {
      return 'Email cannot contain spaces';
    }

    // Basic email format validation
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(trimmedEmail)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }

    // Check for spaces in password
    if (password.contains(' ')) {
      return 'Password cannot contain spaces';
    }

    return null;
  }

  // Name validation
  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Name is required';
    }

    final trimmedName = name.trim();

    if (trimmedName.length < 2) {
      return 'Name must be at least 2 characters';
    }

    // Check if name contains only spaces
    if (trimmedName.split(' ').where((s) => s.isNotEmpty).isEmpty) {
      return 'Name cannot be only spaces';
    }

    return null;
  }

  // Login validation
  static Map<String, String?> validateLogin({
    required String email,
    required String password,
  }) {
    return {
      'email': validateEmail(email),
      'password': validatePassword(password),
    };
  }

  // Signup validation
  static Map<String, String?> validateSignup({
    required String name,
    required String email,
    required String password,
  }) {
    return {
      'name': validateName(name),
      'email': validateEmail(email),
      'password': validatePassword(password),
    };
  }
}
