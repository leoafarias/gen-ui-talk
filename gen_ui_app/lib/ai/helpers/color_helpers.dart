import 'package:flutter/material.dart';

import '../../functions/color_palette/color_palette_dto.dart';

Color colorFromHex(String hexString) {
  hexString = hexString.trim();
  if (hexString.isEmpty) {
    return Colors.black; // Default color if null or empty
  }
  hexString = hexString.replaceAll(RegExp(r'[^a-fA-F0-9]'), '');
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

Color _getContrastColor(Color color) {
  final hslColor = HSLColor.fromColor(color);
  final lightness = hslColor.lightness;

  if (lightness < 0.5) {
    return hslColor.withLightness(lightness + 0.4).toColor();
  } else {
    return hslColor.withLightness(lightness - 0.4).toColor();
  }
}

Color _getMostProminentColor(ColorPaletteDto colorPalette) {
  final colors = [
    colorPalette.topLeftColor,
    colorPalette.topRightColor,
    colorPalette.bottomRightColor,
    colorPalette.bottomLeftColor,
  ];

  final redSum = colors.fold<int>(0, (sum, color) => sum + color.red);
  final greenSum = colors.fold<int>(0, (sum, color) => sum + color.green);
  final blueSum = colors.fold<int>(0, (sum, color) => sum + color.blue);

  final averageRed = redSum ~/ colors.length;
  final averageGreen = greenSum ~/ colors.length;
  final averageBlue = blueSum ~/ colors.length;

  return Color.fromARGB(255, averageRed, averageGreen, averageBlue);
}

Color getContrastColorFromPalette(ColorPaletteDto colorPalette) {
  final prominentColor = _getMostProminentColor(colorPalette);
  return _getContrastColor(prominentColor);
}
