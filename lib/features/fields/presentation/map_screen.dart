import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/area_converter.dart';
import '../../../core/services/work_duration_calculator.dart';

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
  bool _showNdviOverlay = false;
  bool _isSavingToDb = false;

  final List<LatLng> _polygonPoints = [];

  List<Map<String, dynamic>> _existingParcels = [];
  bool _isLoadingParcels = false;
  String? _editingParcelId;

  @override
  void initState() {
    super.initState();
    _fetchParcelsFromSupabase();
  }

  Future<void> _fetchParcelsFromSupabase() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) {
      if (mounted) {
        setState(() {
          _existingParcels = [];
          _isLoadingParcels = false;
        });
      }
      return;
    }

    setState(() => _isLoadingParcels = true);

    try {
      final response = await supabase
          .from('fields')
          .select('id, name, geometry, area_m2, farm:farms(name)')
          .order('created_at', ascending: false);

      final List<Map<String, dynamic>> loaded = [];

      for (final item in response as List) {
        final points = _parsePolygon(item['geometry']);
        if (points.isNotEmpty) {
          loaded.add({
            'id': item['id'],
            'name': item['name'] ?? 'Parcela sin nombre',
            'farm': item['farm'] != null ? item['farm']['name'] : 'Finca Principal',
            'areaM2': (item['area_m2'] as num?)?.toDouble() ?? 0.0,
            'points': points,
          });
        }
      }

      if (mounted) {
        setState(() {
          _existingParcels = loaded;
          _isLoadingParcels = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _existingParcels = [];
          _isLoadingParcels = false;
        });
      }
    }
  }

  Future<void> _deleteParcelFromSupabase(String parcelId, String parcelName) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('¿Eliminar Parcela?', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.dark)),
        content: Text('¿Estás seguro de que deseas eliminar "$parcelName"? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar', style: TextStyle(color: AppColors.muted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final supabase = Supabase.instance.client;
    try {
      await supabase.from('fields').delete().eq('id', parcelId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ Parcela "$parcelName" eliminada correctamente.'),
            backgroundColor: AppColors.emerald,
          ),
        );
        setState(() {
          if (_editingParcelId == parcelId) {
            _editingParcelId = null;
            _polygonPoints.clear();
          }
        });
        await _fetchParcelsFromSupabase();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar la parcela: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  List<LatLng> _parsePolygon(dynamic geometryData) {
    if (geometryData == null) return [];
    final String raw = geometryData.toString().trim();
    if (raw.isEmpty) return [];

    try {
      // 1. Try parsing standard GeoJSON Map if Supabase returns parsed GeoJSON object
      if (geometryData is Map<String, dynamic> && geometryData.containsKey('coordinates')) {
        final coords = geometryData['coordinates'];
        if (coords is List && coords.isNotEmpty && coords[0] is List) {
          final ring = coords[0] as List;
          final List<LatLng> result = [];
          for (final pt in ring) {
            if (pt is List && pt.length >= 2) {
              final double lon = (pt[0] as num).toDouble();
              final double lat = (pt[1] as num).toDouble();
              result.add(LatLng(lat, lon));
            }
          }
          return result;
        }
      }

      // 2. Try parsing GeoJSON JSON string representation
      if (raw.startsWith('{') && raw.contains('"coordinates"')) {
        final int coordIdx = raw.indexOf('"coordinates"');
        final int startBracket = raw.indexOf('[', coordIdx);
        if (startBracket != -1) {
          final int endBracket = raw.lastIndexOf(']');
          if (endBracket > startBracket) {
            final String coordStr = raw.substring(startBracket, endBracket + 1);
            // Quick extraction of coordinate numbers from string
            final RegExp numPairRegex = RegExp(r'\[\s*(-?\d+(?:\.\d+)?)\s*,\s*(-?\d+(?:\.\d+)?)\s*\]');
            final matches = numPairRegex.allMatches(coordStr);
            if (matches.isNotEmpty) {
              final List<LatLng> result = [];
              for (final m in matches) {
                final double lon = double.parse(m.group(1)!);
                final double lat = double.parse(m.group(2)!);
                result.add(LatLng(lat, lon));
              }
              return result;
            }
          }
        }
      }

      // 3. Try parsing WKT format (e.g. "SRID=4326;POLYGON((lon lat, lon lat...))" or "POLYGON((...))")
      if (raw.toUpperCase().contains('POLYGON')) {
        final startIndex = raw.indexOf('((');
        final endIndex = raw.indexOf('))');
        if (startIndex != -1 && endIndex != -1) {
          final content = raw.substring(startIndex + 2, endIndex);
          final pairs = content.split(',');
          final List<LatLng> result = [];

          for (final pair in pairs) {
            final coords = pair.trim().split(RegExp(r'\s+'));
            if (coords.length >= 2) {
              final lon = double.parse(coords[0]);
              final lat = double.parse(coords[1]);
              result.add(LatLng(lat, lon));
            }
          }
          return result;
        }
      }

      // 4. Try parsing PostGIS EWKB Hex String (e.g. "0103000020E610000001000000...")
      final String hexStr = raw.replaceAll(RegExp(r'\s+'), '');
      if (RegExp(r'^[0-9a-fA-F]+$').hasMatch(hexStr) && hexStr.length >= 50) {
        final List<int> bytes = [];
        for (int i = 0; i < hexStr.length; i += 2) {
          bytes.add(int.parse(hexStr.substring(i, i + 2), radix: 16));
        }
        if (bytes.length >= 25) {
          final isLittleEndian = bytes[0] == 1;
          int offset = 1;

          int readUint32() {
            final bd = ByteData.sublistView(Uint8List.fromList(bytes.sublist(offset, offset + 4)));
            offset += 4;
            return bd.getUint32(0, isLittleEndian ? Endian.little : Endian.big);
          }

          double readFloat64() {
            final bd = ByteData.sublistView(Uint8List.fromList(bytes.sublist(offset, offset + 8)));
            offset += 8;
            return bd.getFloat64(0, isLittleEndian ? Endian.little : Endian.big);
          }

          final geomType = readUint32();
          final bool hasSrid = (geomType & 0x20000000) != 0;
          if (hasSrid) {
            offset += 4; // Skip SRID integer
          }

          final numRings = readUint32();
          if (numRings > 0 && numRings < 100) {
            final numPoints = readUint32();
            final List<LatLng> result = [];
            for (int i = 0; i < numPoints; i++) {
              if (offset + 16 > bytes.length) break;
              final lon = readFloat64();
              final lat = readFloat64();
              result.add(LatLng(lat, lon));
            }
            if (result.isNotEmpty) return result;
          }
        }
      }

      // 5. Fallback: search for any sequence of lon,lat coordinate pairs
      final RegExp pairRegex = RegExp(r'(-?\d+\.\d+)\s*,\s*(-?\d+\.\d+)');
      final matches = pairRegex.allMatches(raw);
      if (matches.isNotEmpty) {
        final List<LatLng> result = [];
        for (final m in matches) {
          final double p1 = double.parse(m.group(1)!);
          final double p2 = double.parse(m.group(2)!);
          // Check latitude (-90 to 90) vs longitude (-180 to 180)
          if (p1.abs() <= 90 && p2.abs() <= 180) {
            result.add(LatLng(p1, p2));
          } else {
            result.add(LatLng(p2, p1));
          }
        }
        return result;
      }
    } catch (_) {}

    return [];
  }

  void _selectParcelForEditing(Map<String, dynamic> parcel) {
    setState(() {
      _editingParcelId = parcel['id']?.toString();
      _parcelNameController.text = parcel['name'] as String;
      _polygonPoints.clear();
      _polygonPoints.addAll(List<LatLng>.from(parcel['points'] as List));
    });
    if ((parcel['points'] as List<LatLng>).isNotEmpty) {
      _mapController.move(parcel['points'][0] as LatLng, 15.5);
    }
  }

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

  double _calculatePolygonPerimeterMeters(List<LatLng> points) {
    if (points.length < 2) return 0.0;
    const Distance distance = Distance();
    double total = 0.0;
    for (int i = 0; i < points.length; i++) {
      final next = (i + 1) % points.length;
      total += distance.as(LengthUnit.Meter, points[i], points[next]);
    }
    return total;
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

  Future<void> _saveParcelToSupabase(String name, double areaM2) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes iniciar sesión para guardar parcelas en la base de datos.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isSavingToDb = true);
    final areaManzanas = AreaConverter.squareMetersToManzanas(areaM2);
    final areaHectares = AreaConverter.squareMetersToHectares(areaM2);

    try {
      // 1. Construct WKT polygon string
      final coords = _polygonPoints.map((p) => '${p.longitude} ${p.latitude}').join(', ');
      final firstPoint = '${_polygonPoints.first.longitude} ${_polygonPoints.first.latitude}';
      final wktPolygon = 'SRID=4326;POLYGON(($coords, $firstPoint))';

      if (_editingParcelId != null && !_editingParcelId!.startsWith('demo-')) {
        // UPDATE existing parcel
        await supabase.from('fields').update({
          'name': name,
          'geometry': wktPolygon,
          'area_m2': areaM2,
          'area_ha': areaHectares,
          'area_manzanas': areaManzanas,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', _editingParcelId!);
      } else {
        // INSERT new parcel
        String farmId;
        final existingFarms = await supabase.from('farms').select('id').eq('owner_id', user.id).limit(1);

        if (existingFarms is List && existingFarms.isNotEmpty) {
          farmId = existingFarms.first['id'];
        } else {
          final newFarm = await supabase.from('farms').insert({
            'owner_id': user.id,
            'name': 'Finca El Paraíso',
            'description': 'Finca principal registrada en iDrone',
            'location': 'Jutiapa, Guatemala',
          }).select('id').single();
          farmId = newFarm['id'];
        }

        await supabase.from('fields').insert({
          'farm_id': farmId,
          'name': name,
          'geometry': wktPolygon,
          'area_m2': areaM2,
          'area_ha': areaHectares,
          'area_manzanas': areaManzanas,
          'notes': 'Creada desde el mapa interactivo iDrone.',
        });
      }

      await _fetchParcelsFromSupabase();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_editingParcelId != null
              ? '✓ Parcela "$name" actualizada exitosamente en Supabase.'
              : '✓ Parcela "$name" guardada exitosamente en Supabase (${areaManzanas.toStringAsFixed(2)} mz).'),
          backgroundColor: AppColors.emerald,
        ),
      );

      setState(() {
        _editingParcelId = null;
        _polygonPoints.clear();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar la parcela en Supabase: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
          action: SnackBarAction(
            label: 'Reintentar',
            textColor: AppColors.white,
            onPressed: () => _saveParcelToSupabase(name, areaM2),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSavingToDb = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentAreaM2 = _calculatePolygonAreaM2(_polygonPoints);
    final currentPerimeterMeters = _calculatePolygonPerimeterMeters(_polygonPoints);
    final areaManzanas = AreaConverter.squareMetersToManzanas(currentAreaM2);
    final areaHectares = AreaConverter.squareMetersToHectares(currentAreaM2);
    final durationResult = WorkDurationCalculator.calculateDuration(
      areaM2: currentAreaM2,
      serviceType: 'fumigation',
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.dark.withValues(alpha: 0.75),
        elevation: 0,
        title: Text(
          widget.isSelectionMode ? 'Dibujar Parcela' : 'Mapa de Fincas y Parcelas',
          style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          IconButton(
            icon: Icon(
              _showNdviOverlay ? Icons.eco_rounded : Icons.eco_outlined,
              color: _showNdviOverlay ? AppColors.freshGreen : AppColors.white,
            ),
            tooltip: _showNdviOverlay ? 'Desactivar Capa NDVI' : 'Activar Capa NDVI (Salud Vegetal)',
            onPressed: () {
              setState(() {
                _showNdviOverlay = !_showNdviOverlay;
              });
            },
          ),
          IconButton(
            icon: Icon(
              _showExistingParcels ? Icons.layers_rounded : Icons.layers_clear_rounded,
              color: AppColors.white,
            ),
            tooltip: _showExistingParcels ? 'Ocultar parcelas guardadas' : 'Mostrar parcelas guardadas',
            onPressed: () {
              setState(() {
                _showExistingParcels = !_showExistingParcels;
              });
            },
          ),
          IconButton(
            icon: Icon(
              _isSatellite ? Icons.map_rounded : Icons.satellite_alt_rounded,
              color: AppColors.white,
            ),
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
                    ..._existingParcels.map((parcel) {
                      final isBeingEdited = parcel['id']?.toString() == _editingParcelId;
                      if (isBeingEdited) return null;
                      return Polygon(
                        points: parcel['points'] as List<LatLng>,
                        color: _showNdviOverlay
                            ? Colors.green.withValues(alpha: 0.6)
                            : AppColors.forest.withValues(alpha: 0.35),
                        borderColor: _showNdviOverlay ? Colors.limeAccent : AppColors.freshGreen,
                        borderStrokeWidth: 2.5,
                        isFilled: true,
                      );
                    }).whereType<Polygon>(),
                  if (_polygonPoints.length >= 3)
                    Polygon(
                      points: _polygonPoints,
                      color: _showNdviOverlay
                          ? Colors.lightGreenAccent.withValues(alpha: 0.5)
                          : AppColors.freshGreen.withValues(alpha: 0.4),
                      borderColor: AppColors.lime,
                      borderStrokeWidth: 3.0,
                      isFilled: true,
                    ),
                ],
              ),
              MarkerLayer(
                markers: [
                  if (_showExistingParcels)
                    ..._existingParcels.map((parcel) {
                      final points = parcel['points'] as List<LatLng>;
                      if (points.isEmpty) return null;
                      final centerLat = points.map((p) => p.latitude).reduce((a, b) => a + b) / points.length;
                      final centerLng = points.map((p) => p.longitude).reduce((a, b) => a + b) / points.length;
                      final center = LatLng(centerLat, centerLng);
                      final pId = parcel['id']?.toString() ?? '';
                      final pName = parcel['name'] as String? ?? 'Parcela';

                      return Marker(
                        point: center,
                        width: 170,
                        height: 42,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.dark.withValues(alpha: 0.90),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.freshGreen, width: 1.2),
                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () => _selectParcelForEditing(parcel),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.edit_location_alt_rounded, color: AppColors.freshGreen, size: 15),
                                    const SizedBox(width: 4),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 85),
                                      child: Text(
                                        pName,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: AppColors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(height: 14, width: 1, color: Colors.white24),
                              const SizedBox(width: 2),
                              InkWell(
                                onTap: () => _deleteParcelFromSupabase(pId, pName),
                                child: const Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).whereType<Marker>(),
                ],
              ),
              MarkerLayer(
                markers: [
                  ..._polygonPoints.asMap().entries.map((entry) {
                    final index = entry.key;
                    final point = entry.value;
                    return Marker(
                      point: point,
                      width: 28,
                      height: 28,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.deepForest, width: 3.0),
                          boxShadow: const [
                            BoxShadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 3)),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
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

          // Floating Controls
          Positioned(
            top: 100,
            right: 16,
            child: Column(
              children: [
                _FloatingMapButton(
                  icon: Icons.add,
                  onPressed: () {
                    _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom + 0.5,
                    );
                  },
                ),
                const SizedBox(height: 10),
                _FloatingMapButton(
                  icon: Icons.remove,
                  onPressed: () {
                    _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom - 0.5,
                    );
                  },
                ),
                const SizedBox(height: 10),
                _FloatingMapButton(
                  icon: Icons.my_location_rounded,
                  iconColor: AppColors.emerald,
                  onPressed: () {
                    _mapController.move(_initialCenter, 15.0);
                  },
                ),
              ],
            ),
          ),

          // HUD Top Pill
          Positioned(
            top: 100,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.dark.withValues(alpha: 0.88),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.freshGreen.withValues(alpha: 0.4), width: 1.2),
                    boxShadow: AppColors.modernShadow(blur: 12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.gps_fixed_rounded, color: AppColors.freshGreen, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'RTK Telemetría: 14.2818° N, 89.8953° W',
                        style: TextStyle(color: AppColors.cream, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                if (_showNdviOverlay) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.deepForest.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.freshGreen),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.eco_rounded, color: AppColors.freshGreen, size: 14),
                        SizedBox(width: 6),
                        Text(
                          'NDVI Vegetal: 0.78 (Salud Óptima)',
                          style: TextStyle(color: AppColors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Bottom Sheet Polygon Stats HUD
          Positioned(
            left: 16,
            right: 16,
            bottom: 95,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.96),
                borderRadius: BorderRadius.circular(28),
                boxShadow: AppColors.modernShadow(
                  color: AppColors.dark.withValues(alpha: 0.15),
                  blur: 24,
                ),
                border: Border.all(color: AppColors.emerald.withValues(alpha: 0.25), width: 1.5),
              ),
              padding: const EdgeInsets.all(20.0),
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
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppColors.borderLight),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppColors.emerald, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Área en Tiempo Real',
                            style: TextStyle(color: AppColors.muted, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${areaManzanas.toStringAsFixed(2)} manzanas',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.deepForest,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            '(${areaHectares.toStringAsFixed(2)} ha • ${currentAreaM2.toStringAsFixed(0)} m²)',
                            style: const TextStyle(color: AppColors.muted, fontSize: 11),
                          ),
                          if (_polygonPoints.length >= 3) ...[
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.softGreen,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.timer_outlined, size: 13, color: AppColors.deepForest),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Est. Vuelo: ~${durationResult.formattedTotalTime}',
                                    style: const TextStyle(
                                      color: AppColors.deepForest,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (_polygonPoints.isNotEmpty)
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.cream,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.undo_rounded, color: AppColors.dark, size: 20),
                                tooltip: 'Deshacer punto',
                                onPressed: _undoLastVertex,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                                tooltip: 'Limpiar mapa',
                                onPressed: _clearPolygon,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _polygonPoints.length >= 3 ? AppColors.emerald : AppColors.muted,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: _polygonPoints.length >= 3 ? 3 : 0,
                      ),
                      onPressed: (_polygonPoints.length >= 3 && !_isSavingToDb)
                          ? () async {
                              final name = _parcelNameController.text.trim().isEmpty
                                  ? 'Nueva Parcela'
                                  : _parcelNameController.text.trim();

                              await _saveParcelToSupabase(name, currentAreaM2);

                              if (widget.onPolygonSaved != null) {
                                widget.onPolygonSaved!(_polygonPoints, currentAreaM2, name);
                              }
                            }
                          : null,
                      icon: _isSavingToDb
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2))
                          : const Icon(Icons.check_circle_outline_rounded, size: 20),
                      label: Text(
                        _polygonPoints.length < 3
                            ? 'Toca el mapa para agregar puntos (mín. 3)'
                            : (_isSavingToDb ? 'Guardando en Supabase...' : 'Guardar Parcela'),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingMapButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color iconColor;

  const _FloatingMapButton({
    required this.icon,
    required this.onPressed,
    this.iconColor = AppColors.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        boxShadow: AppColors.modernShadow(blur: 12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: iconColor, size: 22),
        onPressed: onPressed,
      ),
    );
  }
}
