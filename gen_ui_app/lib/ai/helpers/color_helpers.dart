import 'package:flutter/material.dart';

Color colorFromHex(String hexString) {
  hexString = hexString.trim();
  if (hexString.isEmpty) {
    return Colors.black; // Default color if null or empty
  }
  hexString = hexString.replaceAll('#', '');
  if (hexString.length == 6) {
    hexString = 'FF$hexString'; // Add opacity if not provided
  }
  return Color(int.parse(hexString, radix: 16));
}

extension ColorX on Color {
  String toHex() =>
      '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

  Color toContrastColor() {
    // Calculate luminance
    double luminance = computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
