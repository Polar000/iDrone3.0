import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Soporte y Ayuda')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.deepForest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: const [
                  Icon(Icons.headset_mic_rounded, color: AppColors.freshGreen, size: 48),
                  SizedBox(height: 12),
                  Text('¿Necesitas ayuda con tu servicio?', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 6),
                  Text('Nuestro equipo está listo para asistirte en todo momento.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.cream, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildContactCard(
                    icon: Icons.chat_outlined,
                    title: 'WhatsApp',
                    subtitle: '+502 5555 1234',
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildContactCard(
                    icon: Icons.phone_outlined,
                    title: 'Llamar',
                    subtitle: '+502 5555 1234',
                    color: AppColors.emerald,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Enviar mensaje de soporte', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.dark)),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Asunto'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Escribe tu mensaje o problema...'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mensaje enviado. Un agente se pondrá en contacto pronto.')),
                  );
                },
                child: const Text('Enviar consulta'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({required IconData icon, required String title, required String subtitle, required Color color}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
