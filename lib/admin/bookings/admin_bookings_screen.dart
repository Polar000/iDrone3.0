import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../app/theme/app_colors.dart';

class AdminBookingsScreen extends StatefulWidget {
  const AdminBookingsScreen({super.key});

  @override
  State<AdminBookingsScreen> createState() => _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends State<AdminBookingsScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _bookings = [];

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    final supabase = Supabase.instance.client;
    try {
      final res = await supabase
          .from('bookings')
          .select('*, profiles:customer_id(full_name, email), services(name), crops(name)')
          .order('created_at', ascending: false);

      final List<Map<String, dynamic>> loaded = [];
      if (res is List) {
        for (final item in res) {
          final customerName = item['profiles']?['full_name'] ?? item['profiles']?['email'] ?? 'Cliente';
          final serviceName = item['services']?['name'] ?? 'Servicio';
          final cropName = item['crops']?['name'] ?? 'Cultivo';
          final area = item['area_manzanas'] ?? item['area_ha'] ?? '0';
          final totalVal = (item['total'] as num?)?.toDouble() ?? 0.0;

          loaded.add({
            'id': item['id']?.toString().substring(0, 8).toUpperCase() ?? 'BK-001',
            'full_id': item['id'],
            'customer': customerName,
            'service': serviceName,
            'crop': cropName,
            'area': '$area mz',
            'date': item['scheduled_date'] ?? 'Por programar',
            'total': 'Q${totalVal.toStringAsFixed(2)}',
            'status': item['status'] ?? 'confirmed',
          });
        }
      }

      if (mounted) {
        setState(() {
          _bookings = loaded.isNotEmpty
              ? loaded
              : [
                  {
                    'id': 'BK-2026-001',
                    'customer': 'Bryan Morales',
                    'service': 'Fumigación',
                    'crop': 'Maíz',
                    'area': '12.60 mz',
                    'date': '2026-03-02',
                    'total': 'Q1,890.00',
                    'status': 'confirmed',
                  },
                ];
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Gestión de Reservas', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: AppColors.emerald),
                onPressed: () {
                  setState(() => _isLoading = true);
                  _fetchBookings();
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(color: AppColors.emerald),
              ),
            )
          else
            Card(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID Reserva')),
                    DataColumn(label: Text('Cliente')),
                    DataColumn(label: Text('Servicio')),
                    DataColumn(label: Text('Cultivo')),
                    DataColumn(label: Text('Área')),
                    DataColumn(label: Text('Fecha')),
                    DataColumn(label: Text('Total')),
                    DataColumn(label: Text('Estado')),
                  ],
                  rows: _bookings.map((b) {
                    return DataRow(
                      cells: [
                        DataCell(Text(b['id'] as String, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.emerald))),
                        DataCell(Text(b['customer'] as String)),
                        DataCell(Text(b['service'] as String)),
                        DataCell(Text(b['crop'] as String)),
                        DataCell(Text(b['area'] as String)),
                        DataCell(Text(b['date'] as String)),
                        DataCell(Text(b['total'] as String, style: const TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(
                          Chip(
                            label: Text(b['status'] as String, style: const TextStyle(fontSize: 10, color: AppColors.white)),
                            backgroundColor: AppColors.deepForest,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
