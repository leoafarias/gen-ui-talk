import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../ai/helpers.dart';
import '../../ai/helpers/color_helpers.dart';

enum CustomCardTextFontFamily {
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

  static CustomCardTextFontFamily fromString(String value) {
    return CustomCardTextFontFamily.values.firstWhere(
      (e) => e.name == value,
      orElse: () => CustomCardTextFontFamily.bebasNeue,
    );
  }
}

class EmotionIcons {
  static const Map<String, IconData> emotionIconMap = {
    'Joy': CupertinoIcons.smiley,
    'Sadness': CupertinoIcons.cloud_drizzle,
    'Anger': CupertinoIcons.flame,
    'Fear': CupertinoIcons.exclamationmark_triangle,
    'Surprise': CupertinoIcons.bolt,
    'Love': CupertinoIcons.heart,
  };

  static IconData getIcon(String emotion) {
    return emotionIconMap[emotion] ?? CupertinoIcons.question;
  }
}

class CustomCardDto {
  final String name;
  final String subtitle;
  final CustomCardTextFontFamily fontFamily;
  final Color backgroundColor;
  final Color accentColor;
  final Color textColor;
  final double borderRadius;
  final Color topLeftColor;
  final Color topRightColor;
  final Color bottomLeftColor;
  final Color bottomRightColor;
  final String iconEmotion;

  CustomCardDto({
    required this.name,
    required this.subtitle,
    required this.fontFamily,
    required this.backgroundColor,
    required this.accentColor,
    required this.textColor,
    required this.borderRadius,
    required this.topLeftColor,
    required this.topRightColor,
    required this.bottomLeftColor,
    required this.bottomRightColor,
    required this.iconEmotion,
  });

  CustomCardDto copyWith({
    String? name,
    String? subtitle,
    CustomCardTextFontFamily? fontFamily,
    Color? backgroundColor,
    Color? accentColor,
    Color? textColor,
    double? borderRadius,
    Color? topLeftColor,
    Color? topRightColor,
    Color? bottomLeftColor,
    Color? bottomRightColor,
    String? iconEmotion,
  }) {
    return CustomCardDto(
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      fontFamily: fontFamily ?? this.fontFamily,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      accentColor: accentColor ?? this.accentColor,
      textColor: textColor ?? this.textColor,
      borderRadius: borderRadius ?? this.borderRadius,
      topLeftColor: topLeftColor ?? this.topLeftColor,
      topRightColor: topRightColor ?? this.topRightColor,
      bottomLeftColor: bottomLeftColor ?? this.bottomLeftColor,
      bottomRightColor: bottomRightColor ?? this.bottomRightColor,
      iconEmotion: iconEmotion ?? this.iconEmotion,
    );
  }

  @override
  operator ==(Object other) {
    return other is CustomCardDto &&
        other.name == name &&
        other.subtitle == subtitle &&
        other.fontFamily == fontFamily &&
        other.backgroundColor == backgroundColor &&
        other.accentColor == accentColor &&
        other.textColor == textColor &&
        other.borderRadius == borderRadius &&
        other.topLeftColor == topLeftColor &&
        other.topRightColor == topRightColor &&
        other.bottomLeftColor == bottomLeftColor &&
        other.bottomRightColor == bottomRightColor &&
        other.iconEmotion == iconEmotion;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        subtitle.hashCode ^
        fontFamily.hashCode ^
        backgroundColor.hashCode ^
        accentColor.hashCode ^
        textColor.hashCode ^
        borderRadius.hashCode ^
        topLeftColor.hashCode ^
        topRightColor.hashCode ^
        bottomLeftColor.hashCode ^
        bottomRightColor.hashCode ^
        iconEmotion.hashCode;
  }

  String toJson() => prettyJson(toMap());

  static CustomCardDto fromMap(Map<String, dynamic> map) {
    return CustomCardDto(
      name: map['name'] as String,
      subtitle: map['subtitle'] as String,
      fontFamily:
          CustomCardTextFontFamily.fromString(map['fontFamily'] as String),
      backgroundColor: colorFromHex(map['backgroundColor'] as String),
      accentColor: colorFromHex(map['accentColor'] as String),
      textColor: colorFromHex(map['textColor'] as String),
      borderRadius: map['borderRadius'] as double,
      topLeftColor: colorFromHex(map['topLeftColor'] as String),
      topRightColor: colorFromHex(map['topRightColor'] as String),
      bottomLeftColor: colorFromHex(map['bottomLeftColor'] as String),
      bottomRightColor: colorFromHex(map['bottomRightColor'] as String),
      iconEmotion: map['iconEmotion'] as String,
    );
  }

  static CustomCardDto fromJson(String json) {
    return fromMap(jsonDecode(json) as Map<String, dynamic>);
  }

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'subtitle': subtitle,
      'fontFamily': fontFamily.name,
      'backgroundColor': backgroundColor.toHex(),
      'accentColor': accentColor.toHex(),
      'textColor': textColor.toHex(),
      'borderRadius': borderRadius,
      'topLeftColor': topLeftColor.toHex(),
      'topRightColor': topRightColor.toHex(),
      'bottomLeftColor': bottomLeftColor.toHex(),
      'bottomRightColor': bottomRightColor.toHex(),
      'iconEmotion': iconEmotion,
    };
  }

  static final schema = Schema.object(
    properties: {
      'name': Schema.string(
        description: 'The name of the custom card',
        nullable: false,
      ),
      'subtitle': Schema.string(
        description: 'The subtitle of the custom card',
        nullable: false,
      ),
      'fontFamily': Schema.enumString(
        enumValues: CustomCardTextFontFamily.enumString,
        description: 'The font family to use for the card text.',
        nullable: false,
      ),
      'backgroundColor': Schema.string(
        description:
            'The hex color value of the card background. Format: #FF0000',
        nullable: false,
      ),
      'accentColor': Schema.string(
        description:
            'The hex color value of the card accent color. Format: #FF0000',
        nullable: false,
      ),
      'textColor': Schema.string(
        description:
            'The hex color value of the card text color. Format: #FF0000. the text should be visible on the background color.',
        nullable: false,
      ),
      'borderRadius': Schema.number(
        description: 'The border radius of the card. Format: a double value.',
        nullable: false,
      ),
      'topLeftColor': Schema.string(
        description:
            'The hex color value of the top left corner of the banner. Format: #FF0000',
        nullable: false,
      ),
      'topRightColor': Schema.string(
        description:
            'The hex color value of the top right corner of the banner. Format: #FF0000',
        nullable: false,
      ),
      'bottomLeftColor': Schema.string(
        description:
            'The hex color value of the bottom left corner of the banner. Format: #FF0000',
        nullable: false,
      ),
      'bottomRightColor': Schema.string(
        description:
            'The hex color value of the bottom right corner of the banner. Format: #FF0000',
        nullable: false,
      ),
      'iconEmotion': Schema.string(
        description:
            'the emotion expressed by the song. The value need to be one of them: Joy, Sadness, Anger, Fear, Surprise, Love',
        nullable: false,
      ),
    },
    requiredProperties: [
      'name',
      'subtitle',
      'fontFamily',
      'backgroundColor',
      'accentColor',
      'textColor',
      'borderRadius',
      'topLeftColor',
      'topRightColor',
      'bottomLeftColor',
      'bottomRightColor',
      'iconEmotion',
    ],
  );
}
