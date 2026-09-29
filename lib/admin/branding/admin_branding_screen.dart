import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AdminBrandingScreen extends StatefulWidget {
  const AdminBrandingScreen({super.key});

  @override
  State<AdminBrandingScreen> createState() => _AdminBrandingScreenState();
}

class _AdminBrandingScreenState extends State<AdminBrandingScreen> {
  final Color _primaryColor = AppColors.deepForest;
  final Color _secondaryColor = AppColors.emerald;
  final Color _accentColor = AppColors.freshGreen;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Branding Dinámico', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
          const SizedBox(height: 6),
          const Text('Sube y gestiona logos, imágenes de portada y colores de marca.', style: TextStyle(color: AppColors.muted)),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Logotipos e Iconos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildImageUploader('Logo Light', Icons.image_outlined),
                      const SizedBox(width: 16),
                      _buildImageUploader('Logo Dark', Icons.dark_mode_outlined),
                      const SizedBox(width: 16),
                      _buildImageUploader('App Icon', Icons.crop_square_rounded),
                    ],
                  ),
                  const Divider(height: 32),
                  const Text('Paleta de Colores de Marca', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildColorPicker('Color Primario', _primaryColor),
                      const SizedBox(width: 16),
                      _buildColorPicker('Color Secundario', _secondaryColor),
                      const SizedBox(width: 16),
                      _buildColorPicker('Color Acento', _accentColor),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Configuración de Branding guardada exitosamente.')),
                      );
                    },
                    child: const Text('Guardar y Aplicar Cambios'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploader(String label, IconData icon) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.deepForest, size: 32),
              const SizedBox(height: 4),
              const Text('Subir', style: TextStyle(fontSize: 11, color: AppColors.muted)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }

  Widget _buildColorPicker(String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Container(
          width: 80,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black12),
          ),
        ),
      ],
    );
  }
}
