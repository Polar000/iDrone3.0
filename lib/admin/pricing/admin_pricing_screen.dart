import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AdminPricingScreen extends StatefulWidget {
  const AdminPricingScreen({super.key});

  @override
  State<AdminPricingScreen> createState() => _AdminPricingScreenState();
}

class _AdminPricingScreenState extends State<AdminPricingScreen> {
  final List<Map<String, dynamic>> _rules = [
    {'service': 'Fumigación', 'priceMz': 150.0, 'priceHa': 214.60, 'travel': 100.0, 'active': true},
    {'service': 'Fertilización foliar', 'priceMz': 175.0, 'priceHa': 250.37, 'travel': 100.0, 'active': true},
    {'service': 'Esparcimiento', 'priceMz': 160.0, 'priceHa': 228.91, 'travel': 100.0, 'active': true},
    {'service': 'Monitoreo', 'priceMz': 120.0, 'priceHa': 171.68, 'travel': 100.0, 'active': true},
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
              const Text('Reglas de Precios', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Nueva Regla'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Servicio')),
                DataColumn(label: Text('Precio/Manzana')),
                DataColumn(label: Text('Precio/Hectárea')),
                DataColumn(label: Text('Tarifa Movilización')),
                DataColumn(label: Text('Estado')),
                DataColumn(label: Text('Acciones')),
              ],
              rows: _rules.map((rule) {
                return DataRow(
                  cells: [
                    DataCell(Text(rule['service'] as String, style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text('Q${(rule['priceMz'] as double).toStringAsFixed(2)}')),
                    DataCell(Text('Q${(rule['priceHa'] as double).toStringAsFixed(2)}')),
                    DataCell(Text('Q${(rule['travel'] as double).toStringAsFixed(2)}')),
                    DataCell(
                      Switch(
                        value: rule['active'] as bool,
                        activeColor: AppColors.emerald,
                        onChanged: (val) => setState(() => rule['active'] = val),
                      ),
                    ),
                    DataCell(
                      IconButton(icon: const Icon(Icons.edit, color: AppColors.emerald), onPressed: () {}),
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
