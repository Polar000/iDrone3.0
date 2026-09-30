import 'package:flutter/material.dart';

class AppMediaService extends ChangeNotifier {
  static final AppMediaService instance = AppMediaService._internal();

  factory AppMediaService() {
    return instance;
  }

  AppMediaService._internal();

  // Database Media Records Map (key -> image URL or storage path)
  final Map<String, String> _mediaRegistry = {
    'splash_bg': 'assets/images/splash_bg.png',
    'logo_dark': 'assets/images/idrone_logo_dark.png',
    'logo_light': 'assets/images/idrone_logo_light.png',
    'hero_drone': 'assets/images/hero_drone.png',
    'service_fumigation': 'assets/images/service_fumigation.png',
    'service_fertilization': 'assets/images/service_fertilization.png',
    'service_spreading': 'assets/images/service_spreading.png',
    'service_monitoring': 'assets/images/service_monitoring.png',
    'crop_maiz': 'assets/images/crop_maiz.png',
    'crop_melon': 'assets/images/crop_melon.png',
    'crop_cana': 'assets/images/crop_cana.png',
    'crop_pastos': 'assets/images/crop_pastos.png',
    'crop_cafe': 'assets/images/crop_cafe.png',
    'crop_tomate': 'assets/images/crop_tomate.png',
    'crop_hortalizas': 'assets/images/crop_hortalizas.png',
    'crop_otros': 'assets/images/crop_otros.png',
  };

  String getMediaUrl(String key, {String fallback = ''}) {
    if (_mediaRegistry.containsKey(key) && _mediaRegistry[key]!.isNotEmpty) {
      return _mediaRegistry[key]!;
    }
    return fallback.isNotEmpty ? fallback : 'assets/images/$key.png';
  }

  void updateMediaRecord(String key, String urlOrPath) {
    _mediaRegistry[key] = urlOrPath;
    notifyListeners();
  }

  Map<String, String> getAllMedia() => Map.unmodifiable(_mediaRegistry);
}
