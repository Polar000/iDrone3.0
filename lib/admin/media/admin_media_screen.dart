import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AdminMediaScreen extends StatefulWidget {
  const AdminMediaScreen({super.key});

  @override
  State<AdminMediaScreen> createState() => _AdminMediaScreenState();
}

class _AdminMediaScreenState extends State<AdminMediaScreen> {
  final List<Map<String, String>> _mediaList = [
    {'name': 'hero_drone_field.jpg', 'cat': 'hero', 'size': '1.2 MB'},
    {'name': 'crop_corn_field.png', 'cat': 'crop', 'size': '850 KB'},
    {'name': 'service_fumigation.jpg', 'cat': 'service', 'size': '2.1 MB'},
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
              const Text('Biblioteca de Medios', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.upload_file),
                label: const Text('Subir Archivo'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Nombre Archivo')),
                DataColumn(label: Text('Categoría')),
                DataColumn(label: Text('Tamaño')),
                DataColumn(label: Text('Acciones')),
              ],
              rows: _mediaList.map((m) {
                return DataRow(
                  cells: [
                    DataCell(Text(m['name']!, style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Chip(label: Text(m['cat']!), backgroundColor: AppColors.softGreen)),
                    DataCell(Text(m['size']!)),
                    DataCell(IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: () {})),
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
