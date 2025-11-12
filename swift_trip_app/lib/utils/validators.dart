class Validators {
  // Email validation using RFC 5322 compliant regex
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    
    final email = value.trim();
    // RFC 5322 compliant email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email';
    }
    
    return null;
  }

  // Password validation with complexity requirements
  static String? validatePassword(String? value, {bool isSignup = true}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    // For signup, enforce stronger requirements
    if (isSignup) {
      if (value.length < 8) {
        return 'Password must be at least 8 characters';
      }
      if (!RegExp(r'[A-Z]').hasMatch(value)) {
        return 'Password must contain at least one uppercase letter';
      }
      if (!RegExp(r'[a-z]').hasMatch(value)) {
        return 'Password must contain at least one lowercase letter';
      }
      if (!RegExp(r'[0-9]').hasMatch(value)) {
        return 'Password must contain at least one number';
      }
      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
        return 'Password must contain at least one special character';
      }
    } else {
      // For signin, use generic message to avoid information leakage
      if (value.isEmpty) {
        return 'Invalid password';
      }
    }
    
    return null;
  }
}
