import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
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
                  Text('Sube imágenes directamente desde tu equipo o edita URLs almacenadas en la base de datos.', style: TextStyle(color: AppColors.muted)),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emerald,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onPressed: () => _showAddMediaDialog(context),
                icon: const Icon(Icons.add_photo_alternate_rounded, color: AppColors.white),
                label: const Text('Registrar / Subir Nuevo Asset', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
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
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.cream,
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: _buildMediaPreview(url),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.dark)),
                            const SizedBox(height: 2),
                            Text(
                              url.startsWith('data:image') ? 'Data URL (Imagen Local Base64 Cargada)' : url,
                              style: const TextStyle(color: AppColors.muted, fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.drive_folder_upload_rounded, color: AppColors.forest),
                        tooltip: 'Cargar Archivo desde el Equipo',
                        onPressed: () => _pickAndUploadLocalFile(key),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_rounded, color: AppColors.emerald),
                        tooltip: 'Editar URL manualmente',
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

  Widget _buildMediaPreview(String url) {
    if (url.startsWith('data:image')) {
      try {
        final base64Str = url.split(',').last;
        final bytes = base64Decode(base64Str);
        return Image.memory(bytes, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image_rounded, color: AppColors.muted));
      } catch (e) {
        return const Icon(Icons.broken_image_rounded, color: AppColors.muted);
      }
    } else if (url.startsWith('http://') || url.startsWith('https://')) {
      return Image.network(url, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image_rounded, color: AppColors.muted));
    } else {
      return Image.asset(url, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image_rounded, color: AppColors.muted));
    }
  }

  Future<void> _pickAndUploadLocalFile(String key) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      if (file.bytes != null) {
        final ext = file.extension ?? 'png';
        final base64String = base64Encode(file.bytes!);
        final dataUrl = 'data:image/$ext;base64,$base64String';

        _mediaService.updateMediaRecord(key, dataUrl);
        setState(() {});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Imagen "${file.name}" cargada desde tu equipo para el asset "$key"!'),
            backgroundColor: AppColors.emerald,
          ),
        );
      }
    }
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'URL o Path de la imagen (HTTP, Data URL o Asset local)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.emerald),
              ),
              onPressed: () async {
                Navigator.pop(context);
                await _pickAndUploadLocalFile(key);
              },
              icon: const Icon(Icons.upload_file_rounded, color: AppColors.emerald),
              label: const Text('Cargar Archivo desde mi Equipo', style: TextStyle(color: AppColors.emerald, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              _mediaService.updateMediaRecord(key, controller.text.trim());
              setState(() {});
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Asset "$key" actualizado en la base de datos.')),
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
    String? selectedDataUrl;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Registrar / Subir Nuevo Asset'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: keyController,
                  decoration: const InputDecoration(labelText: 'Clave del Asset (ej. hero_summer_2026)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: urlController,
                  decoration: const InputDecoration(labelText: 'URL / Path de Supabase Storage'),
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.forest,
                    foregroundColor: AppColors.white,
                  ),
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                      withData: true,
                    );
                    if (result != null && result.files.isNotEmpty) {
                      final file = result.files.first;
                      if (file.bytes != null) {
                        final ext = file.extension ?? 'png';
                        final base64Str = base64Encode(file.bytes!);
                        selectedDataUrl = 'data:image/$ext;base64,$base64Str';
                        urlController.text = selectedDataUrl!;
                        setDialogState(() {});
                      }
                    }
                  },
                  icon: const Icon(Icons.folder_open_rounded),
                  label: const Text('Seleccionar Archivo de mi Equipo'),
                ),
                if (selectedDataUrl != null) ...[
                  const SizedBox(height: 8),
                  const Text('✓ Archivo local cargado con éxito', style: TextStyle(color: AppColors.emerald, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
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
          );
        },
      ),
    );
  }
}
