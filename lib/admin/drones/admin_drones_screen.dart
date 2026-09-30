import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AdminDronesScreen extends StatelessWidget {
  const AdminDronesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final drones = [
      {'name': 'Dron Alpha 1', 'model': 'DJI Agras T40', 'serial': 'SN-T40-9901', 'status': 'Disponible', 'batteries': 4},
      {'name': 'Dron Alpha 2', 'model': 'DJI Agras T30', 'serial': 'SN-T30-4412', 'status': 'Mantenimiento', 'batteries': 3},
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Gestión de Drones', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Registrar Dron'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Modelo')),
                DataColumn(label: Text('Serie')),
                DataColumn(label: Text('Baterías')),
                DataColumn(label: Text('Estado')),
              ],
              rows: drones.map((d) {
                return DataRow(
                  cells: [
                    DataCell(Text(d['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text(d['model'] as String)),
                    DataCell(Text(d['serial'] as String)),
                    DataCell(Text('${d['batteries']}')),
                    DataCell(Chip(label: Text(d['status'] as String), backgroundColor: AppColors.softGreen)),
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
