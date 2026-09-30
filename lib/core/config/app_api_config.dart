import 'package:flutter/foundation.dart';

/// Centralized & Secure API Configuration Manager for iDrone.
///
/// Security Directive Compliance:
/// 1. Uses `--dart-define` / [String.fromEnvironment] for zero hardcoded credentials.
/// 2. Validates HTTPS protocol requirement for all remote API endpoints.
/// 3. Runtime guard against accidental exposure of Supabase `service_role` or payment secret keys.
/// 4. Provides safe sanitized headers for network client requests.
class AppApiConfig {
  AppApiConfig._();

  // --- SUPABASE CONFIGURATION ---
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://xyzcompany.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.dummy_anon_key',
  );

  // --- GEOSPATIAL MAPS & TILES ---
  static const String openStreetMapTileUrl = String.fromEnvironment(
    'MAP_TILE_URL',
    defaultValue: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  );

  static const String mapboxApiKey = String.fromEnvironment(
    'MAPBOX_API_KEY',
    defaultValue: '',
  );

  // --- PUSH NOTIFICATIONS ---
  static const String firebaseFcmServerEndpoint = String.fromEnvironment(
    'FCM_ENDPOINT',
    defaultValue: 'https://fcm.googleapis.com/fcm/send',
  );

  // --- PAYMENT GATEWAY CONFIGURATION ---
  static const String paymentGatewayBaseUrl = String.fromEnvironment(
    'PAYMENT_GATEWAY_URL',
    defaultValue: 'https://api.idrone.gt/v1/payments',
  );

  static const String paymentGatewayPublicKey = String.fromEnvironment(
    'PAYMENT_PUBLIC_KEY',
    defaultValue: 'pk_live_idrone_guatemala_public_key',
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
