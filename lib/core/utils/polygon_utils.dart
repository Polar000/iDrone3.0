import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class PolygonUtils {
  /// Parses geometry data from Supabase/PostGIS into a List of LatLng points.
  /// Handles GeoJSON Map, GeoJSON JSON string, PostGIS WKT, EWKT, PostGIS EWKB Hex, and raw pair strings.
  static List<LatLng> parsePolygon(dynamic geometryData) {
    if (geometryData == null) return [];
    final String raw = geometryData.toString().trim();
    if (raw.isEmpty) return [];

    try {
      // 1. GeoJSON Map
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

      // 2. GeoJSON JSON string
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

      // 3. WKT or EWKT POLYGON
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

      // 4. PostGIS EWKB Hex String
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
            offset += 4;
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

      // 5. Fallback coordinate pair matching
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

  /// Normalizes real GPS points onto a Canvas size box with padding.
  /// Preserves aspect ratio so the actual parcel boundary geometry is accurately drawn.
  static List<Offset> normalizePoints(List<LatLng> points, Size size, {double padding = 6.0}) {
    if (points.isEmpty) return [];

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final pt in points) {
      if (pt.latitude < minLat) minLat = pt.latitude;
      if (pt.latitude > maxLat) maxLat = pt.latitude;
      if (pt.longitude < minLng) minLng = pt.longitude;
      if (pt.longitude > maxLng) maxLng = pt.longitude;
    }

    final double latSpan = maxLat - minLat;
    final double lngSpan = maxLng - minLng;

    final double drawWidth = size.width - (padding * 2);
    final double drawHeight = size.height - (padding * 2);

    if (latSpan <= 0.0000001 || lngSpan <= 0.0000001) {
      // Degenerate or single point
      return points.map((_) => Offset(size.width / 2, size.height / 2)).toList();
    }

    final double scaleX = drawWidth / lngSpan;
    final double scaleY = drawHeight / latSpan;
    final double scale = min(scaleX, scaleY);

    final double actualWidth = lngSpan * scale;
    final double actualHeight = latSpan * scale;

    final double offsetX = padding + (drawWidth - actualWidth) / 2;
    final double offsetY = padding + (drawHeight - actualHeight) / 2;

    final List<Offset> normalized = [];
    for (final pt in points) {
      final double x = offsetX + ((pt.longitude - minLng) * scale);
      // Invert Y because Latitude increases going UP, while Canvas Y increases going DOWN
      final double y = size.height - (offsetY + ((pt.latitude - minLat) * scale));
      normalized.add(Offset(x, y));
    }

    return normalized;
  }
}
