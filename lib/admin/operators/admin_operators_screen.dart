import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AdminOperatorsScreen extends StatelessWidget {
  const AdminOperatorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final operators = [
      {'name': 'Carlos Ramos', 'phone': '+502 5555 1234', 'zone': 'Jutiapa', 'status': 'Disponible'},
      {'name': 'José Martínez', 'phone': '+502 5555 8888', 'zone': 'Moyuta', 'status': 'En servicio'},
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Gestión de Operadores', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.person_add),
                label: const Text('Nuevo Operador'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Teléfono')),
                DataColumn(label: Text('Zona Asignada')),
                DataColumn(label: Text('Estado')),
              ],
              rows: operators.map((op) {
                return DataRow(
                  cells: [
                    DataCell(Text(op['name']!, style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text(op['phone']!)),
                    DataCell(Text(op['zone']!)),
                    DataCell(Chip(label: Text(op['status']!), backgroundColor: AppColors.softGreen)),
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
