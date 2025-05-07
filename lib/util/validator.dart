class Validators {
  static String? validateEmail(String value) {
    if (value.isEmpty) return 'Email cannot be empty';
    if (!RegExp(r'^.+@.+\..+$').hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) return 'Password cannot be empty';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? validatePhone(String value) {
    if (value.isEmpty) return 'Phone number cannot be empty';
    if (value.length < 10) return 'Enter a valid phone number';
    return null;
  }
}
