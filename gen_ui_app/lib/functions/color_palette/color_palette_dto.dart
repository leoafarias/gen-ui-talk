import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../ai/helpers/color_helpers.dart';

enum ColorPaletteTextFontFamily {
  bebasNeue,
  poppins,
  raleway,
  lobster,
  orbitron,
  montserrat,
  pacifico,
  bungee,
  anton;

  String get fontFamily => switch (this) {
        bebasNeue => GoogleFonts.bebasNeue().fontFamily!,
        poppins => GoogleFonts.poppins().fontFamily!,
        raleway => GoogleFonts.raleway().fontFamily!,
        lobster => GoogleFonts.lobster().fontFamily!,
        orbitron => GoogleFonts.orbitron().fontFamily!,
        montserrat => GoogleFonts.montserrat().fontFamily!,
        pacifico => GoogleFonts.pacifico().fontFamily!,
        bungee => GoogleFonts.bungee().fontFamily!,
        anton => GoogleFonts.anton().fontFamily!,
      };

  static List<String> get enumString => values.map((e) => e.name).toList();

  static ColorPaletteTextFontFamily fromString(String value) {
    return ColorPaletteTextFontFamily.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ColorPaletteTextFontFamily.bebasNeue,
    );
  }
}

class ColorPaletteDto {
  final String name;

  final ColorPaletteTextFontFamily colorPaletteTextFont;
  final Color colorPaletteTextColor;

  final Color topLeftColor;
  final Color topRightColor;
  final Color bottomLeftColor;
  final Color bottomRightColor;

  ColorPaletteDto({
    required this.name,
    required this.colorPaletteTextFont,
    required this.topLeftColor,
    required this.topRightColor,
    required this.bottomLeftColor,
    required this.bottomRightColor,
    required this.colorPaletteTextColor,
  });

  ColorPaletteDto copyWith({
    String? name,
    ColorPaletteTextFontFamily? colorPaletteTextFont,
    Color? colorPaletteTextColor,
    Color? topLeftColor,
    Color? topRightColor,
    Color? bottomLeftColor,
    Color? bottomRightColor,
  }) {
    return ColorPaletteDto(
      name: name ?? this.name,
      colorPaletteTextFont: colorPaletteTextFont ?? this.colorPaletteTextFont,
      colorPaletteTextColor:
          colorPaletteTextColor ?? this.colorPaletteTextColor,
      topLeftColor: topLeftColor ?? this.topLeftColor,
      topRightColor: topRightColor ?? this.topRightColor,
      bottomLeftColor: bottomLeftColor ?? this.bottomLeftColor,
      bottomRightColor: bottomRightColor ?? this.bottomRightColor,
    );
  }

  Color getColor(ColorCorner corner) {
    return switch (corner) {
      ColorCorner.topLeft => topLeftColor,
      ColorCorner.topRight => topRightColor,
      ColorCorner.bottomLeft => bottomLeftColor,
      ColorCorner.bottomRight => bottomRightColor,
    };
  }

  @override
  operator ==(Object other) {
    return other is ColorPaletteDto &&
        other.colorPaletteTextFont == colorPaletteTextFont &&
        other.topLeftColor == topLeftColor &&
        other.topRightColor == topRightColor &&
        other.bottomLeftColor == bottomLeftColor &&
        other.bottomRightColor == bottomRightColor &&
        other.name == name &&
        other.colorPaletteTextColor == colorPaletteTextColor;
  }

  // hash
  @override
  int get hashCode {
    return colorPaletteTextFont.hashCode ^
        topLeftColor.hashCode ^
        topRightColor.hashCode ^
        bottomLeftColor.hashCode ^
        bottomRightColor.hashCode ^
        name.hashCode ^
        colorPaletteTextColor.hashCode;
  }

  String toJson() {
    return const JsonEncoder.withIndent('  ').convert(toMap());
  }

  static ColorPaletteDto fromMap(Map<String, dynamic> map) {
    return ColorPaletteDto(
      colorPaletteTextFont: ColorPaletteTextFontFamily.fromString(
          map['colorPaletteTextFont'] as String),
      topLeftColor: colorFromHex(map['topLeftColor'] as String),
      topRightColor: colorFromHex(map['topRightColor'] as String),
      bottomLeftColor: colorFromHex(map['bottomLeftColor'] as String),
      bottomRightColor: colorFromHex(map['bottomRightColor'] as String),
      name: map['name'] as String,
      colorPaletteTextColor:
          colorFromHex(map['colorPaletteTextColor'] as String),
    );
  }

  static ColorPaletteDto fromJson(String json) {
    return fromMap(jsonDecode(json) as Map<String, dynamic>);
  }

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'colorPaletteTextColor': colorPaletteTextColor.toHex(),
      'colorPaletteTextFont': colorPaletteTextFont.name,
      'topLeftColor': topLeftColor.toHex(),
      'topRightColor': topRightColor.toHex(),
      'bottomLeftColor': bottomLeftColor.toHex(),
      'bottomRightColor': bottomRightColor.toHex(),
    };
  }

  static final schema = Schema.object(properties: {
    'name': Schema.string(
      description:
          'The text content to display on color palette. Format: #FF0000',
      nullable: false,
    ),
    'colorPaletteTextFont': Schema.enumString(
      enumValues: ColorPaletteTextFontFamily.enumString,
      description: 'The font to use for the poster text.',
      nullable: false,
    ),
    'colorPaletteTextColor': Schema.string(
      description: 'The hex color value of the poster text. Format: #FF0000',
      nullable: false,
    ),
    'topLeftColor': Schema.string(
      description:
          'The hex color value top left corner of color palette. Format: #FF0000',
      nullable: false,
    ),
    'topRightColor': Schema.string(
      description:
          'The hex color value top right corner of color palette. Format: #FF0000',
      nullable: false,
    ),
    'bottomLeftColor': Schema.string(
      description:
          'The hex color value bottom left corner of color palette. Format: #FF0000',
      nullable: false,
    ),
    'bottomRightColor': Schema.string(
      description:
          'The hex color value bottom right corner of color palette. Format: #FF0000',
      nullable: false,
    )
  }, requiredProperties: [
    'name',
    'colorPaletteTextFont',
    'colorPaletteTextColor',
    'topLeftColor',
    'topRightColor',
    'bottomLeftColor',
    'bottomRightColor',
  ]);
}

/// Enum to represent poster corners for color selection.
enum ColorCorner {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight;
}
