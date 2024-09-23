import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../ai/models/ai_function.dart';
import '../../ai/providers/gemini_provider.dart';
import '../../main.dart';
import '../color_palette/color_palette_dto.dart';
import 'color_palette_updatable_controller.dart';
import 'color_palette_updatable_dto.dart';

final _changeAllColors = [
  Content.text('Change all the colors'),
  Content.model([
    FunctionCall(_getColorPalette.name, {}),
    FunctionResponse(
      _getColorPalette.name,
      ColorPaletteDto(
        name: 'Rainbow Symphony',
        font: ColorPaletteFontFamily.lobster,
        fontColor: const Color(0xFF000000),
        topLeftColor: const Color(0xFFFF0000), // Red
        topRightColor: const Color(0xFFFFA500), // Orange
        bottomLeftColor: const Color(0xFFFFFF00), // Yellow
        bottomRightColor: const Color(0xFF008000), // Green
      ).toMap(),
    ),
    TextPart(
      WidgetSchemaDto(
        colorPickers: [
          const ColorPickerDtoSchema(
            label: 'Top Left Color',
            color: Color(0xFFFF0000),
          ),
          const ColorPickerDtoSchema(
            label: 'Top Right Color',
            color: Color(0xFFFFA500),
          ),
          const ColorPickerDtoSchema(
            label: 'Bottom Left Color',
            color: Color(0xFFFFFF00),
          ),
          const ColorPickerDtoSchema(
            label: 'Bottom Right Color',
            color: Color(0xFF008000),
          ),
        ],
      ).toJson(),
    ),
  ]),
];

final _changeFontColor = [
  Content.text('Change the font color'),
  Content.model([
    FunctionCall(_getColorPalette.name, {}),
    FunctionResponse(
      _getColorPalette.name,
      ColorPaletteDto(
        name: 'Monochrome Text',
        font: ColorPaletteFontFamily.raleway,
        fontColor: const Color(0xFF000000),
        topLeftColor: const Color(0xFFFFFFFF),
        topRightColor: const Color(0xFFFFFFFF),
        bottomLeftColor: const Color(0xFFFFFFFF),
        bottomRightColor: const Color(0xFFFFFFFF),
      ).toMap(),
    ),
    TextPart(
      WidgetSchemaDto(
        colorPickers: [
          const ColorPickerDtoSchema(
            label: 'Font Color',
            color: Color(0xFF000000),
          ),
        ],
      ).toJson(),
    ),
  ]),
];

final _changeTopTwoColors = [
  Content.text('Change the top colors'),
  Content.model([
    FunctionCall(_getColorPalette.name, {}),
    FunctionResponse(
      _getColorPalette.name,
      ColorPaletteDto(
        name: 'Sunlit Paradise',
        font: ColorPaletteFontFamily.pacifico,
        fontColor: const Color(0xFF000080),
        topLeftColor: const Color(0xFFFFD700),
        topRightColor: const Color(0xFF00FF7F),
        bottomLeftColor: const Color(0xFF1E90FF),
        bottomRightColor: const Color(0xFFFF9F80),
      ).toMap(),
    ),
    TextPart(
      WidgetSchemaDto(
        colorPickers: [
          const ColorPickerDtoSchema(
            label: 'Top Left Color',
            color: Color(0xFFFFD700),
          ),
          const ColorPickerDtoSchema(
            label: 'Top Right Color',
            color: Color(0xFF00FF7F),
          ),
        ],
      ).toJson(),
    ),
  ]),
];

final _changeFont = [
  Content.text('Change the font'),
  Content.model([
    FunctionCall(_getColorPalette.name, {}),
    FunctionResponse(
      _getColorPalette.name,
      ColorPaletteDto(
        name: 'Ocean Breeze',
        font: ColorPaletteFontFamily.bungee,
        fontColor: const Color(0xFF4A4A4A),
        topLeftColor: const Color(0xFFFFD700),
        topRightColor: const Color(0xFF00FF7F),
        bottomLeftColor: const Color(0xFF1E90FF),
        bottomRightColor: const Color(0xFFFF9F80),
      ).toMap(),
    ),
    TextPart(
      WidgetSchemaDto(dropdowns: [
        DropdownSchemaDto(
          label: 'Font',
          currentValue: ColorPaletteFontFamily.bungee.name,
          options: ColorPaletteFontFamily.enumString,
        ),
      ], colorPickers: [
        const ColorPickerDtoSchema(
          label: 'Font Color',
          color: Color(0xFF4A4A4A),
        )
      ]).toJson(),
    ),
  ]),
];
final _history = [
  ..._changeTopTwoColors,
  ..._changeFont,
  ..._changeFontColor,
  ..._changeAllColors
];

const _systemInstructions = '''
You are a widget schema generator. You will return a widget schema that will be rendered to the user, based on their prompts
''';

final _toolConfig = ToolConfig(
  functionCallingConfig: FunctionCallingConfig(
    mode: FunctionCallingMode.auto,
  ),
);

final colorPaletteUpdatableProvider = GeminiProvider(
  model: GeminiModel.flash15Latest.model,
  apiKey: kGeminiApiKey,
  toolConfig: _toolConfig,
  functions: [_getColorPalette],
  config: GenerationConfig(responseSchema: WidgetSchemaDto.schema),
  systemInstruction: _systemInstructions,
  history: _history,
);

final _getColorPalette = LlmFunctionDeclaration(
  name: 'getColorPalette',
  description: 'Returns a color palette',
  handler: (args) => updatableColorPaletteController.get(),
);

// final _renderWidget = AiWidgetDeclaration<WidgetSchemaDto>(
//   name: 'renderWidget',
//   description: 'Returns a schema that will be renderd to the user',
//   parameters: WidgetSchemaDto.schema,
//   parser: (args) => WidgetSchemaDto.fromMap(args),
//   handler: (value) => ,
//   builder: (data) => ColorPaletteUpdatableResponseView(data: data),
// );
