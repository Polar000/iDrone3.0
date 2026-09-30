import 'package:flutter/material.dart';
import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'core/config/app_api_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Validate security rules before application boot
  AppApiConfig.validateSecurityConstraints();

  runApp(const IDroneApp());
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
