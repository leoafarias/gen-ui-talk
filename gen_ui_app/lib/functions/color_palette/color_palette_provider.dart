import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../ai/providers/gemini_provider.dart';
import '../../main.dart';
import 'color_palette_dto.dart';

final _history = [
  Content.text('in`spirational'),
  Content.model(
    [
      TextPart(
        ColorPaletteDto(
          fontColor: const Color(0xFF333333), // Dark Gray
          bottomLeftColor: const Color(0xFFFFFFFF), // White
          font: ColorPaletteFontFamily.pacifico,
          name: 'Ocean Sunset',
          topLeftColor: const Color(0xFFFFD700), // Gold
          topRightColor: const Color(0xFFFF4500), // Orange Red
          bottomRightColor: const Color(0xFF00BFFF), // Deep Sky Blue
        ).toJson(),
      ),
    ],
  ),
  Content.text('future'),
  Content.model([
    TextPart(ColorPaletteDto(
      name: 'Cosmic Horizon',
      font: ColorPaletteFontFamily.orbitron,
      fontColor: const Color(0xFF333333),
      topLeftColor: const Color(0xFF0A2239),
      topRightColor: const Color(0xFF00FFFF),
      bottomLeftColor: const Color(0xFFFFFFFF),
      bottomRightColor: const Color(0xFFC0C0C0),
    ).toJson()),
  ]),
  Content.text('summer'),
  Content.model([
    TextPart(ColorPaletteDto(
      name: 'Sunlit Paradise',
      font: ColorPaletteFontFamily.pacifico,
      fontColor: const Color(0xFF000080),
      topLeftColor: const Color(0xFFFFD700),
      topRightColor: const Color(0xFF00FF7F),
      bottomLeftColor: const Color(0xFF1E90FF),
      bottomRightColor: const Color(0xFFFF9F80),
    ).toJson()),
  ]),
  Content.text('sweet'),
  Content.model([
    TextPart(ColorPaletteDto(
      name: 'Sugary Bliss',
      font: ColorPaletteFontFamily.pacifico,
      fontColor: const Color(0xFF5C3317),
      topLeftColor: const Color(0xFFFFB6C1),
      topRightColor: const Color(0xFFFFFACD),
      bottomLeftColor: const Color(0xFFCAAE7E),
      bottomRightColor: const Color(0xFFE6E6FA),
    ).toJson()),
  ]),
  Content.text('energetic'),
  Content.model([
    TextPart(ColorPaletteDto(
      name: 'Vibrant Surge',
      font: ColorPaletteFontFamily.bungee,
      fontColor: const Color(0xFFFFFFFF),
      topLeftColor: const Color(0xFF3498DB),
      topRightColor: const Color(0xFFFF6F00),
      bottomLeftColor: const Color(0xFF32CD32),
      bottomRightColor: const Color(0xFFFF00FF),
    ).toJson()),
  ]),
  Content.text('tropical'),
  Content.model([
    TextPart(ColorPaletteDto(
      name: 'Paradise Oasis',
      font: ColorPaletteFontFamily.lobster,
      fontColor: const Color(0xFF8B4513),
      topLeftColor: const Color(0xFF006400),
      topRightColor: const Color(0xFFFFD700),
      bottomLeftColor: const Color(0xFFFF7F50),
      bottomRightColor: const Color(0xFF40E0D0),
    ).toJson()),
  ]),
];

const _systemInstructions = '''
You are a color palette generator.

A color palette is a set of colors that work well together.

- name: The name of the color palette.
- colorPaletteTextFont: The font family for the colorPalette text.
- colorPaletteTextColor: The color to overlay the name on top of the color palette.
- topLeftColor: The first color in the palette.
- topRightColor: The second color in the palette.
- bottomLeftColor: The third color in the palette.
- bottomRightColor: The fourth color in the palette.
''';

final colorPaletteProvider = GeminiProvider(
  model: GeminiModel.flash15Latest.model,
  apiKey: kGeminiApiKey,
  config: GenerationConfig(
    responseMimeType: 'application/json',
    responseSchema: ColorPaletteDto.schema,
  ),
  systemInstruction: _systemInstructions,
  history: _history,
);
