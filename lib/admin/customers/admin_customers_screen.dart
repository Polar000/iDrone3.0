import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../app/theme/app_colors.dart';

class AdminCustomersScreen extends StatefulWidget {
  const AdminCustomersScreen({super.key});

  @override
  State<AdminCustomersScreen> createState() => _AdminCustomersScreenState();
}

class _AdminCustomersScreenState extends State<AdminCustomersScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _customers = [];

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    final supabase = Supabase.instance.client;
    try {
      final res = await supabase.from('profiles').select('*').eq('role', 'customer');

      final List<Map<String, dynamic>> loaded = [];
      if (res is List) {
        for (final c in res) {
          loaded.add({
            'name': c['full_name'] ?? c['email']?.split('@').first ?? 'Cliente',
            'email': c['email'] ?? 'N/A',
            'phone': c['phone'] ?? '+502 5555 0000',
            'spent': 'Q0.00',
            'status': c['status'] ?? 'Activo',
          });
        }
      }

      if (mounted) {
        setState(() {
          _customers = loaded.isNotEmpty
              ? loaded
              : [
                  {'name': 'Bryan Morales', 'email': 'bryan@example.com', 'phone': '+502 5555 1234', 'spent': 'Q3,377.50', 'status': 'Activo'},
                  {'name': 'Mario Estrada', 'email': 'mario@example.com', 'phone': '+502 5555 9876', 'spent': 'Q1,487.50', 'status': 'Activo'},
                ];
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Gestión de Clientes', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: AppColors.emerald),
                onPressed: () {
                  setState(() => _isLoading = true);
                  _fetchCustomers();
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(color: AppColors.emerald),
              ),
            )
          else
            Card(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Nombre')),
                    DataColumn(label: Text('Correo')),
                    DataColumn(label: Text('Teléfono')),
                    DataColumn(label: Text('Total Invertido')),
                    DataColumn(label: Text('Estado')),
                  ],
                  rows: _customers.map((c) {
                    return DataRow(
                      cells: [
                        DataCell(Text(c['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Text(c['email'] as String)),
                        DataCell(Text(c['phone'] as String)),
                        DataCell(Text(c['spent'] as String, style: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.bold))),
                        DataCell(Chip(label: Text(c['status'] as String), backgroundColor: AppColors.softGreen)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
