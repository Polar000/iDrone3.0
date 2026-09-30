import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AdminZonesScreen extends StatelessWidget {
  const AdminZonesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final zones = [
      {'name': 'Jutiapa', 'fee': 'Q100.00', 'active': true},
      {'name': 'Pasaco', 'fee': 'Q150.00', 'active': true},
      {'name': 'Moyuta', 'fee': 'Q120.00', 'active': true},
      {'name': 'Jalpatagua', 'fee': 'Q110.00', 'active': true},
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Gestión de Zonas Cobertura', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_location_alt),
                label: const Text('Agregar Zona'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Zona')),
                DataColumn(label: Text('Tarifa Movilización')),
                DataColumn(label: Text('Estado')),
              ],
              rows: zones.map((z) {
                return DataRow(
                  cells: [
                    DataCell(Text(z['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text(z['fee'] as String)),
                    DataCell(Chip(label: Text(z['active'] as bool ? 'Activa' : 'Inactiva'), backgroundColor: AppColors.softGreen)),
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
