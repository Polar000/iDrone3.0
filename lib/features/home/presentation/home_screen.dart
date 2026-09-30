import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.deepForest,
                        child: Text('BM', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Hola, Bryan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.dark)),
                          Text('¿Listo para trabajar tu campo?', style: TextStyle(fontSize: 13, color: AppColors.muted)),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => context.push('/notifications'),
                    icon: Stack(
                      children: [
                        const Icon(Icons.notifications_none_rounded, size: 28, color: AppColors.dark),
                        Positioned(
                          right: 2,
                          top: 2,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.emerald,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.deepForest, AppColors.dark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepForest.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.freshGreen.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'iDrone Guatemala',
                        style: TextStyle(color: AppColors.freshGreen, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Tu campo, en buenas manos.',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Servicios agrícolas de precisión cuando los necesitas.',
                      style: TextStyle(color: AppColors.cream, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.freshGreen,
                          foregroundColor: AppColors.dark,
                          elevation: 0,
                        ),
                        onPressed: () => context.push('/booking/flow'),
                        icon: const Icon(Icons.add_location_alt_rounded),
                        label: const Text('Solicitar servicio', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text('Servicios rápidos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.dark)),
              const SizedBox(height: 12),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  _QuickServiceCard(
                    title: 'Fumigación',
                    subtitle: 'Aplicación precisa y uniforme.',
                    icon: Icons.sanitizer_rounded,
                    color: AppColors.emerald,
                    onTap: () => context.push('/booking/flow?service=fumigation'),
                  ),
                  _QuickServiceCard(
                    title: 'Fertilización',
                    subtitle: 'Mejora el manejo de tus cultivos.',
                    icon: Icons.water_drop_rounded,
                    color: AppColors.forest,
                    onTap: () => context.push('/booking/flow?service=fertilization'),
                  ),
                  _QuickServiceCard(
                    title: 'Esparcimiento',
                    subtitle: 'Distribución eficiente de granulados.',
                    icon: Icons.grain_rounded,
                    color: AppColors.earth,
                    onTap: () => context.push('/booking/flow?service=spreading'),
                  ),
                  _QuickServiceCard(
                    title: 'Monitoreo',
                    subtitle: 'Conoce mejor el estado de tu campo.',
                    icon: Icons.camera_alt_rounded,
                    color: AppColors.deepForest,
                    onTap: () => context.push('/booking/flow?service=monitoring'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Mis próximas reservas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.dark)),
                  TextButton(
                    onPressed: () => context.go('/my-services'),
                    child: const Text('Ver todos', style: TextStyle(color: AppColors.emerald, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Card(
                color: AppColors.white,
                elevation: 2,
                shadowColor: AppColors.dark.withValues(alpha: 0.08),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                child: InkWell(
                  onTap: () => context.push('/my-services'),
                  borderRadius: BorderRadius.circular(18),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.softGreen,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.agriculture_rounded, color: AppColors.deepForest, size: 26),
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
                                'Programado: Mañana, 08:00 AM',
                                style: TextStyle(
                                  color: AppColors.deepForest,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, size: 22, color: AppColors.muted),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickServiceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 2,
      shadowColor: AppColors.dark.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
