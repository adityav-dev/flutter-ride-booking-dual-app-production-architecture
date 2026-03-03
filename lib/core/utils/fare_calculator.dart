class FareCalculator {
  // Constants for calculation (can be dynamic via remote config)
  static const double baseFare = 50.0;
  static const double perKmRate = 12.0;
  static const double perMinuteRate = 2.0;
  static const double platformCommissionPct = 0.20; // 20%

  double calculateFare({
    required double distanceInKm,
    required int durationInMinutes,
    double surgeMultiplier = 1.0,
  }) {
    double subTotal = baseFare + (distanceInKm * perKmRate) + (durationInMinutes * perMinuteRate);
    double totalFare = subTotal * surgeMultiplier;
    
    return double.parse(totalFare.toStringAsFixed(2));
  }

  Map<String, double> calculateSplit(double totalFare) {
    double platformCommission = totalFare * platformCommissionPct;
    double driverEarnings = totalFare - platformCommission;

    return {
      'platform_commission': double.parse(platformCommission.toStringAsFixed(2)),
      'driver_earnings': double.parse(driverEarnings.toStringAsFixed(2)),
    };
  }

  double calculateSurgeMultiplier(int activeRiders, int availableDrivers) {
    if (availableDrivers == 0) return 2.0;
    
    double ratio = activeRiders / availableDrivers;
    if (ratio > 2.0) return 1.5;
    if (ratio > 5.0) return 2.0;
    
    return 1.0;
  }
}
