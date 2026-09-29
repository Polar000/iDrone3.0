import '../utils/area_converter.dart';

class QuoteCalculation {
  final double areaM2;
  final double areaManzanas;
  final double areaHectares;
  final double pricePerManzana;
  final double subtotal;
  final double travelFee;
  final double discount;
  final double total;
  final double depositPercentage;
  final double depositAmount;
  final double balanceAmount;

  QuoteCalculation({
    required this.areaM2,
    required this.areaManzanas,
    required this.areaHectares,
    required this.pricePerManzana,
    required this.subtotal,
    required this.travelFee,
    required this.discount,
    required this.total,
    required this.depositPercentage,
    required this.depositAmount,
    required this.balanceAmount,
  });
}

class PricingEngineService {
  static const double defaultPricePerManzana = 150.0;
  static const double defaultTravelFee = 100.0;
  static const double defaultDepositPercentage = 25.0;

  static QuoteCalculation calculateQuote({
    required double areaM2,
    double pricePerManzana = defaultPricePerManzana,
    double travelFee = defaultTravelFee,
    double discount = 0.0,
    double depositPercentage = defaultDepositPercentage,
  }) {
    final areaManzanas = AreaConverter.squareMetersToManzanas(areaM2);
    final areaHectares = AreaConverter.squareMetersToHectares(areaM2);

    final subtotal = areaManzanas * pricePerManzana;
    final total = (subtotal + travelFee - discount).clamp(0.0, double.infinity);

    final depositAmount = total * (depositPercentage / 100.0);
    final balanceAmount = total - depositAmount;

    return QuoteCalculation(
      areaM2: areaM2,
      areaManzanas: areaManzanas,
      areaHectares: areaHectares,
      pricePerManzana: pricePerManzana,
      subtotal: subtotal,
      travelFee: travelFee,
      discount: discount,
      total: total,
      depositPercentage: depositPercentage,
      depositAmount: depositAmount,
      balanceAmount: balanceAmount,
    );
  }
}
