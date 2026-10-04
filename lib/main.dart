import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'core/config/app_api_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Automatically load runtime environment variables from .env file
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Note: .env file notice: $e');
  }

  // Validate security rules before application boot
  AppApiConfig.validateSecurityConstraints();

  // Initialize Supabase SDK
  try {
    await Supabase.initialize(
      url: AppApiConfig.supabaseUrl,
      anonKey: AppApiConfig.supabaseAnonKey,
    );
  } catch (e) {
    debugPrint('Supabase init warning: $e');
  }

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
