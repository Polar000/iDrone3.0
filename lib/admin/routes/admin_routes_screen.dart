import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AdminRoutesScreen extends StatelessWidget {
  const AdminRoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Optimización de Rutas Operativas', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Ruta 1 — Zona Jutiapa (2 Trabajos Agrupados)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Parada 1: Finca El Paraíso (Bryan Morales) — 12.60 mz'),
                  Text('Parada 2: Finca San José (Mario Estrada) — 8.50 mz'),
                  SizedBox(height: 12),
                  Text('Distancia total estimada: 18.5 km • Tiempo estimado: 45 min', style: TextStyle(color: AppColors.emerald, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
