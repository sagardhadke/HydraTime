extension IntExtension on int {
  // Time conversions
  Duration get milliseconds => Duration(milliseconds: this);
  Duration get seconds => Duration(seconds: this);
  Duration get minutes => Duration(minutes: this);
  Duration get hours => Duration(hours: this);
  Duration get days => Duration(days: this);

  // Formatting
  String get ordinal {
    if (this >= 11 && this <= 13) return '${this}th';
    switch (this % 10) {
      case 1:
        return '${this}st';
      case 2:
        return '${this}nd';
      case 3:
        return '${this}rd';
      default:
        return '${this}th';
    }
  }

  // Range check
  bool isBetween(int min, int max) => this >= min && this <= max;
}

extension DoubleExtension on double {
  // Rounding
  double roundToDecimal(int places) {
    final mod = 10.0 * places;
    return (this * mod).round().toDouble() / mod;
  }

  // Formatting
  String toStringWithDecimal(int decimals) {
    return toStringAsFixed(decimals);
  }

  // Percentage
  String toPercentage({int decimals = 0}) {
    return '${(this * 100).toStringAsFixed(decimals)}%';
  }

  // Range check
  bool isBetween(double min, double max) => this >= min && this <= max;
}