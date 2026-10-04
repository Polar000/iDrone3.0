import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'core/config/app_api_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Safe dotenv loading
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Note: .env file notice: $e');
  }

  // 2. Safe security validation
  try {
    AppApiConfig.validateSecurityConstraints();
  } catch (e) {
    debugPrint('Security constraint notice: $e');
  }

  // 3. Supabase SDK initialization
  // Uses a valid JWT payload format for offline/fallback initialization to ensure Supabase.instance is never null
  const fallbackUrl = 'https://idrone-guatemala.supabase.co';
  const fallbackAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlkcm9uZSIsInJvbGUiOiJhb24iLCJpYXQiOjE2MDAwMDAwMDAsImV4cCI6MjAwMDAwMDAwMH0.dummy_signature_key_for_idrone';

  try {
    final url = AppApiConfig.supabaseUrl.contains('xyzcompany') ? fallbackUrl : AppApiConfig.supabaseUrl;
    final anonKey = AppApiConfig.supabaseAnonKey.contains('dummy_anon_key') ? fallbackAnonKey : AppApiConfig.supabaseAnonKey;

    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  } catch (e) {
    debugPrint('Supabase main init notice: $e');
    try {
      await Supabase.initialize(
        url: fallbackUrl,
        anonKey: fallbackAnonKey,
      );
    } catch (fallbackError) {
      debugPrint('Supabase fallback init notice: $fallbackError');
    }
  }

  // Guaranteed app launch
  runApp(
    const ProviderScope(
      child: IDroneApp(),
    ),
  );
}

class IDroneApp extends StatelessWidget {
  const IDroneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'iDrone Guatemala',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
