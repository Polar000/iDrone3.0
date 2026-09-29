import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class OperatorDashboardScreen extends StatefulWidget {
  const OperatorDashboardScreen({super.key});

  @override
  State<OperatorDashboardScreen> createState() => _OperatorDashboardScreenState();
}

class _OperatorDashboardScreenState extends State<OperatorDashboardScreen> {
  final List<Map<String, dynamic>> _jobs = [
    {
      'id': 'JOB-101',
      'customer': 'Bryan Morales',
      'phone': '+502 5555 1234',
      'farm': 'Finca El Paraíso',
      'field': 'Parcela Norte',
      'crop': 'Maíz',
      'service': 'Fumigación',
      'area': '12.60 manzanas',
      'time': '08:00 AM',
      'status': 'assigned',
      'photosCount': 0,
    },
    {
      'id': 'JOB-102',
      'customer': 'Mario Estrada',
      'phone': '+502 5555 9876',
      'farm': 'Finca San José',
      'field': 'Lote 3',
      'crop': 'Melón',
      'service': 'Fertilización foliar',
      'area': '8.50 manzanas',
      'time': '11:30 AM',
      'status': 'assigned',
      'photosCount': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Panel de Operador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.deepForest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.freshGreen,
                    child: Icon(Icons.person, color: AppColors.dark),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Carlos Ramos', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Operador iDrone • Zona Jutiapa', style: TextStyle(color: AppColors.cream, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Trabajos Asignados para Hoy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.dark)),
            const SizedBox(height: 12),

            ..._jobs.map((job) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(job['id'] as String, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.emerald)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.softGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              job['status'] == 'assigned'
                                  ? 'Asignado'
                                  : job['status'] == 'en_route'
                                      ? 'En camino'
                                      : job['status'] == 'in_progress'
                                          ? 'En ejecución'
                                          : 'Completado',
                              style: const TextStyle(color: AppColors.deepForest, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('${job['customer']} (${job['phone']})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('${job['farm']} — ${job['field']}', style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Chip(label: Text('${job['service']}'), backgroundColor: AppColors.cream),
                          const SizedBox(width: 6),
                          Chip(label: Text('${job['crop']}'), backgroundColor: AppColors.cream),
                          const SizedBox(width: 6),
                          Chip(label: Text('${job['area']}'), backgroundColor: AppColors.cream),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _updateStatus(job, 'en_route'),
                              icon: const Icon(Icons.navigation_rounded, size: 18),
                              label: const Text('En camino'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _openJobDetail(job),
                              icon: const Icon(Icons.assignment_rounded, size: 18),
                              label: const Text('Gestionar'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _updateStatus(Map<String, dynamic> job, String newStatus) {
    setState(() {
      job['status'] = newStatus;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Estado de ${job['id']} actualizado a $newStatus.')),
    );
  }

  void _openJobDetail(Map<String, dynamic> job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Gestionar Trabajo ${job['id']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 8),
                Text('Cliente: ${job['customer']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Ubicación: ${job['farm']} — ${job['field']}'),
                Text('Servicio: ${job['service']} • ${job['crop']} • ${job['area']}'),
                const SizedBox(height: 16),
                const Text('Actualizar Estado Operativo:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('En camino'),
                      selected: job['status'] == 'en_route',
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => job['status'] = 'en_route');
                          setModalState(() {});
                        }
                      },
                    ),
                    ChoiceChip(
                      label: const Text('En sitio'),
                      selected: job['status'] == 'in_site',
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => job['status'] = 'in_site');
                          setModalState(() {});
                        }
                      },
                    ),
                    ChoiceChip(
                      label: const Text('En aplicación'),
                      selected: job['status'] == 'in_progress',
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => job['status'] = 'in_progress');
                          setModalState(() {});
                        }
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Completado'),
                      selected: job['status'] == 'completed',
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => job['status'] = 'completed');
                          setModalState(() {});
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Fotografías del Servicio (Antes, Durante, Después):', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          job['photosCount'] = (job['photosCount'] as int) + 1;
                        });
                        setModalState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fotografía adjuntada con éxito.')),
                        );
                      },
                      icon: const Icon(Icons.camera_alt_rounded),
                      label: const Text('Agregar Foto'),
                    ),
                    const SizedBox(width: 12),
                    Text('${job['photosCount']} fotos adjuntadas', style: const TextStyle(color: AppColors.muted)),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Guardar y Cerrar'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
