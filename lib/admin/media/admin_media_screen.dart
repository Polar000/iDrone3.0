import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../core/services/app_media_service.dart';

class AdminMediaScreen extends StatefulWidget {
  const AdminMediaScreen({super.key});

  @override
  State<AdminMediaScreen> createState() => _AdminMediaScreenState();
}

class _AdminMediaScreenState extends State<AdminMediaScreen> {
  final AppMediaService _mediaService = AppMediaService.instance;
  String _selectedCategory = 'todos';

  @override
  Widget build(BuildContext context) {
    final mediaMap = _mediaService.getAllMedia();

    final filteredKeys = mediaMap.keys.where((key) {
      if (_selectedCategory == 'todos') return true;
      if (_selectedCategory == 'branding') return key.contains('logo') || key.contains('splash');
      if (_selectedCategory == 'hero') return key.contains('hero');
      if (_selectedCategory == 'service') return key.contains('service');
      if (_selectedCategory == 'crop') return key.contains('crop');
      return true;
    }).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Gestión Dinámica de Medios y Assets', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
                  SizedBox(height: 4),
                  Text('Modifica las URLs de imágenes en la base de datos para actualizar la app sin recompilar.', style: TextStyle(color: AppColors.muted)),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emerald,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _showAddMediaDialog(context),
                icon: const Icon(Icons.add_photo_alternate_rounded, color: AppColors.white),
                label: const Text('Registrar Nuevo Asset', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Category Filter Bar
          Wrap(
            spacing: 10,
            children: [
              _buildCategoryChip('todos', 'Todos los Assets'),
              _buildCategoryChip('branding', 'Branding y Logos'),
              _buildCategoryChip('hero', 'Banners Principales'),
              _buildCategoryChip('service', 'Servicios'),
              _buildCategoryChip('crop', 'Cultivos'),
            ],
          ),
          const SizedBox(height: 16),

          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredKeys.length,
                separatorBuilder: (context, index) => const Divider(height: 20),
                itemBuilder: (context, index) {
                  final key = filteredKeys[index];
                  final url = mediaMap[key]!;

                  return Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.cream,
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          url,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image_rounded, color: AppColors.muted);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.dark)),
                            const SizedBox(height: 2),
                            Text(url, style: const TextStyle(color: AppColors.muted, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_rounded, color: AppColors.emerald),
                        tooltip: 'Editar URL en Base de Datos',
                        onPressed: () => _showEditDialog(context, key, url),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String id, String label) {
    final isSelected = _selectedCategory == id;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.emerald,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.white : AppColors.dark,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: AppColors.cream,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedCategory = id;
          });
        }
      },
    );
  }

  void _showEditDialog(BuildContext context, String key, String currentUrl) {
    final controller = TextEditingController(text: currentUrl);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Asset "$key"'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'URL o Path de la imagen en Supabase Storage',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              _mediaService.updateMediaRecord(key, controller.text.trim());
              setState(() {});
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Asset "$key" actualizado en base de datos.')),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showAddMediaDialog(BuildContext context) {
    final keyController = TextEditingController();
    final urlController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registrar Nuevo Asset'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: keyController,
              decoration: const InputDecoration(labelText: 'Clave del Asset (ej. hero_promo_summer)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(labelText: 'URL / Path Supabase Storage'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (keyController.text.isNotEmpty && urlController.text.isNotEmpty) {
                _mediaService.updateMediaRecord(keyController.text.trim(), urlController.text.trim());
                setState(() {});
                Navigator.pop(context);
              }
            },
            child: const Text('Registrar'),
          ),
        ],
      ),
    );
  }
}
