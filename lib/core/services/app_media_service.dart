import 'dart:convert';
import 'package:flutter/material.dart';

class AppMediaService extends ChangeNotifier {
  static final AppMediaService instance = AppMediaService._internal();

  factory AppMediaService() {
    return instance;
  }

  AppMediaService._internal();

  // Database Media Records Map (key -> image URL, base64 data URL or storage path)
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

  /// Centralized, safe image builder widget for rendering Data URLs, Network URLs, or Asset paths.
  static Widget buildImageWidget(
    String keyOrUrl, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? errorWidget,
  }) {
    final service = AppMediaService.instance;
    final resolved = keyOrUrl.contains('/') || keyOrUrl.startsWith('data:')
        ? keyOrUrl
        : service.getMediaUrl(keyOrUrl);

    final defaultFallback = errorWidget ??
        Container(
          width: width,
          height: height,
          color: const Color(0xFFE8F4EC),
          child: const Icon(Icons.image_outlined, color: Color(0xFF159A6B)),
        );

    // 1. Base64 Data URL
    if (resolved.startsWith('data:image')) {
      try {
        final base64Str = resolved.split(',').last;
        final bytes = base64Decode(base64Str);
        return Image.memory(
          bytes,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (c, e, s) => defaultFallback,
        );
      } catch (_) {
        return defaultFallback;
      }
    }

    // 2. Remote Network URL
    if (resolved.startsWith('http://') || resolved.startsWith('https://')) {
      return Image.network(
        resolved,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (c, e, s) => defaultFallback,
      );
    }

    // 3. Local Asset Path
    return Image.asset(
      resolved,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (c, e, s) => defaultFallback,
    );
  }
}
