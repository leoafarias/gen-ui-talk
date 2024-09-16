import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../ai/helpers/color_helpers.dart';
import 'quote_designer_example.dart';

enum QuoteTextFontFamily {
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

  static QuoteTextFontFamily fromString(String value) {
    return QuoteTextFontFamily.values.firstWhere(
      (e) => e.name == value,
      orElse: () => QuoteTextFontFamily.bebasNeue,
    );
  }
}

class QuoteDesignDto {
  final String quote;
  final QuoteTextFontFamily quoteTextFont;
  final Color quoteTextColor;
  final Color quoteTextShadowColor;
  final Color topLeftColor;
  final Color topRightColor;
  final Color bottomLeftColor;
  final Color bottomRightColor;
  final QuoteTextFontWeight quoteTextFontWeight;

  QuoteDesignDto({
    required this.quoteTextFont,
    required this.topLeftColor,
    required this.topRightColor,
    required this.bottomLeftColor,
    required this.bottomRightColor,
    required this.quote,
    required this.quoteTextColor,
    required this.quoteTextShadowColor,
    required this.quoteTextFontWeight,
  });

  QuoteDesignDto copyWith({
    String? quote,
    QuoteTextFontFamily? quoteTextFont,
    Color? quoteTextColor,
    Color? quoteTextShadowColor,
    Color? topLeftColor,
    Color? topRightColor,
    Color? bottomLeftColor,
    Color? bottomRightColor,
    QuoteTextFontWeight? quoteTextFontWeight,
  }) {
    return QuoteDesignDto(
      quote: quote ?? this.quote,
      quoteTextFont: quoteTextFont ?? this.quoteTextFont,
      quoteTextColor: quoteTextColor ?? this.quoteTextColor,
      quoteTextShadowColor: quoteTextShadowColor ?? this.quoteTextShadowColor,
      topLeftColor: topLeftColor ?? this.topLeftColor,
      topRightColor: topRightColor ?? this.topRightColor,
      bottomLeftColor: bottomLeftColor ?? this.bottomLeftColor,
      bottomRightColor: bottomRightColor ?? this.bottomRightColor,
      quoteTextFontWeight: quoteTextFontWeight ?? this.quoteTextFontWeight,
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
    return other is QuoteDesignDto &&
        other.quoteTextFont == quoteTextFont &&
        other.topLeftColor == topLeftColor &&
        other.topRightColor == topRightColor &&
        other.bottomLeftColor == bottomLeftColor &&
        other.bottomRightColor == bottomRightColor &&
        other.quote == quote &&
        other.quoteTextShadowColor == quoteTextShadowColor &&
        other.quoteTextFontWeight == quoteTextFontWeight &&
        other.quoteTextColor == quoteTextColor;
  }

  // hash
  @override
  int get hashCode {
    return quoteTextFont.hashCode ^
        topLeftColor.hashCode ^
        topRightColor.hashCode ^
        bottomLeftColor.hashCode ^
        bottomRightColor.hashCode ^
        quote.hashCode ^
        quoteTextShadowColor.hashCode ^
        quoteTextFontWeight.hashCode ^
        quoteTextColor.hashCode;
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  static QuoteDesignDto fromMap(Map<String, dynamic> map) {
    return QuoteDesignDto(
      quoteTextFont:
          QuoteTextFontFamily.fromString(map['quoteTextFont'] as String),
      topLeftColor: colorFromHex(map['topLeftColor'] as String),
      topRightColor: colorFromHex(map['topRightColor'] as String),
      bottomLeftColor: colorFromHex(map['bottomLeftColor'] as String),
      bottomRightColor: colorFromHex(map['bottomRightColor'] as String),
      quote: map['quote'] as String,
      quoteTextColor: colorFromHex(map['quoteTextColor'] as String),
      quoteTextShadowColor: colorFromHex(
        map['quoteTextShadowColor'] as String,
      ),
      quoteTextFontWeight: QuoteTextFontWeight.fromString(
        map['quoteTextFontWeight'] as String,
      ),
    );
  }

  static QuoteDesignDto fromJson(String json) {
    return fromMap(jsonDecode(json) as Map<String, dynamic>);
  }

  Map<String, Object?> toMap() {
    return {
      'quote': quote,
      'quoteTextColor': quoteTextColor.toHex(),
      'quoteTextFont': quoteTextFont.name,
      'topLeftColor': topLeftColor.toHex(),
      'topRightColor': topRightColor.toHex(),
      'bottomLeftColor': bottomLeftColor.toHex(),
      'bottomRightColor': bottomRightColor.toHex(),
      'quoteTextShadowColor': quoteTextShadowColor.toHex(),
      'quoteTextFontWeight': quoteTextFontWeight.name,
    };
  }

  static final schema = Schema.object(properties: {
    'quote': Schema.string(
      description: 'The text content to display on the poster.',
      nullable: false,
    ),
    'quoteTextFont': Schema.enumString(
      enumValues: QuoteTextFontFamily.enumString,
      description: 'The font to use for the poster text.',
      nullable: false,
    ),
    'quoteTextColor': Schema.string(
      description: 'The hex color value of the poster text.',
      nullable: false,
    ),
    'topLeftColor': Schema.string(
      description: 'The hex color value top left corner of the poster.',
      nullable: false,
    ),
    'quoteTextFontWeight': Schema.enumString(
      enumValues: QuoteTextFontWeight.enumString,
      description: 'The font weight of the poster text.',
      nullable: false,
    ),
    'topRightColor': Schema.string(
      description: 'The hex color value top right corner of the poster.',
      nullable: false,
    ),
    'quoteTextShadowColor': Schema.string(
      description: 'The hex color value of the poster text shadow.',
      nullable: false,
    ),
    'bottomLeftColor': Schema.string(
      description: 'The hex color value bottom left corner of the poster.',
      nullable: false,
    ),
    'bottomRightColor': Schema.string(
      description: 'The hex color value bottom right corner of the poster.',
      nullable: false,
    )
  }, requiredProperties: [
    'quote',
    'quoteTextFont',
    'quoteTextColor',
    'quoteTextShadowColor',
    'quoteTextFontWeight',
    'topLeftColor',
    'topRightColor',
    'bottomLeftColor',
    'bottomRightColor',
  ]);
}

enum QuoteTextFontWeight {
  normal,
  bold,
  bolder,
  lighter;

  FontWeight get fontWeight {
    return switch (this) {
      normal => FontWeight.normal,
      bold => FontWeight.bold,
      bolder => FontWeight.w900,
      lighter => FontWeight.w200,
    };
  }

  static List<String> get enumString => values.map((e) => e.name).toList();

  static QuoteTextFontWeight fromString(String fontWeightName) {
    try {
      return QuoteTextFontWeight.values.firstWhere(
        (element) => element.name == fontWeightName,
      );
    } catch (e) {
      return QuoteTextFontWeight.normal;
    }
  }
}
