import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized & Secure API Configuration Manager for iDrone.
///
/// Automatically reads variables from `.env` file via [dotenv]
/// with fallback to `--dart-define` / [String.fromEnvironment].
class AppApiConfig {
  AppApiConfig._();

  // Helper to resolve key from dotenv or String.fromEnvironment or defaultValue
  static String _getValue(String key, String defaultValue) {
    if (dotenv.env.containsKey(key) && dotenv.env[key]!.isNotEmpty) {
      return dotenv.env[key]!;
    }
    final envVal = String.fromEnvironment(key);
    if (envVal.isNotEmpty) {
      return envVal;
    }
    return defaultValue;
  }

  // --- SUPABASE CONFIGURATION ---
  static String get supabaseUrl => _getValue(
        'SUPABASE_URL',
        'https://xyzcompany.supabase.co',
      );

  static String get supabaseAnonKey => _getValue(
        'SUPABASE_ANON_KEY',
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.dummy_anon_key',
      );

  // --- GEOSPATIAL MAPS & TILES ---
  static String get openStreetMapTileUrl => _getValue(
        'MAP_TILE_URL',
        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      );

  static String get mapboxApiKey => _getValue(
        'MAPBOX_API_KEY',
        '',
      );

  // --- PUSH NOTIFICATIONS ---
  static String get firebaseFcmServerEndpoint => _getValue(
        'FCM_ENDPOINT',
        'https://fcm.googleapis.com/fcm/send',
      );

  // --- PAYMENT GATEWAY CONFIGURATION ---
  static String get paymentGatewayBaseUrl => _getValue(
        'PAYMENT_GATEWAY_URL',
        'https://api.idrone.gt/v1/payments',
      );

  static String get paymentGatewayPublicKey => _getValue(
        'PAYMENT_PUBLIC_KEY',
        'pk_live_idrone_guatemala_public_key',
      );

  // --- EDGE FUNCTIONS & APIS ---
  static String get edgeFunctionsBaseUrl => '$supabaseUrl/functions/v1';

  /// Validates security policy constraints before app startup.
  static void validateSecurityConstraints() {
    // Rule 1: Must use HTTPS for remote production APIs
    if (!kDebugMode) {
      if (!supabaseUrl.startsWith('https://')) {
        throw SecurityError('CRITICAL SECURITY VIOLATION: SUPABASE_URL must use SSL/HTTPS in production.');
      }
      if (!paymentGatewayBaseUrl.startsWith('https://')) {
        throw SecurityError('CRITICAL SECURITY VIOLATION: PAYMENT_GATEWAY_URL must use SSL/HTTPS.');
      }
    }

    // Rule 2: Guard against secret key leak in Flutter client app
    if (supabaseAnonKey.contains('service_role') || supabaseAnonKey.contains('secret')) {
      throw SecurityError('CRITICAL SECURITY VIOLATION: Detected Supabase service_role key in client configuration! Only anon/public key is permitted.');
    }
  }

  /// Safe default headers for API calls
  static Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'apikey': supabaseAnonKey,
        'Authorization': 'Bearer $supabaseAnonKey',
        'X-Client-Platform': kIsWeb ? 'web-admin' : 'flutter-mobile',
        'X-App-Version': '1.0.0',
      };
}

class SecurityError implements Exception {
  final String message;
  SecurityError(this.message);

  @override
  String toString() => message;
}
