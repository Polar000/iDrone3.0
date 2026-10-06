import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Configuración General de iDrone', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: 'iDrone Guatemala',
                    decoration: const InputDecoration(labelText: 'Nombre de la Empresa'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: 'GTQ',
                    decoration: const InputDecoration(labelText: 'Moneda Predeterminada'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: '6988.96',
                    decoration: const InputDecoration(labelText: 'Factor de Conversión (m² por Manzana)'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: '25',
                    decoration: const InputDecoration(labelText: 'Porcentaje de Anticipo Predeterminado (%)'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Configuración del sistema guardada.')),
                      );
                    },
                    child: const Text('Guardar Ajustes'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
