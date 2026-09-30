import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/area_converter.dart';

class MapScreen extends StatefulWidget {
  final bool isSelectionMode;
  final Function(List<LatLng> polygonPoints, double areaM2, String parcelName)? onPolygonSaved;

  const MapScreen({
    super.key,
    this.isSelectionMode = false,
    this.onPolygonSaved,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final LatLng _initialCenter = const LatLng(14.2818, -89.8953);
  final TextEditingController _parcelNameController = TextEditingController(text: 'Nueva Parcela');
  bool _isSatellite = true;
  bool _showExistingParcels = true;

  final List<LatLng> _polygonPoints = [];

  final List<Map<String, dynamic>> _existingParcels = [
    {
      'name': 'Parcela Norte',
      'farm': 'Finca El Paraíso',
      'crop': 'Maíz',
      'areaM2': 88060.0,
      'center': const LatLng(14.2850, -89.8920),
      'points': [
        const LatLng(14.2860, -89.8930),
        const LatLng(14.2860, -89.8910),
        const LatLng(14.2840, -89.8910),
        const LatLng(14.2840, -89.8930),
      ],
    },
    {
      'name': 'Lote 3',
      'farm': 'Finca San José',
      'crop': 'Melón',
      'areaM2': 59406.0,
      'center': const LatLng(14.2780, -89.8980),
      'points': [
        const LatLng(14.2790, -89.8990),
        const LatLng(14.2790, -89.8970),
        const LatLng(14.2770, -89.8970),
        const LatLng(14.2770, -89.8990),
      ],
    },
  ];

  @override
  void dispose() {
    _parcelNameController.dispose();
    super.dispose();
  }

  double _calculatePolygonAreaM2(List<LatLng> points) {
    if (points.length < 3) return 0.0;
    const double radiusOfEarth = 6378137.0;
    double area = 0.0;

    for (int i = 0; i < points.length; i++) {
      final j = (i + 1) % points.length;
      final p1 = points[i];
      final p2 = points[j];

      final lat1 = p1.latitude * pi / 180.0;
      final lat2 = p2.latitude * pi / 180.0;
      final lon1 = p1.longitude * pi / 180.0;
      final lon2 = p2.longitude * pi / 180.0;

      area += (lon2 - lon1) * (2 + sin(lat1) + sin(lat2));
    }

    area = area * radiusOfEarth * radiusOfEarth / 2.0;
    return area.abs();
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    setState(() {
      _polygonPoints.add(point);
    });
  }

  void _undoLastVertex() {
    if (_polygonPoints.isNotEmpty) {
      setState(() {
        _polygonPoints.removeLast();
      });
    }
  }

  void _clearPolygon() {
    setState(() {
      _polygonPoints.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentAreaM2 = _calculatePolygonAreaM2(_polygonPoints);
    final areaManzanas = AreaConverter.squareMetersToManzanas(currentAreaM2);
    final areaHectares = AreaConverter.squareMetersToHectares(currentAreaM2);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelectionMode ? 'Dibujar Parcela' : 'Mapa de Fincas y Parcelas'),
        actions: [
          IconButton(
            icon: Icon(_showExistingParcels ? Icons.layers_rounded : Icons.layers_clear_rounded),
            tooltip: _showExistingParcels ? 'Ocultar parcelas guardadas' : 'Mostrar parcelas guardadas',
            onPressed: () {
              setState(() {
                _showExistingParcels = !_showExistingParcels;
              });
            },
          ),
          IconButton(
            icon: Icon(_isSatellite ? Icons.map_rounded : Icons.satellite_alt_rounded),
            tooltip: _isSatellite ? 'Modo Normal' : 'Modo Satélite',
            onPressed: () {
              setState(() {
                _isSatellite = !_isSatellite;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialCenter,
              initialZoom: 14.5,
              onTap: _onMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate: _isSatellite
                    ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                    : 'https://tile.openstreetmap.org/{z}/{y}/{x}.png',
                userAgentPackageName: 'com.idrone.app',
              ),
              PolygonLayer(
                polygons: [
                  if (_showExistingParcels)
                    ..._existingParcels.map((parcel) => Polygon(
                          points: parcel['points'] as List<LatLng>,
                          color: AppColors.forest.withValues(alpha: 0.35),
                          borderColor: AppColors.freshGreen,
                          borderStrokeWidth: 2.5,
                          isFilled: true,
                        )),
                  if (_polygonPoints.length >= 3)
                    Polygon(
                      points: _polygonPoints,
                      color: AppColors.freshGreen.withValues(alpha: 0.4),
                      borderColor: AppColors.lime,
                      borderStrokeWidth: 3.0,
                      isFilled: true,
                    ),
                ],
              ),
              MarkerLayer(
                markers: [
                  ..._polygonPoints.asMap().entries.map((entry) {
                    final index = entry.key;
                    final point = entry.value;
                    return Marker(
                      point: point,
                      width: 24,
                      height: 24,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.deepForest, width: 2.5),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 4),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),

          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: 'zoom_in',
                  backgroundColor: AppColors.white,
                  child: const Icon(Icons.add, color: AppColors.dark),
                  onPressed: () {
                    _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom + 0.5,
                    );
                  },
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'zoom_out',
                  backgroundColor: AppColors.white,
                  child: const Icon(Icons.remove, color: AppColors.dark),
                  onPressed: () {
                    _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom - 0.5,
                    );
                  },
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'my_location',
                  backgroundColor: AppColors.white,
                  child: const Icon(Icons.my_location_rounded, color: AppColors.emerald),
                  onPressed: () {
                    _mapController.move(_initialCenter, 15.0);
                  },
                ),
              ],
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Card(
              elevation: 8,
              color: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_polygonPoints.length >= 3) ...[
                      TextField(
                        controller: _parcelNameController,
                        style: const TextStyle(color: AppColors.dark, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: 'Nombre de la parcela',
                          labelStyle: const TextStyle(color: AppColors.deepForest),
                          prefixIcon: const Icon(Icons.edit_location_alt_outlined, color: AppColors.emerald),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.borderLight),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.emerald, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Área seleccionada',
                              style: TextStyle(color: AppColors.muted, fontSize: 12),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${areaManzanas.toStringAsFixed(2)} manzanas',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.deepForest,
                              ),
                            ),
                            Text(
                              '(${areaHectares.toStringAsFixed(2)} hectáreas • ${currentAreaM2.toStringAsFixed(0)} m²)',
                              style: const TextStyle(color: AppColors.muted, fontSize: 11),
                            ),
                          ],
                        ),
                        if (_polygonPoints.isNotEmpty)
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.undo_rounded, color: AppColors.dark),
                                tooltip: 'Deshacer punto',
                                onPressed: _undoLastVertex,
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                                tooltip: 'Limpiar mapa',
                                onPressed: _clearPolygon,
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _polygonPoints.length >= 3 ? AppColors.emerald : AppColors.muted,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _polygonPoints.length >= 3
                            ? () {
                                final name = _parcelNameController.text.trim().isEmpty
                                    ? 'Nueva Parcela'
                                    : _parcelNameController.text.trim();
                                if (widget.onPolygonSaved != null) {
                                  widget.onPolygonSaved!(_polygonPoints, currentAreaM2, name);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Parcela "$name" guardada con ${areaManzanas.toStringAsFixed(2)} manzanas.',
                                      ),
                                    ),
                                  );
                                }
                              }
                            : null,
                        icon: const Icon(Icons.check_circle_outline_rounded),
                        label: Text(_polygonPoints.length < 3
                            ? 'Toca el mapa para agregar puntos (mín. 3)'
                            : 'Guardar Parcela'),
                      ),
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
