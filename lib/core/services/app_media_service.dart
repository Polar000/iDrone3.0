import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  static const String _prefPrefix = 'idrone_app_media_';

  Future<void> loadMediaFromSupabase() async {
    // 1. Load local cache first from SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      for (final key in prefs.getKeys()) {
        if (key.startsWith(_prefPrefix)) {
          final assetKey = key.substring(_prefPrefix.length);
          final value = prefs.getString(key);
          if (value != null && value.isNotEmpty) {
            _mediaRegistry[assetKey] = value;
          }
        }
      }
      notifyListeners();
    } catch (_) {}

    // 2. Load remote records from Supabase app_media table
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('app_media')
          .select('name, url, active')
          .eq('active', true);

      final prefs = await SharedPreferences.getInstance();
      for (final item in response as List) {
        final name = item['name']?.toString();
        final url = item['url']?.toString();
        if (name != null && name.isNotEmpty && url != null && url.isNotEmpty) {
          _mediaRegistry[name] = url;
          await prefs.setString('$_prefPrefix$name', url);
        }
      }
      notifyListeners();
    } catch (_) {}
  }

  String getMediaUrl(String key, {String fallback = ''}) {
    if (_mediaRegistry.containsKey(key) && _mediaRegistry[key]!.isNotEmpty) {
      return _mediaRegistry[key]!;
    }
    return fallback.isNotEmpty ? fallback : 'assets/images/$key.png';
  }

  Future<void> updateMediaRecord(String key, String urlOrPath) async {
    _mediaRegistry[key] = urlOrPath;
    notifyListeners();

    // Persist locally in SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_prefPrefix$key', urlOrPath);
    } catch (_) {}

    // Persist in Supabase app_media table
    try {
      final supabase = Supabase.instance.client;

      String category = 'general';
      if (key.contains('logo') || key.contains('splash')) category = 'hero';
      if (key.contains('hero')) category = 'hero';
      if (key.contains('service')) category = 'service';
      if (key.contains('crop')) category = 'crop';

      // Check if record exists
      final existing = await supabase.from('app_media').select('id').eq('name', key).limit(1);

      if (existing is List && existing.isNotEmpty) {
        final recordId = existing.first['id'];
        await supabase.from('app_media').update({
          'url': urlOrPath,
          'storage_path': urlOrPath.startsWith('data:') ? 'base64_data_url' : urlOrPath,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', recordId);
      } else {
        await supabase.from('app_media').insert({
          'name': key,
          'category': category,
          'url': urlOrPath,
          'storage_path': urlOrPath.startsWith('data:') ? 'base64_data_url' : urlOrPath,
          'active': true,
        });
      }
    } catch (_) {}
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
