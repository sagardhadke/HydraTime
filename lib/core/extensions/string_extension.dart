extension StringExtension on String {
  // Capitalization
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String get capitalizeFirst {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  // Validation
  bool get isEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  bool get isAlphabetic {
    final alphabeticRegex = RegExp(r'^[a-zA-Z]+$');
    return alphabeticRegex.hasMatch(this);
  }

  bool get isAlphanumeric {
    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
    return alphanumericRegex.hasMatch(this);
  }

  // Trimming
  String get removeSpaces => replaceAll(' ', '');
  String get removeExtraSpaces => replaceAll(RegExp(r'\s+'), ' ').trim();

  // Parsing
  int? get toInt => int.tryParse(this);
  double? get toDouble => double.tryParse(this);
  bool get toBool => toLowerCase() == 'true';

  // Truncate
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }

  // Check empty
  bool get isEmptyOrNull => trim().isEmpty;
  bool get isNotEmptyOrNull => trim().isNotEmpty;
}