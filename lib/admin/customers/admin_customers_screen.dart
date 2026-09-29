import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AdminCustomersScreen extends StatelessWidget {
  const AdminCustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customers = [
      {'name': 'Bryan Morales', 'email': 'bryan@example.com', 'phone': '+502 5555 1234', 'spent': 'Q3,377.50', 'status': 'Activo'},
      {'name': 'Mario Estrada', 'email': 'mario@example.com', 'phone': '+502 5555 9876', 'spent': 'Q1,487.50', 'status': 'Activo'},
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Gestión de Clientes', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
          const SizedBox(height: 16),
          Card(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Correo')),
                DataColumn(label: Text('Teléfono')),
                DataColumn(label: Text('Total Invertido')),
                DataColumn(label: Text('Estado')),
              ],
              rows: customers.map((c) {
                return DataRow(
                  cells: [
                    DataCell(Text(c['name']!, style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text(c['email']!)),
                    DataCell(Text(c['phone']!)),
                    DataCell(Text(c['spent']!, style: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.bold))),
                    DataCell(Chip(label: Text(c['status']!), backgroundColor: AppColors.softGreen)),
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
