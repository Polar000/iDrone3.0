import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AdminPromotionsScreen extends StatefulWidget {
  const AdminPromotionsScreen({super.key});

  @override
  State<AdminPromotionsScreen> createState() => _AdminPromotionsScreenState();
}

class _AdminPromotionsScreenState extends State<AdminPromotionsScreen> {
  final List<Map<String, dynamic>> _promotions = [
    {'code': 'TEMPORADA10', 'name': 'Descuento de Primavera', 'type': 'percentage', 'val': '10%', 'active': true},
    {'code': 'PRIMERSERVICIO', 'name': 'Bono Nuevo Cliente', 'type': 'fixed', 'val': 'Q100.00', 'active': true},
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
              const Text('Promociones y Cupones', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Crear Promoción'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Código')),
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Tipo')),
                DataColumn(label: Text('Descuento')),
                DataColumn(label: Text('Estado')),
              ],
              rows: _promotions.map((promo) {
                return DataRow(
                  cells: [
                    DataCell(Text(promo['code'] as String, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.emerald))),
                    DataCell(Text(promo['name'] as String)),
                    DataCell(Text(promo['type'] as String)),
                    DataCell(Text(promo['val'] as String)),
                    DataCell(
                      Switch(
                        value: promo['active'] as bool,
                        activeColor: AppColors.emerald,
                        onChanged: (val) => setState(() => promo['active'] = val),
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
