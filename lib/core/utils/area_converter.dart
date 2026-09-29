class AreaConverter {
  /// Standard Guatemalan Manzana conversion in square meters (m²)
  static const double squareMetersPerManzana = 6988.96;

  /// Standard Hectare conversion in square meters (m²)
  static const double squareMetersPerHectare = 10000.0;

  static double squareMetersToManzanas(double squareMeters) {
    if (squareMeters <= 0) return 0.0;
    return squareMeters / squareMetersPerManzana;
  }

  static double squareMetersToHectares(double squareMeters) {
    if (squareMeters <= 0) return 0.0;
    return squareMeters / squareMetersPerHectare;
  }

  static double manzanasToSquareMeters(double manzanas) {
    if (manzanas <= 0) return 0.0;
    return manzanas * squareMetersPerManzana;
  }

  static double hectaresToSquareMeters(double hectares) {
    if (hectares <= 0) return 0.0;
    return hectares * squareMetersPerHectare;
  }

  static double convert({
    required double areaM2,
    required String targetUnit,
  }) {
    if (targetUnit.toLowerCase() == 'hectáreas' || targetUnit.toLowerCase() == 'hectares' || targetUnit.toLowerCase() == 'ha') {
      return squareMetersToHectares(areaM2);
    }
    return squareMetersToManzanas(areaM2);
  }
}
