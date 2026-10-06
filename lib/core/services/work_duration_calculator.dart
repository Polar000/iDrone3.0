import '../utils/area_converter.dart';

class WorkDurationResult {
  final double flightMinutes;
  final int batterySwaps;
  final double setupMinutes;
  final double totalMinutes;

  const WorkDurationResult({
    required this.flightMinutes,
    required this.batterySwaps,
    required this.setupMinutes,
    required this.totalMinutes,
  });

  String get formattedTotalTime {
    final hours = totalMinutes ~/ 60;
    final mins = (totalMinutes % 60).round();
    if (hours > 0) {
      return '${hours}h ${mins}m';
    }
    return '${mins} min';
  }
}

class WorkDurationCalculator {
  static WorkDurationResult calculateDuration({
    required double areaM2,
    required String serviceType,
  }) {
    if (areaM2 <= 0) {
      return const WorkDurationResult(
        flightMinutes: 0,
        batterySwaps: 0,
        setupMinutes: 0,
        totalMinutes: 0,
      );
    }

    final manzanas = AreaConverter.squareMetersToManzanas(areaM2);

    double minutesPerManzana;
    switch (serviceType.toLowerCase()) {
      case 'fumigation':
      case 'fumigación':
        minutesPerManzana = 1.5;
        break;
      case 'fertilization':
      case 'fertilización':
      case 'fertilización foliar':
        minutesPerManzana = 2.0;
        break;
      case 'spreading':
      case 'esparcimiento':
        minutesPerManzana = 2.5;
        break;
      case 'monitoring':
      case 'monitoreo':
      default:
        minutesPerManzana = 1.0;
        break;
    }

    final flightMinutes = (manzanas * minutesPerManzana).clamp(5.0, 480.0);
    // 1 battery swap every 3.5 manzanas or ~15 min of flight
    final batteryCount = (manzanas / 3.5).ceil().clamp(1, 20);
    final batterySwaps = batteryCount > 1 ? batteryCount - 1 : 0;
    final swapMinutes = batterySwaps * 5.0; // 5 min per battery swap
    const setupMinutes = 15.0; // 15 min setup & pre-flight calibration

    final totalMinutes = flightMinutes + swapMinutes + setupMinutes;

    return WorkDurationResult(
      flightMinutes: flightMinutes,
      batterySwaps: batterySwaps,
      setupMinutes: setupMinutes,
      totalMinutes: totalMinutes,
    );
  }
}
