String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Name cannot be empty';
  }
  if (RegExp(r'[0-9]').hasMatch(value)) {
    return 'Name should not contain numbers';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) return 'Email cannot be empty';
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'Enter a valid email';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Password cannot be empty';
  if (value.length < 6) return 'Password must be at least 6 characters long';
  return null;
}
