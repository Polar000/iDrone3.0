import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AdminBookingsScreen extends StatefulWidget {
  const AdminBookingsScreen({super.key});

  @override
  State<AdminBookingsScreen> createState() => _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends State<AdminBookingsScreen> {
  final List<Map<String, dynamic>> _bookings = [
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
    {
      'id': 'BK-2026-002',
      'customer': 'Mario Estrada',
      'service': 'Fertilización',
      'crop': 'Melón',
      'area': '8.50 mz',
      'date': '2026-03-02',
      'total': 'Q1,487.50',
      'status': 'scheduled',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Gestión de Reservas', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
          const SizedBox(height: 16),
          Card(
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
        ],
      ),
    );
  }
}
