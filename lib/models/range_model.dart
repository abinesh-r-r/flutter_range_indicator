import 'package:flutter/material.dart';

/// Model representing a single range with its properties
class RangeModel {
  final double min;
  final double max;
  final String meaning;
  final Color color;

  RangeModel({
    required this.min,
    required this.max,
    required this.meaning,
    required this.color,
  });

  /// Parse range string (e.g., "0-6") into min and max integers
  static RangeModel fromJson(Map<String, dynamic> json) {
    final rangeString = json['range'] as String;
    final parts = rangeString.split('-');
    
    if (parts.length != 2) {
      throw FormatException('Invalid range format: $rangeString');
    }

    final min = double.parse(parts[0].trim());
    final max = double.parse(parts[1].trim());
    final meaning = json['meaning'] as String;
    final colorHex = json['color'] as String;

    return RangeModel(
      min: min,
      max: max,
      meaning: meaning,
      color: _hexToColor(colorHex),
    );
  }

  /// Convert hex color string (e.g., "#91f4c3") to Flutter Color
  static Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    }
    throw FormatException('Invalid color format: $hexString');
  }

  /// Check if a value falls within this range
  bool contains(double value) {
    return value >= min && value <= max;
  }

  /// Get the total span of this range
  double get span => max - min;
}

