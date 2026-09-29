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
