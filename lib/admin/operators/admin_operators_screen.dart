import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../app/theme/app_colors.dart';

class AdminOperatorsScreen extends StatefulWidget {
  const AdminOperatorsScreen({super.key});

  @override
  State<AdminOperatorsScreen> createState() => _AdminOperatorsScreenState();
}

class _AdminOperatorsScreenState extends State<AdminOperatorsScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _operators = [];

  @override
  void initState() {
    super.initState();
    _fetchOperators();
  }

  Future<void> _fetchOperators() async {
    final supabase = Supabase.instance.client;
    try {
      final res = await supabase.from('operators').select('*, profiles:user_id(full_name, phone, email, status)');

      final List<Map<String, dynamic>> loaded = [];
      if (res is List) {
        for (final op in res) {
          final profile = op['profiles'];
          loaded.add({
            'id': op['id'],
            'user_id': op['user_id'],
            'name': profile?['full_name'] ?? profile?['email']?.split('@').first ?? op['name'] ?? 'Piloto',
            'phone': profile?['phone'] ?? op['phone'] ?? '+502 5555 0000',
            'zone': op['assigned_zones'] != null && (op['assigned_zones'] as List).isNotEmpty
                ? (op['assigned_zones'] as List).first.toString()
                : 'Jutiapa',
            'status': op['status'] ?? 'available',
          });
        }
      }

      if (mounted) {
        setState(() {
          _operators = loaded.isNotEmpty
              ? loaded
              : [
                  {'id': '1', 'name': 'Carlos Ramos', 'phone': '+502 5555 1234', 'zone': 'Jutiapa', 'status': 'available'},
                  {'id': '2', 'name': 'José Martínez', 'phone': '+502 5555 8888', 'zone': 'Moyuta', 'status': 'busy'},
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

  void _showCreateOperatorModal() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    String selectedZone = 'Jutiapa';
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Registrar Nuevo Piloto / Operador', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.dark)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Nombre Completo', prefixIcon: Icon(Icons.person, color: AppColors.emerald)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Correo Electrónico', prefixIcon: Icon(Icons.email, color: AppColors.emerald)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Teléfono', prefixIcon: Icon(Icons.phone, color: AppColors.emerald)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Contraseña de Acceso', prefixIcon: Icon(Icons.lock, color: AppColors.emerald)),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedZone,
                    decoration: const InputDecoration(labelText: 'Zona Asignada', prefixIcon: Icon(Icons.map, color: AppColors.emerald)),
                    items: ['Jutiapa', 'Moyuta', 'Pasaco', 'Jalpatagua'].map((z) => DropdownMenuItem(value: z, child: Text(z))).toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedZone = val);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar', style: TextStyle(color: AppColors.muted)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emerald,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: isSubmitting
                    ? null
                    : () async {
                        final name = nameCtrl.text.trim();
                        final email = emailCtrl.text.trim();
                        final phone = phoneCtrl.text.trim();
                        final pass = passCtrl.text.trim();

                        if (name.isEmpty || email.isEmpty || pass.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Por favor completa todos los campos requeridos.')),
                          );
                          return;
                        }

                        setModalState(() => isSubmitting = true);

                        try {
                          final supabase = Supabase.instance.client;

                          // Register operator profile
                          final authRes = await supabase.auth.signUp(
                            email: email,
                            password: pass,
                            data: {
                              'full_name': name,
                              'phone': phone,
                              'role': 'operator',
                            },
                          );

                          final userId = authRes.user?.id;
                          if (userId != null) {
                            await supabase.from('profiles').upsert({
                              'id': userId,
                              'full_name': name,
                              'email': email,
                              'phone': phone,
                              'role': 'operator',
                              'status': 'active',
                            });

                            await supabase.from('operators').insert({
                              'user_id': userId,
                              'name': name,
                              'phone': phone,
                              'assigned_zones': [selectedZone],
                              'status': 'available',
                            });
                          }

                          if (!mounted) return;
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('✓ Piloto $name registrado exitosamente con rol de Operador.'),
                              backgroundColor: AppColors.emerald,
                            ),
                          );
                          _fetchOperators();
                        } catch (e) {
                          setModalState(() => isSubmitting = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al crear operador: ${e.toString()}'), backgroundColor: Colors.redAccent),
                          );
                        }
                      },
                child: isSubmitting
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2))
                    : const Text('Crear Piloto'),
              ),
            ],
          );
        },
      ),
    );
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
              const Text('Gestión de Operadores / Pilotos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emerald,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _showCreateOperatorModal,
                icon: const Icon(Icons.person_add_rounded),
                label: const Text('Nuevo Piloto'),
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
                    DataColumn(label: Text('Teléfono')),
                    DataColumn(label: Text('Zona Asignada')),
                    DataColumn(label: Text('Estado')),
                  ],
                  rows: _operators.map((op) {
                    return DataRow(
                      cells: [
                        DataCell(Text(op['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Text(op['phone'] as String)),
                        DataCell(Text(op['zone'] as String)),
                        DataCell(Chip(label: Text(op['status'] as String), backgroundColor: AppColors.softGreen)),
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
