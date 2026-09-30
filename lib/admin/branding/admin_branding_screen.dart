import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AdminBrandingScreen extends StatefulWidget {
  const AdminBrandingScreen({super.key});

  @override
  State<AdminBrandingScreen> createState() => _AdminBrandingScreenState();
}

class _AdminBrandingScreenState extends State<AdminBrandingScreen> {
  Color _primaryColor = AppColors.deepForest;
  Color _secondaryColor = AppColors.emerald;
  Color _accentColor = AppColors.freshGreen;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Branding Dinámico & Vista en Vivo', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
          const SizedBox(height: 6),
          const Text('Sube y gestiona logos, imágenes de portada y colores de marca con previsualización en tiempo real.', style: TextStyle(color: AppColors.muted)),
          const SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Card(
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
                            _buildColorPicker('Color Primario', _primaryColor, (c) => setState(() => _primaryColor = c)),
                            const SizedBox(width: 16),
                            _buildColorPicker('Color Secundario', _secondaryColor, (c) => setState(() => _secondaryColor = c)),
                            const SizedBox(width: 16),
                            _buildColorPicker('Color Acento', _accentColor, (c) => setState(() => _accentColor = c)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Configuración de Branding guardada y transmitida a la app cliente.')),
                            );
                          },
                          child: const Text('Guardar y Aplicar Cambios'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // Live Mobile Mockup Previewer
              Expanded(
                flex: 2,
                child: Card(
                  color: AppColors.dark,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Mockup en Vivo', style: TextStyle(color: AppColors.cream, fontWeight: FontWeight.bold, fontSize: 13)),
                            Icon(Icons.phone_iphone_rounded, color: AppColors.freshGreen, size: 20),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          height: 320,
                          decoration: BoxDecoration(
                            color: AppColors.cream,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _accentColor, width: 2),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: _primaryColor,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                                ),
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: AppColors.white,
                                      child: Text('iD', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.dark)),
                                    ),
                                    const SizedBox(width: 8),
                                    Text('iDrone Preview', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: _secondaryColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Servicios Agrícolas', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(color: _accentColor, borderRadius: BorderRadius.circular(6)),
                                            child: const Text('CTA Button', style: TextStyle(color: AppColors.dark, fontSize: 10, fontWeight: FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text('Vista previa en smartphone', style: TextStyle(fontSize: 11, color: AppColors.muted)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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

  Widget _buildColorPicker(String label, Color currentColor, Function(Color) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        InkWell(
          onTap: () {
            // Cycle color for demo selection
            if (currentColor == AppColors.deepForest) {
              onSelect(const Color(0xFF0F4C3A));
            } else if (currentColor == AppColors.emerald) {
              onSelect(const Color(0xFF10B981));
            } else {
              onSelect(const Color(0xFFA3E635));
            }
          },
          child: Container(
            width: 80,
            height: 40,
            decoration: BoxDecoration(
              color: currentColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12),
            ),
          ),
        ),
      ],
    );
  }
}
