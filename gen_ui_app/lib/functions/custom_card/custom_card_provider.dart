import 'dart:ui';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../../ai/providers/gemini_provider.dart';
import '../../main.dart';

import 'custom_card_dto.dart';

final customCardProvider = GeminiProvider(
  model: GeminiModel.flash15Latest.model,
  apiKey: kGeminiApiKey,
  config: GenerationConfig(
    responseMimeType: 'application/json',
    responseSchema: CustomCardDto.schema,
  ),
  systemInstruction: _systemInstructions,
  history: _history,
);

// final colorPaletteProvider = GeminiProvider(
//   model: GeminiModel.flash15Latest.model,
//   apiKey: kGeminiApiKey,
// config: GenerationConfig(
//   responseMimeType: 'application/json',
//   responseSchema: ColorPaletteDto.schema,
// ),
// systemInstruction: _systemInstructions,
// history: _history,
// );
final _history = [
  Content.text('Bohemian Rhapsody'),
  Content.model([
    TextPart(
      CustomCardDto(
        name: 'Bohemian Rhapsody',
        subtitle: 'Rock',
        fontFamily: CustomCardTextFontFamily.bungee,
        backgroundColor: const Color(0xFF000000),
        accentColor: const Color(0xFFFFD700),
        textColor: const Color(0xFFFFFFFF),
        borderRadius: 20.0,
        topLeftColor: const Color(0xFF000000),
        topRightColor: const Color(0xFFFFD700),
        bottomLeftColor: const Color(0xFFFFFFFF),
        bottomRightColor: const Color(0xFF808080),
      ).toJson(),
    ),
  ]),
  Content.text('Smells Like Teen Spirit'),
  Content.model(
    [
      TextPart(
        CustomCardDto(
          name: 'Smells Like Teen Spirit',
          subtitle: 'Grunge',
          fontFamily: CustomCardTextFontFamily.anton,
          backgroundColor: const Color(0xFF000000),
          accentColor: const Color(0xFFFF0000),
          textColor: const Color(0xFFFFFFFF),
          borderRadius: 5.0,
          topLeftColor: const Color(0xd5972f),
          topRightColor: const Color(0xFFC34A36),
          bottomLeftColor: const Color(0xFFBDBDBD),
          bottomRightColor: const Color(0xFF404040),
        ).toJson(),
      ),
    ],
  ),
  Content.text('Purple Rain'),
  Content.model([
    TextPart(
      CustomCardDto(
        name: 'Purple Rain',
        subtitle: 'Pop Rock',
        fontFamily: CustomCardTextFontFamily.lobster,
        backgroundColor: const Color(0xFF800080),
        accentColor: const Color(0xFFFFFFFF),
        textColor: const Color(0xFFFFD700),
        borderRadius: 30.0,
        topLeftColor: const Color(0xFF800080),
        topRightColor: const Color(0xff9370db),
        bottomLeftColor: const Color(0xFF9400d3),
        bottomRightColor: const Color(0xFFFF69b4),
      ).toJson(),
    ),
  ]),
  Content.text('Thriller'),
  Content.model([
    TextPart(CustomCardDto(
      name: 'Thriller',
      subtitle: 'Pop',
      fontFamily: CustomCardTextFontFamily.bebasNeue,
      backgroundColor: const Color(0xFF8B0000),
      accentColor: const Color(0xFFFFA500),
      textColor: const Color(0xFFFFFFFF),
      borderRadius: 35.0,
      topLeftColor: const Color(0xFF008000),
      topRightColor: const Color(0xFFff669b4),
      bottomLeftColor: const Color(0xFF7cfc00),
      bottomRightColor: const Color(0xFFffc0cb),
    ).toJson()),
  ]),
  Content.text('Hotel California'),
  Content.model([
    TextPart(CustomCardDto(
      name: 'Hotel California',
      subtitle: 'Soft Rock',
      fontFamily: CustomCardTextFontFamily.raleway,
      backgroundColor: const Color.fromARGB(255, 83, 58, 38),
      accentColor: const Color.fromARGB(255, 255, 207, 48),
      textColor: const Color(0xFF000000),
      borderRadius: 40.0,
      topLeftColor: const Color(0xFFFFFACD),
      topRightColor: const Color(0xFFFF8C00),
      bottomLeftColor: const Color(0xFFFF0000),
      bottomRightColor: const Color(0xFF000080),
    ).toJson()),
  ]),
  Content.text('Firework'),
  Content.model([
    TextPart(CustomCardDto(
      name: 'Firework',
      subtitle: 'Pop',
      fontFamily: CustomCardTextFontFamily.poppins,
      backgroundColor: const Color(0xFFF7F6FF),
      accentColor: const Color(0xFFCBB4FA),
      textColor: const Color(0xFF000000),
      borderRadius: 45.0,
      topLeftColor: const Color(0xFF800080),
      topRightColor: const Color(0xFF8A2BE2),
      bottomLeftColor: const Color(0xFF9370DB),
      bottomRightColor: const Color(0xFFBA55D3),
    ).toJson()),
  ]),
  Content.text('One Love'),
  Content.model([
    TextPart(CustomCardDto(
      name: 'One Love',
      subtitle: 'Reggae',
      fontFamily: CustomCardTextFontFamily.montserrat,
      backgroundColor: const Color.fromARGB(255, 216, 237, 229),
      accentColor: const Color(0xFFFFD700),
      textColor: const Color(0xFFFFFFFF),
      borderRadius: 50.0,
      topLeftColor: const Color(0xFFFFD700),
      topRightColor: const Color(0xFFFFA500),
      bottomLeftColor: const Color(0xFF00FF7F),
      bottomRightColor: const Color(0xFFFF0000),
    ).toJson()),
  ]),
];

const _systemInstructions = '''
You are a UI designer creating custom music player cards. Each card should be visually appealing and have a unique design. 
- You will receive the name of a music, and you need to generate a custom card design based on this information.
- When you receive the name of the card, you should generate a custom music player for the song you don't need to reuse the last setting unless the user asks for it.
- You should always match the accent color with the left, right, top, and bottom colors.
The cards should include the following properties:

- name: The name of the custom card.
- subtitle: based in your knowledge you should fill in with the music genre.
- fontFamily: The font family for the card text.
- backgroundColor: The background color of the card.
- accentColor: The accent color for the card, used for highlights content over the background. This color should complement the backgroundColor and other colors used in the card design. Format the color as a hex code.
- textColor: The color of the text on the card. Format the color as a hex code.
- borderRadius: The border radius of the card corners. This value should be suggested based on the name of the card.
- topLeftColor: The hex color value of the top left corner of the banner. Format: #FF0000
- topRightColor: The hex color value of the top right corner of the banner. Format: #FF0000
- bottomLeftColor: The hex color value of the bottom left corner of the banner. Format: #FF0000
- bottomRightColor: The hex color value of the bottom right corner of the banner. Format: #FF0000
''';
