import 'package:flutter/material.dart';

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

const _textStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

const chatTheme = _ChatStyleTheme(
  backgroundColor: Colors.black,
  onBackGroundColor: Colors.white,
  textStyle: _textStyle,
  accentColor: Color(0xFFE1FF41),
  onAccentColor: Colors.black,
);
