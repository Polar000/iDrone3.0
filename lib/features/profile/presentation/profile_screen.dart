import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Mi Perfil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.deepForest,
              child: Text('BM', style: TextStyle(color: AppColors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            const Text('Bryan Morales', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.dark)),
            const Text('bryan@example.com • +502 5555 1234', style: TextStyle(color: AppColors.muted, fontSize: 13)),
            const SizedBox(height: 24),
            _buildProfileOption(Icons.person_outline, 'Mis datos', () {}),
            _buildProfileOption(Icons.landscape_outlined, 'Mis fincas y parcelas', () => context.push('/map')),
            _buildProfileOption(Icons.credit_card_outlined, 'Métodos de pago', () {}),
            _buildProfileOption(Icons.notifications_none_outlined, 'Notificaciones', () => context.push('/notifications')),
            _buildProfileOption(Icons.headset_mic_outlined, 'Soporte y contacto', () => context.push('/support')),
            _buildProfileOption(Icons.admin_panel_settings_outlined, 'Panel de Administración (Web/Admin)', () => context.push('/admin')),
            _buildProfileOption(Icons.settings_outlined, 'Configuración', () {}),
            _buildProfileOption(Icons.privacy_tip_outlined, 'Privacidad y Términos', () {}),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent),
                ),
                onPressed: () => context.go('/login'),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Cerrar sesión'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.deepForest),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
        onTap: onTap,
      ),
    );
  }
}
