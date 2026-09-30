import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'Reserva confirmada',
        'body': 'Tu servicio de fumigación para Finca El Paraíso ha sido confirmado.',
        'time': 'Hace 10 min',
        'icon': Icons.check_circle_outline,
      },
      {
        'title': 'Dron en camino',
        'body': 'El operador asignado va en ruta a tu parcela.',
        'time': 'Hace 1 hora',
        'icon': Icons.flight_takeoff_rounded,
      },
      {
        'title': 'Promoción de temporada',
        'body': '10% de descuento en fertilización foliar para maíz.',
        'time': 'Ayer',
        'icon': Icons.local_offer_outlined,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Notificaciones')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.softGreen,
                child: Icon(item['icon'] as IconData, color: AppColors.deepForest),
              ),
              title: Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(item['body'] as String, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                  const SizedBox(height: 4),
                  Text(item['time'] as String, style: const TextStyle(fontSize: 10, color: AppColors.emerald)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
