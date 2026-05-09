class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null; // valid
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^[0-9]{11}$').hasMatch(value)) {
      return 'Enter a valid 11-digit phone number';
    }
    return null;
  }

  /// Matches server rules: omit or blank is fine; otherwise must be parseable http(s).
  static String? validateOptionalHttpUrl(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final uri = Uri.tryParse(value.trim());
    if (uri == null || !uri.hasScheme) {
      return 'Enter a valid URL';
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return 'URL must start with http or https';
    }
    return null;
  }

  /// Optional phone: blank ok, otherwise same digit rule as [validatePhone].
  static String? validateOptionalPhone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final digits = value.trim();
    if (!RegExp(r'^[0-9]{11}$').hasMatch(digits)) {
      return 'Enter a valid 11-digit phone number';
    }
    return null;
  }
}
