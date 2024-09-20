import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../ai/helpers.dart';
import '../../ai/helpers/color_helpers.dart';

enum ColorPaletteFontFamily {
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

  static ColorPaletteFontFamily fromString(String value) {
    return ColorPaletteFontFamily.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ColorPaletteFontFamily.bebasNeue,
    );
  }
}

class ColorPaletteDto {
  final String name;

  final ColorPaletteFontFamily font;
  final Color fontColor;

  final Color topLeftColor;
  final Color topRightColor;
  final Color bottomLeftColor;
  final Color bottomRightColor;

  ColorPaletteDto({
    required this.name,
    required this.font,
    required this.topLeftColor,
    required this.topRightColor,
    required this.bottomLeftColor,
    required this.bottomRightColor,
    required this.fontColor,
  });

  ColorPaletteDto copyWith({
    String? name,
    ColorPaletteFontFamily? font,
    Color? fontColor,
    Color? topLeftColor,
    Color? topRightColor,
    Color? bottomLeftColor,
    Color? bottomRightColor,
  }) {
    return ColorPaletteDto(
      name: name ?? this.name,
      font: font ?? this.font,
      fontColor: fontColor ?? this.fontColor,
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

  ColorPaletteDto merge(ColorPaletteDto? other) {
    return copyWith(
      name: other?.name ?? name,
      font: other?.font ?? font,
      fontColor: other?.fontColor ?? fontColor,
      topLeftColor: other?.topLeftColor ?? topLeftColor,
      topRightColor: other?.topRightColor ?? topRightColor,
      bottomLeftColor: other?.bottomLeftColor ?? bottomLeftColor,
      bottomRightColor: other?.bottomRightColor ?? bottomRightColor,
    );
  }

  @override
  operator ==(Object other) {
    return other is ColorPaletteDto &&
        other.font == font &&
        other.topLeftColor == topLeftColor &&
        other.topRightColor == topRightColor &&
        other.bottomLeftColor == bottomLeftColor &&
        other.bottomRightColor == bottomRightColor &&
        other.name == name &&
        other.fontColor == fontColor;
  }

  // hash
  @override
  int get hashCode {
    return font.hashCode ^
        topLeftColor.hashCode ^
        topRightColor.hashCode ^
        bottomLeftColor.hashCode ^
        bottomRightColor.hashCode ^
        name.hashCode ^
        fontColor.hashCode;
  }

  String toJson() => prettyJson(toMap());

  static ColorPaletteDto fromMap(Map<String, dynamic> map) {
    return ColorPaletteDto(
      font: ColorPaletteFontFamily.fromString(map['font'] as String),
      topLeftColor: colorFromHex(map['topLeftColor'] as String),
      topRightColor: colorFromHex(map['topRightColor'] as String),
      bottomLeftColor: colorFromHex(map['bottomLeftColor'] as String),
      bottomRightColor: colorFromHex(map['bottomRightColor'] as String),
      name: map['name'] as String,
      fontColor: colorFromHex(map['fontColor'] as String),
    );
  }

  static ColorPaletteDto fromJson(String json) {
    return fromMap(jsonDecode(json) as Map<String, dynamic>);
  }

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'fontColor': fontColor.toHex(),
      'font': font.name,
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
    'font': Schema.enumString(
      enumValues: ColorPaletteFontFamily.enumString,
      description: 'The font to use for the poster text.',
      nullable: false,
    ),
    'fontColor': Schema.string(
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
    'font',
    'fontColor',
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
