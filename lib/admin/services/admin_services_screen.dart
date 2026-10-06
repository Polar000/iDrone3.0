import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AdminServicesScreen extends StatefulWidget {
  const AdminServicesScreen({super.key});

  @override
  State<AdminServicesScreen> createState() => _AdminServicesScreenState();
}

class _AdminServicesScreenState extends State<AdminServicesScreen> {
  final List<Map<String, dynamic>> _services = [
    {'name': 'Fumigación', 'type': 'fumigation', 'active': true},
    {'name': 'Fertilización foliar', 'type': 'fertilization', 'active': true},
    {'name': 'Esparcimiento de granulados', 'type': 'spreading', 'active': true},
    {'name': 'Monitoreo agrícola', 'type': 'monitoring', 'active': true},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Gestión de Servicios', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Agregar Servicio'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Servicio')),
                DataColumn(label: Text('Tipo')),
                DataColumn(label: Text('Estado')),
                DataColumn(label: Text('Acciones')),
              ],
              rows: _services.map((serv) {
                return DataRow(
                  cells: [
                    DataCell(Text(serv['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text(serv['type'] as String)),
                    DataCell(
                      Switch(
                        value: serv['active'] as bool,
                        activeColor: AppColors.emerald,
                        onChanged: (val) => setState(() => serv['active'] = val),
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          IconButton(icon: const Icon(Icons.edit, color: AppColors.emerald), onPressed: () {}),
                          IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: () {}),
                        ],
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
