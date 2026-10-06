import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class MyServicesScreen extends StatefulWidget {
  const MyServicesScreen({super.key});

  @override
  State<MyServicesScreen> createState() => _MyServicesScreenState();
}

class _MyServicesScreenState extends State<MyServicesScreen> {
  List<Map<String, dynamic>> _allBookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final data = await Supabase.instance.client
            .from('bookings')
            .select('*, fields(name, farms(name)), services(name), crops(name)')
            .eq('customer_id', user.id)
            .order('created_at', ascending: false);

        if (mounted) {
          setState(() {
            _allBookings = List<Map<String, dynamic>>.from(data);
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pending = _allBookings.where((b) => b['status'] == 'pending' || b['status'] == 'confirmed' || b['status'] == 'scheduled' || b['status'] == 'assigned').toList();
    final inProgress = _allBookings.where((b) => b['status'] == 'en_route' || b['status'] == 'in_progress').toList();
    final completed = _allBookings.where((b) => b['status'] == 'completed').toList();

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
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.emerald))
            : TabBarView(
                children: [
                  _buildServiceList(pending),
                  _buildServiceList(inProgress),
                  _buildServiceList(completed),
                ],
              ),
      ),
    );
  }

  Widget _buildServiceList(List<Map<String, dynamic>> items) {
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
        final farmName = item['fields']?['farms']?['name'] ?? 'Finca';
        final fieldName = item['fields']?['name'] ?? 'Parcela';
        final title = '$farmName — $fieldName';
        final service = item['services']?['name'] ?? 'Servicio';
        final crop = item['crops']?['name'] ?? 'Cultivo';
        final area = '${item['area_manzanas'] ?? item['area_ha'] ?? '0'} manzanas';
        final date = item['scheduled_date'] ?? 'Por programar';
        final status = item['status'] ?? 'Pendiente';
        final total = 'Q${item['total'] ?? '0.00'}';

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
                        title,
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
                        status,
                        style: const TextStyle(color: AppColors.deepForest, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('$service • $crop • $area', style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(date, style: const TextStyle(color: AppColors.dark, fontWeight: FontWeight.w500, fontSize: 12)),
                    Text(total, style: const TextStyle(color: AppColors.deepForest, fontWeight: FontWeight.bold, fontSize: 15)),
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
