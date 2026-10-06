import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../app/theme/app_colors.dart';

class ServiceTrackingScreen extends StatefulWidget {
  const ServiceTrackingScreen({super.key});

  @override
  State<ServiceTrackingScreen> createState() => _ServiceTrackingScreenState();
}

class _ServiceTrackingScreenState extends State<ServiceTrackingScreen> {
  final MapController _mapController = MapController();
  final LatLng _parcelCenter = const LatLng(14.2850, -89.8920);
  final LatLng _operatorLocation = const LatLng(14.2820, -89.8960);

  final List<LatLng> _parcelPoints = [
    const LatLng(14.2860, -89.8930),
    const LatLng(14.2860, -89.8910),
    const LatLng(14.2840, -89.8910),
    const LatLng(14.2840, -89.8930),
  ];

  final List<String> _statuses = [
    'Preparando',
    'En camino',
    'En sitio',
    'Aplicando',
    'Finalizando',
    'Completado',
  ];

  int _currentStatusIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rastreo del Servicio'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _parcelCenter,
              initialZoom: 14.5,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                userAgentPackageName: 'com.idrone.app',
              ),
              PolygonLayer(
                polygons: [
                  Polygon(
                    points: _parcelPoints,
                    color: AppColors.freshGreen.withValues(alpha: 0.35),
                    borderColor: AppColors.lime,
                    borderStrokeWidth: 3,
                    isFilled: true,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _operatorLocation,
                    width: 44,
                    height: 44,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.deepForest,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.freshGreen, width: 2),
                        boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 6)],
                      ),
                      child: const Icon(Icons.flight_takeoff_rounded, color: AppColors.freshGreen, size: 24),
                    ),
                  ),
                ],
              ),
            ],
          ),

          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppColors.softGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.flight_takeoff_rounded, color: AppColors.deepForest, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _statuses[_currentStatusIndex],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.deepForest),
                          ),
                          const SizedBox(height: 2),
                          const Text('Llegada estimada en 15 min • Operador: Carlos Ramos', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Estado del servicio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.dark)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(_statuses.length, (index) {
                        final isDone = index <= _currentStatusIndex;
                        return Expanded(
                          child: Column(
                            children: [
                              Container(
                                height: 8,
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(
                                  color: isDone ? AppColors.emerald : AppColors.muted.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _statuses[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
                                  color: isDone ? AppColors.deepForest : AppColors.muted,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
