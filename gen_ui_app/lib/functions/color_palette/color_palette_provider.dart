import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../ai/providers/gemini_provider.dart';
import '../../main.dart';
import 'color_palette_dto.dart';

final _history = [
  Content.text('inspirational'),
  Content.model([
    TextPart(ColorPaletteDto(
      colorPaletteTextColor:
          const Color(0xFF6EC1E4), // Light blue to complement the warm colors
      bottomLeftColor: const Color(0xFFFFB07C),
      colorPaletteTextFont: ColorPaletteTextFontFamily.montserrat,
      name: 'Ocean Sunset',
      topLeftColor: const Color(0xFF6EC1E4),
      topRightColor: const Color(0xFFA37AC7),
      bottomRightColor: const Color(0xFFFF758F),
    ).toJson()),
  ]),
  Content.text('The future'),
  Content.model([
    TextPart(ColorPaletteDto(
      name: 'Cosmic Horizon',
      colorPaletteTextFont: ColorPaletteTextFontFamily.orbitron,
      colorPaletteTextColor: const Color(
          0xFF00D486), // Vibrant green to stand out against the cool colors
      topLeftColor: const Color.fromARGB(255, 1, 157, 234),
      topRightColor: const Color(0xFF4527A0),
      bottomRightColor: const Color.fromARGB(255, 0, 169, 143),
      bottomLeftColor: const Color.fromARGB(255, 0, 212, 134),
    ).toJson()),
  ]),
  Content.text('courage'),
  Content.model([
    TextPart(ColorPaletteDto(
      name: 'Fiery Spirit',
      colorPaletteTextFont: ColorPaletteTextFontFamily.lobster,
      colorPaletteTextColor: const Color(
          0xFFFDB813), // Golden yellow to complement the fiery colors
      topLeftColor: const Color(0xFFB22222),
      topRightColor: const Color(0xFFDC143C),
      bottomRightColor: const Color(0xFFCD5C5C),
      bottomLeftColor: const Color(0xFFF08080),
    ).toJson()),
  ]),
  Content.text('sweet'),
  Content.model([
    TextPart(ColorPaletteDto(
      name: 'Bubblegum Bliss',
      colorPaletteTextFont: ColorPaletteTextFontFamily.poppins,
      colorPaletteTextColor: const Color(
          0xFF8E44AD), // Deep purple to contrast the soft pink shades
      topLeftColor: const Color(0xFFFF69B4),
      topRightColor: const Color(0xFFFFB6C1),
      bottomRightColor: const Color(0xFFFFC0CB),
      bottomLeftColor: const Color(0xFFFFDAE9),
    ).toJson()),
  ]),
  Content.text('energetic'),
  Content.model([
    TextPart(ColorPaletteDto(
      name: 'Electric Vibes',
      colorPaletteTextFont: ColorPaletteTextFontFamily.bebasNeue,
      colorPaletteTextColor:
          const Color(0xFFFF0000), // Bright red to match the energetic theme
      topLeftColor: const Color(0xFFFFA500),
      topRightColor: const Color(0xFFFFD700),
      bottomRightColor: const Color(0xFF00BFFF),
      bottomLeftColor: const Color(0xFF00FF00),
    ).toJson()),
  ]),
  Content.text('tropical'),
  Content.model([
    TextPart(ColorPaletteDto(
      name: 'Island Paradise',
      colorPaletteTextFont: ColorPaletteTextFontFamily.pacifico,
      colorPaletteTextColor:
          const Color(0xFFFF4500), // Vibrant orange to evoke a tropical feel
      topLeftColor: const Color(0xFF00FF7F),
      topRightColor: const Color(0xFF00FFFF),
      bottomRightColor: const Color(0xFFFFC0CB),
      bottomLeftColor: const Color(0xFFFFFF00),
    ).toJson()),
  ]),
  Content.text('minimalist'),
  Content.model([
    TextPart(ColorPaletteDto(
      name: 'Sleek Simplicity',
      colorPaletteTextFont: ColorPaletteTextFontFamily.raleway,
      colorPaletteTextColor:
          const Color(0xFF2C3E50), // Dark blue for a sophisticated look
      topLeftColor: const Color(0xFFF5F5F5),
      topRightColor: const Color(0xFFE0E0E0),
      bottomRightColor: const Color(0xFFBDBDBD),
      bottomLeftColor: const Color(0xFF9E9E9E),
    ).toJson()),
  ]),
  Content.text('retro gaming'),
  Content.model([
    TextPart(ColorPaletteDto(
      name: 'Pixel Nostalgia',
      colorPaletteTextFont: ColorPaletteTextFontFamily.bungee,
      colorPaletteTextColor:
          const Color(0xFFFFD700), // Classic gold color for a retro gaming vibe
      topLeftColor: const Color(0xFF8B0000),
      topRightColor: const Color(0xFF00008B),
      bottomRightColor: const Color(0xFF006400),
      bottomLeftColor: const Color(0xFFB8860B),
    ).toJson()),
  ]),
  Content.text('industrial'),
  Content.model([
    TextPart(ColorPaletteDto(
      name: 'Urban Grit',
      colorPaletteTextFont: ColorPaletteTextFontFamily.anton,
      colorPaletteTextColor: const Color(
          0xFFC0C0C0), // Silver color to complement the grayish tones
      topLeftColor: const Color(0xFF2F4F4F),
      topRightColor: const Color(0xFF708090),
      bottomRightColor: const Color(0xFFA9A9A9),
      bottomLeftColor: const Color(0xFF696969),
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

final colorPaletteSchemaProvider = GeminiProvider(
  model: GeminiModel.flash15Latest.model,
  apiKey: kGeminiApiKey,
  config: GenerationConfig(
    responseMimeType: 'application/json',
    responseSchema: ColorPaletteDto.schema,
  ),
  systemInstruction: _systemInstructions,
  history: _history,
);

// final _colorPaletteToolConfig = ToolConfig(
//   functionCallingConfig: FunctionCallingConfig(
//     mode: FunctionCallingMode.auto,
//     // allowedFunctionNames: {
//     //   _setsColorPaletteFunction.name,
//     // },
//   ),
// );

// final _setsColorPalette = LlmFunctionDeclaration(
//   name: 'setsColorPalette',
//   description: 'Sets a color palette.',
//   parameters: ColorPaletteDto.schema,
// );

// final _setsColorPaletteFunction = LlmFunction(
//   function: _setsColorPalette,
//   handler: (value) => colorPaletteController.post(value),
//   uiHandler: (value) =>
//       ColorPaletteWidgetResponse(ColorPaletteDto.fromMap(value)),
// );
