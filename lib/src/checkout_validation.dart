String? validateName(String? value) =>
    value == null || value.trim().length < 2 ? 'Enter your name' : null;

String? validateEmail(String? value) =>
    value == null ||
            !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.trim())
        ? 'Enter a valid email address'
        : null;

String? validateAddress(String? value) => value == null || value.trim().length < 8
    ? 'Enter a complete address'
    : null;

String? validatePostalCode(String? value) =>
    value == null || !RegExp(r'^\d{5,6}$').hasMatch(value.trim())
        ? 'Enter a 5 or 6 digit postal code'
        : null;
