import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' hide Path;
import '../../app/theme/app_colors.dart';

class PolygonUtils {
  /// Parses standard GeoJSON, EWKB hex, WKT, or coordinate list string into `List<LatLng>`.
  static List<LatLng> parseGeometry(dynamic geometryData) {
    if (geometryData == null) return [];
    final String raw = geometryData.toString().trim();
    if (raw.isEmpty) return [];

    try {
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

      if (raw.startsWith('{') && raw.contains('"coordinates"')) {
        final int coordIdx = raw.indexOf('"coordinates"');
        final int startBracket = raw.indexOf('[', coordIdx);
        if (startBracket != -1) {
          final int endBracket = raw.lastIndexOf(']');
          if (endBracket > startBracket) {
            final String coordStr = raw.substring(startBracket, endBracket + 1);
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
          if (hasSrid) offset += 4;

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

      final RegExp pairRegex = RegExp(r'(-?\d+\.\d+)\s*,\s*(-?\d+\.\d+)');
      final matches = pairRegex.allMatches(raw);
      if (matches.isNotEmpty) {
        final List<LatLng> result = [];
        for (final m in matches) {
          final double p1 = double.parse(m.group(1)!);
          final double p2 = double.parse(m.group(2)!);
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
}

/// A widget that renders a vector thumbnail preview of a parcel polygon.
class ParcelPolygonThumbnail extends StatelessWidget {
  final List<LatLng> points;
  final double width;
  final double height;
  final Color fillColor;
  final Color borderColor;

  const ParcelPolygonThumbnail({
    super.key,
    required this.points,
    this.width = 70,
    this.height = 70,
    this.fillColor = AppColors.softGreen,
    this.borderColor = AppColors.emerald,
  });

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: const Icon(Icons.map_rounded, color: AppColors.muted, size: 28),
      );
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.freshGreen.withValues(alpha: 0.5), width: 1.5),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: CustomPaint(
        size: Size(width, height),
        painter: _PolygonPainter(
          points: points,
          fillColor: AppColors.freshGreen.withValues(alpha: 0.35),
          borderColor: AppColors.freshGreen,
        ),
      ),
    );
  }
}

class _PolygonPainter extends CustomPainter {
  final List<LatLng> points;
  final Color fillColor;
  final Color borderColor;

  _PolygonPainter({
    required this.points,
    required this.fillColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    // Draw background grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1.0;
    for (double i = 10; i < size.width; i += 15) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 10; i < size.height; i += 15) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    final latRange = maxLat - minLat == 0 ? 0.0001 : maxLat - minLat;
    final lngRange = maxLng - minLng == 0 ? 0.0001 : maxLng - minLng;

    const padding = 10.0;
    final drawWidth = size.width - (padding * 2);
    final drawHeight = size.height - (padding * 2);

    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      final x = padding + ((p.longitude - minLng) / lngRange) * drawWidth;
      // Invert Y axis for Latitudes
      final y = padding + (1.0 - (p.latitude - minLat) / latRange) * drawHeight;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);

    // Draw vertex dots
    final dotPaint = Paint()
      ..color = AppColors.lime
      ..style = PaintingStyle.fill;

    for (final p in points) {
      final x = padding + ((p.longitude - minLng) / lngRange) * drawWidth;
      final y = padding + (1.0 - (p.latitude - minLat) / latRange) * drawHeight;
      canvas.drawCircle(Offset(x, y), 2.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PolygonPainter oldDelegate) => true;
}
