class WaterCalculator {
  /// Calculate daily water intake goal in milliliters
  /// Based on weight, activity level, and climate
  static double calculateDailyGoal({
    required double weightKg,
    required String activityLevel,
    required String climate,
  }) {
    // Base calculation: 30-35ml per kg of body weight
    double baseWater = weightKg * 33;

    // Activity level multiplier
    double activityMultiplier = _getActivityMultiplier(activityLevel);
    baseWater *= activityMultiplier;

    // Climate adjustment
    double climateAdjustment = _getClimateAdjustment(climate);
    baseWater += climateAdjustment;

    // Round to nearest 100ml
    return (baseWater / 100).round() * 100;
  }

  static double _getActivityMultiplier(String activityLevel) {
    switch (activityLevel.toLowerCase()) {
      case 'sedentary':
        return 1.0;
      case 'low active':
        return 1.1;
      case 'active':
        return 1.2;
      case 'very active':
        return 1.3;
      default:
        return 1.0;
    }
  }

  static double _getClimateAdjustment(String climate) {
    switch (climate.toLowerCase()) {
      case 'hot':
        return 500; // Add 500ml for hot climate
      case 'tropical':
        return 400; // Add 400ml for tropical
      case 'cold':
        return 0; // No adjustment for cold
      default:
        return 0;
    }
  }

  /// Convert milliliters to liters
  static double mlToLiters(double ml) {
    return ml / 1000;
  }

  /// Convert liters to milliliters
  static double litersToMl(double liters) {
    return liters * 1000;
  }

  /// Calculate percentage of goal completed
  static double calculatePercentage(double current, double target) {
    if (target == 0) return 0;
    return (current / target * 100).clamp(0, 100);
  }

  /// Calculate remaining water needed
  static double calculateRemaining(double current, double target) {
    final remaining = target - current;
    return remaining > 0 ? remaining : 0;
  }
}