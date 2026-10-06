import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/services/app_media_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  final AppMediaService _mediaService = AppMediaService.instance;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
    _checkNextScreen();
  }

  Future<void> _checkNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        context.go('/home');
        return;
      }
    } catch (_) {}

    context.go('/login');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgUrl = _mediaService.getMediaUrl('splash_bg');
    final logoUrl = _mediaService.getMediaUrl('logo_dark');

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          AppMediaService.buildImageWidget(
            bgUrl,
            fit: BoxFit.cover,
            errorWidget: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.deepForest, AppColors.dark],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Gradient Overlay
          Container(
            color: AppColors.dark.withValues(alpha: 0.55),
          ),

          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: _getAlignmentCenter(),
                  children: [
                    AppMediaService.buildImageWidget(
                      logoUrl,
                      height: 120,
                      errorWidget: _buildLogoFallback(),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'i',
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w300,
                              color: AppColors.freshGreen,
                            ),
                          ),
                          TextSpan(
                            text: 'Drone',
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Agricultura de precisión como servicio.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.cream,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  MainAxisAlignment _getAlignmentCenter() => MainAxisAlignment.center;

  Widget _buildLogoFallback() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.emerald.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.freshGreen.withValues(alpha: 0.4), width: 2),
      ),
      child: const Icon(
        Icons.air_rounded,
        size: 72,
        color: AppColors.freshGreen,
      ),
    );
  }
}
