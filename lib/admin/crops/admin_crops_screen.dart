import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AdminCropsScreen extends StatefulWidget {
  const AdminCropsScreen({super.key});

  @override
  State<AdminCropsScreen> createState() => _AdminCropsScreenState();
}

class _AdminCropsScreenState extends State<AdminCropsScreen> {
  final List<Map<String, dynamic>> _crops = [
    {'name': 'Maíz', 'desc': 'Maíz blanco y amarillo', 'active': true, 'sort': 1},
    {'name': 'Melón', 'desc': 'Melón de exportación', 'active': true, 'sort': 2},
    {'name': 'Caña de azúcar', 'desc': 'Campos de caña', 'active': true, 'sort': 3},
    {'name': 'Pastos', 'desc': 'Pastizales ganaderos', 'active': true, 'sort': 4},
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
              const Text('Gestión de Cultivos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Agregar Cultivo'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Descripción')),
                DataColumn(label: Text('Estado')),
                DataColumn(label: Text('Orden')),
                DataColumn(label: Text('Acciones')),
              ],
              rows: _crops.map((crop) {
                return DataRow(
                  cells: [
                    DataCell(Text(crop['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text(crop['desc'] as String)),
                    DataCell(
                      Switch(
                        value: crop['active'] as bool,
                        activeColor: AppColors.emerald,
                        onChanged: (val) => setState(() => crop['active'] = val),
                      ),
                    ),
                    DataCell(Text('${crop['sort']}')),
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
