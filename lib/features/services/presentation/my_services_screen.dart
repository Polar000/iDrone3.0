import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class MyServicesScreen extends StatelessWidget {
  const MyServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.cream,
        appBar: AppBar(
          title: const Text('Mis Servicios'),
          bottom: const TabBar(
            indicatorColor: AppColors.emerald,
            labelColor: AppColors.emerald,
            unselectedLabelColor: AppColors.muted,
            tabs: [
              Tab(text: 'Pendientes'),
              Tab(text: 'En proceso'),
              Tab(text: 'Completados'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildServiceList([
              {
                'title': 'Finca El Paraíso — Parcela Norte',
                'service': 'Fumigación',
                'crop': 'Maíz',
                'area': '12.60 manzanas',
                'date': 'Mañana, 08:00 AM',
                'status': 'Pendiente',
                'total': 'Q1,890.00',
              },
            ]),
            _buildServiceList([
              {
                'title': 'Finca San José — Lote 3',
                'service': 'Fertilización foliar',
                'crop': 'Melón',
                'area': '8.50 manzanas',
                'date': 'Hoy, En sitio',
                'status': 'En proceso',
                'total': 'Q1,487.50',
              },
            ]),
            _buildServiceList([
              {
                'title': 'Finca El Retiro — Parcela Sur',
                'service': 'Monitoreo agrícola',
                'crop': 'Café',
                'area': '15.00 manzanas',
                'date': '24 Feb 2026',
                'status': 'Completado',
                'total': 'Q1,800.00',
              },
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceList(List<Map<String, String>> items) {
    if (items.isEmpty) {
      return const Center(
        child: Text('Aún no tienes servicios en esta sección', style: TextStyle(color: AppColors.muted)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          color: AppColors.white,
          elevation: 2,
          shadowColor: AppColors.dark.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item['title']!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.dark),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.softGreen,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.emerald.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        item['status']!,
                        style: const TextStyle(color: AppColors.deepForest, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('${item['service']} • ${item['crop']} • ${item['area']}', style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['date']!, style: const TextStyle(color: AppColors.dark, fontWeight: FontWeight.w500, fontSize: 12)),
                    Text(item['total']!, style: const TextStyle(color: AppColors.deepForest, fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
