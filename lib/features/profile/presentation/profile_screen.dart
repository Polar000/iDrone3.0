import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../app/theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _fullName = 'Usuario iDrone';
  String _email = 'usuario@idrone.gt';
  String _phone = '+502 5555 1234';
  String _initials = 'ID';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final metaName = (user.userMetadata?['full_name'] as String?)?.trim() ?? '';
        final metaPhone = (user.userMetadata?['phone'] as String?)?.trim() ?? '';
        final userEmail = user.email?.trim() ?? '';

        String name = metaName.isNotEmpty ? metaName : (userEmail.isNotEmpty ? userEmail.split('@').first : 'Usuario');

        List<String> parts = name.split(' ').where((s) => s.isNotEmpty).toList();
        String initials = 'ID';
        if (parts.length >= 2) {
          initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
        } else if (parts.isNotEmpty) {
          initials = parts[0].substring(0, min(2, parts[0].length)).toUpperCase();
        }

        if (mounted) {
          setState(() {
            _fullName = name;
            _email = userEmail.isNotEmpty ? userEmail : _email;
            _phone = metaPhone.isNotEmpty ? metaPhone : _phone;
            _initials = initials;
          });
        }
      }
    } catch (_) {}
  }

  Future<void> _handleSignOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (_) {}
    if (mounted) context.go('/login');
  }

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
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.deepForest,
              child: Text(_initials, style: const TextStyle(color: AppColors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            Text(_fullName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.dark)),
            Text('$_email • $_phone', style: const TextStyle(color: AppColors.muted, fontSize: 13)),
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
                onPressed: _handleSignOut,
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
