import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../app/theme/app_colors.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dashboard General', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
          const SizedBox(height: 16),

          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 800;
              return GridView.count(
                crossAxisCount: isDesktop ? 4 : 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.8,
                children: const [
                  _MetricCard(title: 'Ingresos del mes', value: 'Q48,500.00', icon: Icons.payments_rounded, color: AppColors.emerald),
                  _MetricCard(title: 'Servicios realizados', value: '32', icon: Icons.task_alt_rounded, color: AppColors.forest),
                  _MetricCard(title: 'Manzanas trabajadas', value: '412.50 mz', icon: Icons.landscape_rounded, color: AppColors.earth),
                  _MetricCard(title: 'Clientes activos', value: '128', icon: Icons.people_rounded, color: AppColors.deepForest),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Operational Zone Distribution / Heatmap Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Cobertura Operativa y Densidad por Zona', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.deepForest)),
                      Chip(
                        label: Text('Oriente GT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
                        backgroundColor: AppColors.softGreen,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _ZoneHeatTile(zoneName: 'Jutiapa', areaMz: '185.0 mz', intensity: 0.9, activeDrones: 3),
                      const SizedBox(width: 12),
                      _ZoneHeatTile(zoneName: 'Moyuta', areaMz: '112.5 mz', intensity: 0.65, activeDrones: 2),
                      const SizedBox(width: 12),
                      _ZoneHeatTile(zoneName: 'Pasaco', areaMz: '75.0 mz', intensity: 0.45, activeDrones: 1),
                      const SizedBox(width: 12),
                      _ZoneHeatTile(zoneName: 'Jalpatagua', areaMz: '40.0 mz', intensity: 0.25, activeDrones: 1),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Ingresos Semanales (GTQ)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 200,
                          child: BarChart(
                            BarChartData(
                              borderData: FlBorderData(show: false),
                              barGroups: [
                                BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 8000, color: AppColors.emerald)]),
                                BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 12000, color: AppColors.emerald)]),
                                BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 15000, color: AppColors.emerald)]),
                                BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 13500, color: AppColors.emerald)]),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                Icon(icon, color: color, size: 22),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.dark)),
          ],
        ),
      ),
    );
  }
}

class _ZoneHeatTile extends StatelessWidget {
  final String zoneName;
  final String areaMz;
  final double intensity;
  final int activeDrones;

  const _ZoneHeatTile({
    required this.zoneName,
    required this.areaMz,
    required this.intensity,
    required this.activeDrones,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.emerald.withValues(alpha: intensity * 0.25 + 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.emerald.withValues(alpha: intensity)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(zoneName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.deepForest)),
            const SizedBox(height: 4),
            Text(areaMz, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.dark)),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.flight_rounded, size: 14, color: AppColors.forest),
                const SizedBox(width: 4),
                Text('$activeDrones drones', style: const TextStyle(fontSize: 11, color: AppColors.muted)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
