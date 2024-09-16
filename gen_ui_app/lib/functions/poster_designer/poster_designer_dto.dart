part of 'poster_designer.dart';

enum _PosterFont {
  /// Bebas Neue - Bold, impactful, modern. Great for headlines or titles.
  bebasNeue,

  /// Poppins - Clean, geometric, versatile. Good for professional and modern designs.
  poppins,

  /// Raleway - Elegant, thin, futuristic. Perfect for minimal and stylish looks.
  raleway,

  /// Lobster - Playful, handwritten, with a retro feel. Adds a fun and whimsical element.
  lobster,

  /// Orbitron - Futuristic and tech-inspired. Ideal for sci-fi or technology-themed posters.
  orbitron,

  /// Montserrat - Bold, modern, and professional. Works well for titles or body text.
  montserrat,

  /// Pacifico - Casual, handwritten, and hip. Great for a laid-back, friendly aesthetic.
  pacifico,

  /// Bungee - Bold, urban, and playful. Adds a street-style feel to the design.
  bungee,

  /// Anton - Strong, impactful, condensed. Eye-catching for headlines and main text.
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

  static _PosterFont fromString(String value) {
    return _PosterFont.values.firstWhere(
      (e) => e.name == value,
      orElse: () => _PosterFont.bebasNeue,
    );
  }
}

class _PosterDesignerDto {
  final _PosterFont posterFont;
  final String posterText;
  final Color posterTextColor;
  final Color topLeftColor;
  final Color topRightColor;
  final Color bottomLeftColor;
  final Color bottomRightColor;

  _PosterDesignerDto({
    required this.posterFont,
    required this.topLeftColor,
    required this.topRightColor,
    required this.bottomLeftColor,
    required this.bottomRightColor,
    required this.posterText,
    required this.posterTextColor,
  });

  _PosterDesignerDto copyWith({
    _PosterFont? posterFont,
    String? posterText,
    Color? topLeftColor,
    Color? topRightColor,
    Color? bottomLeftColor,
    Color? bottomRightColor,
    Color? posterTextColor,
  }) {
    return _PosterDesignerDto(
      posterTextColor: posterTextColor ?? this.posterTextColor,
      posterFont: posterFont ?? this.posterFont,
      posterText: posterText ?? this.posterText,
      topLeftColor: topLeftColor ?? this.topLeftColor,
      topRightColor: topRightColor ?? this.topRightColor,
      bottomLeftColor: bottomLeftColor ?? this.bottomLeftColor,
      bottomRightColor: bottomRightColor ?? this.bottomRightColor,
    );
  }

  Color getColor(PosterCorner corner) {
    return switch (corner) {
      PosterCorner.topLeft => topLeftColor,
      PosterCorner.topRight => topRightColor,
      PosterCorner.bottomLeft => bottomLeftColor,
      PosterCorner.bottomRight => bottomRightColor,
    };
  }

  @override
  operator ==(Object other) {
    return other is _PosterDesignerDto &&
        other.posterFont == posterFont &&
        other.topLeftColor == topLeftColor &&
        other.topRightColor == topRightColor &&
        other.bottomLeftColor == bottomLeftColor &&
        other.bottomRightColor == bottomRightColor &&
        other.posterText == posterText &&
        other.posterTextColor == posterTextColor;
  }

  // hash
  @override
  int get hashCode {
    return posterFont.hashCode ^
        topLeftColor.hashCode ^
        topRightColor.hashCode ^
        bottomLeftColor.hashCode ^
        bottomRightColor.hashCode ^
        posterText.hashCode ^
        posterTextColor.hashCode;
  }

  static _PosterDesignerDto fromMap(Map<String, dynamic> map) {
    return _PosterDesignerDto(
      posterFont: _PosterFont.fromString(map['posterFont'] as String),
      topLeftColor: colorFromHex(map['topLeftColor'] as String),
      topRightColor: colorFromHex(map['topRightColor'] as String),
      bottomLeftColor: colorFromHex(map['bottomLeftColor'] as String),
      bottomRightColor: colorFromHex(map['bottomRightColor'] as String),
      posterText: map['posterText'] as String,
      posterTextColor: colorFromHex(map['posterTextColor'] as String),
    );
  }

  static _PosterDesignerDto fromJson(String json) {
    return fromMap(jsonDecode(json) as Map<String, dynamic>);
  }

  Map<String, Object?> toMap() {
    return {
      'posterText': posterText,
      'posterTextColor': posterTextColor.toHex(),
      'posterFont': posterFont.name,
      'topLeftColor': topLeftColor.toHex(),
      'topRightColor': topRightColor.toHex(),
      'bottomLeftColor': bottomLeftColor.toHex(),
      'bottomRightColor': bottomRightColor.toHex(),
    };
  }

  static final schema = Schema.object(properties: {
    'posterText': Schema.string(
      description: 'The text content to display on the poster.',
      nullable: false,
    ),
    'posterFont': Schema.enumString(
      enumValues: _PosterFont.enumString,
      description: 'The font to use for the poster text.',
      nullable: false,
    ),
    'posterTextColor': Schema.string(
      description: 'The hex color value of the poster text.',
      nullable: false,
    ),
    'topLeftColor': Schema.string(
      description: 'The hex color value top left corner of the poster.',
      nullable: false,
    ),
    'topRightColor': Schema.string(
      description: 'The hex color value top right corner of the poster.',
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
    'posterText',
    'posterFont',
    'posterTextColor',
    'topLeftColor',
    'topRightColor',
    'bottomLeftColor',
    'bottomRightColor',
  ]);
}
