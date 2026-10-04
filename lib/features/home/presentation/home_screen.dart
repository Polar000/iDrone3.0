import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/services/app_media_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AppMediaService _mediaService = AppMediaService.instance;
  String _displayName = 'Usuario';
  String _userInitials = 'ID';

  @override
  void initState() {
    super.initState();
    _mediaService.addListener(_onMediaChanged);
    _loadUserProfile();
  }

  @override
  void dispose() {
    _mediaService.removeListener(_onMediaChanged);
    super.dispose();
  }

  void _onMediaChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadUserProfile() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final fullName = (user.userMetadata?['full_name'] as String?)?.trim() ?? '';
        final email = user.email?.trim() ?? '';

        String name = fullName.isNotEmpty ? fullName : (email.isNotEmpty ? email.split('@').first : 'Usuario');

        List<String> parts = name.split(' ').where((s) => s.isNotEmpty).toList();
        String initials = 'ID';
        if (parts.length >= 2) {
          initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
        } else if (parts.isNotEmpty) {
          initials = parts[0].substring(0, min(2, parts[0].length)).toUpperCase();
        }

        if (mounted) {
          setState(() {
            _displayName = parts.isNotEmpty ? parts.first : 'Usuario';
            _userInitials = initials;
          });
        }
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final heroUrl = _mediaService.getMediaUrl('hero_drone', fallback: 'assets/images/hero_drone.png');

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        // Handled at MainShellScreen level
      },
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Avatar and Greeting
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2.5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.neonGreenGradient,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.freshGreen.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: AppColors.deepForest,
                            child: Text(
                              _userInitials,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hola, $_displayName 👋',
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: AppColors.dark,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 1),
                            const Text(
                              '¿Listo para trabajar tu campo?',
                              style: TextStyle(fontSize: 13, color: AppColors.muted, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: AppColors.modernShadow(blur: 12),
                      ),
                      child: IconButton(
                        onPressed: () => context.push('/notifications'),
                        icon: Stack(
                          children: [
                            const Icon(Icons.notifications_none_rounded, size: 26, color: AppColors.dark),
                            Positioned(
                              right: 2,
                              top: 2,
                              child: Container(
                                width: 9,
                                height: 9,
                                decoration: BoxDecoration(
                                  color: AppColors.emerald,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.white, width: 1.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Weather & Operational Flight Radar Tile
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.softGreen, width: 1.5),
                    boxShadow: AppColors.modernShadow(
                      color: AppColors.dark.withValues(alpha: 0.05),
                      blur: 16,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.amber.shade100,
                              AppColors.softGreen,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.wb_sunny_rounded, color: Colors.amber, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  'Jutiapa • 28°C',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.dark),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.air_rounded, size: 14, color: AppColors.muted),
                                SizedBox(width: 2),
                                Text('12 km/h NE', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: const [
                                Icon(Icons.check_circle_rounded, size: 13, color: AppColors.emerald),
                                SizedBox(width: 4),
                                Text(
                                  'Vuelo óptimo: Viento bajo y sin lluvia',
                                  style: TextStyle(fontSize: 11, color: AppColors.forest, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.emerald.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.emerald.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.flight_takeoff_rounded, size: 12, color: AppColors.emerald),
                            SizedBox(width: 4),
                            Text(
                              'OK',
                              style: TextStyle(color: AppColors.emerald, fontSize: 11, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Main High-Tech Hero Card with Dynamic Database Image
                Container(
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppColors.freshGreen.withValues(alpha: 0.35), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.deepForest.withValues(alpha: 0.45),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Dynamic Database Hero Image
                      Positioned.fill(
                        child: AppMediaService.buildImageWidget(
                          heroUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Dark Gradient Overlay for Legibility
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.dark.withValues(alpha: 0.88),
                                AppColors.deepForest.withValues(alpha: 0.75),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.freshGreen.withValues(alpha: 0.22),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: AppColors.freshGreen.withValues(alpha: 0.5)),
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.radar_rounded, color: AppColors.freshGreen, size: 14),
                                      SizedBox(width: 6),
                                      Text(
                                        'Drones Activos • Telemetría RTK',
                                        style: TextStyle(color: AppColors.freshGreen, fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Precision v2.0',
                                    style: TextStyle(color: AppColors.cream, fontSize: 10, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'Tu campo, en buenas manos.',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Servicios agrícolas de precisión con drones de alta capacidad en Oriente y Jutiapa, Guatemala.',
                              style: TextStyle(color: AppColors.cream, fontSize: 13, height: 1.35),
                            ),
                            const SizedBox(height: 22),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.freshGreen,
                                  foregroundColor: AppColors.dark,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: 4,
                                  shadowColor: AppColors.freshGreen.withValues(alpha: 0.4),
                                ),
                                onPressed: () => context.push('/booking/flow'),
                                icon: const Icon(Icons.flight_takeoff_rounded, size: 20),
                                label: const Text(
                                  'Solicitar servicio de precisión',
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),

                const Text(
                  'Servicios rápidos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.dark, letterSpacing: -0.3),
                ),
                const SizedBox(height: 12),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.25,
                  children: [
                    _QuickServiceCard(
                      title: 'Fumigación',
                      subtitle: 'Aplicación precisa y uniforme.',
                      imageKey: 'service_fumigation',
                      icon: Icons.sanitizer_rounded,
                      color: AppColors.emerald,
                      onTap: () => context.push('/booking/flow?service=fumigation'),
                    ),
                    _QuickServiceCard(
                      title: 'Fertilización',
                      subtitle: 'Mejora el manejo de tus cultivos.',
                      imageKey: 'service_fertilization',
                      icon: Icons.water_drop_rounded,
                      color: AppColors.forest,
                      onTap: () => context.push('/booking/flow?service=fertilization'),
                    ),
                    _QuickServiceCard(
                      title: 'Esparcimiento',
                      subtitle: 'Distribución de granulados.',
                      imageKey: 'service_spreading',
                      icon: Icons.grain_rounded,
                      color: AppColors.earth,
                      onTap: () => context.push('/booking/flow?service=spreading'),
                    ),
                    _QuickServiceCard(
                      title: 'Monitoreo',
                      subtitle: 'Conoce el estado de tu campo.',
                      imageKey: 'service_monitoring',
                      icon: Icons.camera_alt_rounded,
                      color: AppColors.deepForest,
                      onTap: () => context.push('/booking/flow?service=monitoring'),
                    ),
                  ],
                ),
                const SizedBox(height: 26),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mis próximas reservas',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.dark, letterSpacing: -0.3),
                    ),
                    TextButton(
                      onPressed: () => context.go('/my-services'),
                      child: const Text('Ver todos', style: TextStyle(color: AppColors.emerald, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: AppColors.modernShadow(blur: 16),
                    border: Border.all(color: AppColors.emerald.withValues(alpha: 0.15)),
                  ),
                  child: InkWell(
                    onTap: () => context.push('/my-services'),
                    borderRadius: BorderRadius.circular(22),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.softGreen,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.agriculture_rounded, color: AppColors.deepForest, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Finca El Paraíso — Parcela Norte',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColors.dark,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Fumigación • Maíz • 12.60 manzanas',
                                  style: TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Programado: Mañana, 08:00 AM • ~49 min',
                                  style: TextStyle(
                                    color: AppColors.deepForest,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, size: 24, color: AppColors.muted),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageKey;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickServiceCard({
    required this.title,
    required this.subtitle,
    required this.imageKey,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppColors.modernShadow(blur: 14),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1.2),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // Dynamic Background Image
            Positioned.fill(
              child: AppMediaService.buildImageWidget(
                imageKey,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.white.withValues(alpha: 0.95),
                      AppColors.white.withValues(alpha: 0.85),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 22),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.muted,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
