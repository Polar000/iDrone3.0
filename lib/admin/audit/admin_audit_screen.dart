import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AdminAuditScreen extends StatelessWidget {
  const AdminAuditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = [
      {'actor': 'Super Admin', 'action': 'UPDATE_PRICE_RULE', 'entity': 'pricing_rules', 'time': '2026-03-01 10:15'},
      {'actor': 'Carlos Ramos', 'action': 'UPDATE_BOOKING_STATUS', 'entity': 'bookings', 'time': '2026-03-01 09:30'},
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Registros de Auditoría', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
          const SizedBox(height: 16),
          Card(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Usuario')),
                DataColumn(label: Text('Acción')),
                DataColumn(label: Text('Entidad')),
                DataColumn(label: Text('Fecha y Hora')),
              ],
              rows: logs.map((l) {
                return DataRow(
                  cells: [
                    DataCell(Text(l['actor']!, style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text(l['action']!, style: const TextStyle(color: AppColors.emerald))),
                    DataCell(Text(l['entity']!)),
                    DataCell(Text(l['time']!)),
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
