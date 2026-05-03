class Validators {
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Title is required';
    }
    if (value.trim().length < 3) {
      return 'Title must be at least 3 characters';
    }
    if (value.length > 200) {
      return 'Title must be less than 200 characters';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value != null && value.length > 2000) {
      return 'Description must be less than 2000 characters';
    }
    return null;
  }

  static String? validateChecklistItem(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Task is required';
    }
    if (value.length > 500) {
      return 'Task must be less than 500 characters';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
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
}
