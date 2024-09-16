part of 'poster_designer.dart';

Color colorFromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
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
