import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class _ChatStyleTheme {
  final Color backgroundColor;
  final Color onBackGroundColor;
  final TextStyle textStyle;
  final Color accentColor;
  final Color onAccentColor;

  const _ChatStyleTheme({
    required this.backgroundColor,
    required this.onBackGroundColor,
    required this.textStyle,
    required this.accentColor,
    required this.onAccentColor,
  });
}

final _textStyle = GoogleFonts.firaCode().copyWith(
  fontSize: 16,
  fontWeight: FontWeight.w900,
);

final chatTheme = _ChatStyleTheme(
  backgroundColor: Colors.black,
  onBackGroundColor: Colors.white,
  textStyle: _textStyle,
  accentColor: const Color.fromARGB(255, 255, 255, 255),
  onAccentColor: Colors.black,
);
