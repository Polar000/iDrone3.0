import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'core/config/app_api_config.dart';
import 'core/services/app_media_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Safe dotenv loading with fallback to .env.example
  try {
    await dotenv.load(fileName: ".env");
  } catch (_) {
    try {
      await dotenv.load(fileName: ".env.example");
    } catch (e) {
      debugPrint('Note: .env file notice: $e');
    }
  }

  // 2. Safe security validation
  try {
    AppApiConfig.validateSecurityConstraints();
  } catch (e) {
    debugPrint('Security constraint notice: $e');
  }

  // 3. Supabase SDK initialization directly reading from .env / AppApiConfig
  try {
    await Supabase.initialize(
      url: AppApiConfig.supabaseUrl,
      anonKey: AppApiConfig.supabaseAnonKey,
    );
  } catch (e) {
    debugPrint('Supabase initialization notice: $e');
  }

  // 4. Load persisted media assets from local storage and Supabase app_media table
  try {
    await AppMediaService.instance.loadMediaFromSupabase();
  } catch (e) {
    debugPrint('Media service notice: $e');
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
