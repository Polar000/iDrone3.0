import 'package:flutter_test/flutter_test.dart';
import 'package:idrone/core/utils/area_converter.dart';
import 'package:idrone/core/services/pricing_engine.dart';

void main() {
  group('AreaConverter Unit Tests', () {
    test('1 manzana conversion to m²', () {
      const double m2 = 6988.96;
      final double mz = AreaConverter.squareMetersToManzanas(m2);
      expect(mz, closeTo(1.0, 0.0001));
    });

    test('1 hectare conversion to m²', () {
      const double m2 = 10000.0;
      final double ha = AreaConverter.squareMetersToHectares(m2);
      expect(ha, closeTo(1.0, 0.0001));
    });

    test('12.60 manzanas to m² and back', () {
      const double originalMz = 12.60;
      final double m2 = AreaConverter.manzanasToSquareMeters(originalMz);
      final double convertedMz = AreaConverter.squareMetersToManzanas(m2);
      expect(convertedMz, closeTo(originalMz, 0.0001));
    });
  });

  group('PricingEngineService Unit Tests', () {
    test('12.60 manzanas quote calculation (Q150/mz + Q100 travel)', () {
      const double areaM2 = 88060.896;
      final quote = PricingEngineService.calculateQuote(
        areaM2: areaM2,
        pricePerManzana: 150.0,
        travelFee: 100.0,
        discount: 0.0,
        depositPercentage: 25.0,
      );

      expect(quote.areaManzanas, closeTo(12.60, 0.01));
      expect(quote.subtotal, closeTo(1890.00, 0.50));
      expect(quote.travelFee, equals(100.00));
      expect(quote.total, closeTo(1990.00, 0.50));
      expect(quote.depositAmount, closeTo(497.50, 0.50));
      expect(quote.balanceAmount, closeTo(1492.50, 0.50));
    });

    test('Zero area returns zero totals', () {
      final quote = PricingEngineService.calculateQuote(
        areaM2: 0.0,
        pricePerManzana: 150.0,
        travelFee: 0.0,
      );

      expect(quote.total, equals(0.0));
      expect(quote.depositAmount, equals(0.0));
      expect(quote.balanceAmount, equals(0.0));
    });
  });
}
