import 'package:google_generative_ai/google_generative_ai.dart';

import '../../ai/models/ai_function.dart';
import '../../ai/providers/gemini_provider.dart';
import '../../main.dart';
import 'light_control_controller.dart';
import 'light_control_dto.dart';
import 'light_control_widget.dart';

final _whatIsBrightnessLevel = [
  Content.text('What is the brightness level?'),
  Content.model([
    FunctionCall(_getBrightness.name, {}),
    FunctionResponse(
      _getBrightness.name,
      LightControlDto(brightness: 0).toMap(),
    ),
    TextPart('The light is currently off.'),
  ]),
];

final _testConstraints = [
  Content.text('increase brightness by 30'),
  Content.model(
    [
      FunctionCall(_getBrightness.name, {}),
      FunctionResponse(
        _getBrightness.name,
        LightControlDto(brightness: 90).toMap(),
      ),
      FunctionCall(_updateBrightness.name, {'brightness': 100}),
      FunctionResponse(
        _updateBrightness.name,
        LightControlDto(brightness: 100).toMap(),
      ),
      TextPart(
          'Cannot increase brightness by 30. I have changed the brightness to 100%'),
    ],
  ),
];
final List<Content> _increaseBrightnessBy20 = [
  Content.text('Increase the brightness of the light by 20%'),
  Content.model([
    FunctionCall(_getBrightness.name, {}),
    FunctionResponse(
      _getBrightness.name,
      LightControlDto(brightness: 35).toMap(),
    ),
    FunctionCall(_updateBrightness.name, {'brightness': 35 + 20}),
    FunctionResponse(
      _updateBrightness.name,
      LightControlDto(brightness: 35 + 20).toMap(),
    ),
    TextPart('I have changed the brightness to 55%'),
  ]),
];

final _dimLightBy50 = [
  Content.text('Dim the light by 50%'),
  Content.model([
    FunctionCall(_getBrightness.name, {}),
    FunctionResponse(
      _getBrightness.name,
      LightControlDto(brightness: 85).toMap(),
    ),
    FunctionCall(_updateBrightness.name, {'brightness': 35}),
    FunctionResponse(
      _updateBrightness.name,
      LightControlDto(brightness: 35).toMap(),
    ),
    TextPart('I have dimmed the light to 35%'),
  ]),
];
final _turnLightOff = [
  Content.text('Turn off the light'),
  Content.model([
    FunctionCall(_getBrightness.name, {}),
    FunctionResponse(
        _getBrightness.name, LightControlDto(brightness: 60).toMap()),
    FunctionCall(_updateBrightness.name, {'brightness': 0}),
    FunctionResponse(
        _updateBrightness.name, LightControlDto(brightness: 0).toMap()),
    TextPart('I have turned the light off.'),
  ]),
];

final _setLightTo75Percent = [
  Content.text('Set the light brightness to 75%'),
  Content.model([
    FunctionCall(_getBrightness.name, {}),
    FunctionResponse(
        _getBrightness.name, LightControlDto(brightness: 40).toMap()),
    FunctionCall(_updateBrightness.name, {'brightness': 75}),
    FunctionResponse(
        _updateBrightness.name, LightControlDto(brightness: 75).toMap()),
    TextPart('I have set the light brightness to 75%.'),
  ]),
];

final _decreaseBrightnessByHalf = [
  Content.text('Decrease the brightness by half'),
  Content.model([
    FunctionCall(_getBrightness.name, {}),
    FunctionResponse(
        _getBrightness.name, LightControlDto(brightness: 80).toMap()),
    FunctionCall(_updateBrightness.name, {'brightness': 40}),
    FunctionResponse(
        _updateBrightness.name, LightControlDto(brightness: 40).toMap()),
    TextPart(
        'I have decreased the brightness to 40%, which is half of the previous 80%.'),
  ]),
];

final _maxOutBrightness = [
  Content.text('Set the light to maximum brightness'),
  Content.model([
    FunctionCall(_getBrightness.name, {}),
    FunctionResponse(
        _getBrightness.name, LightControlDto(brightness: 70).toMap()),
    FunctionCall(_updateBrightness.name, {'brightness': 100}),
    FunctionResponse(
        _updateBrightness.name, LightControlDto(brightness: 100).toMap()),
    TextPart('I have set the light to its maximum brightness of 100%.'),
  ]),
];

List<Content> get _history => [
      ..._whatIsBrightnessLevel,
      ..._increaseBrightnessBy20,
      ..._dimLightBy50,
      ..._testConstraints,
      ..._turnLightOff,
      ..._setLightTo75Percent,
      ..._decreaseBrightnessByHalf,
      ..._maxOutBrightness,
    ];

final _controlLightToolConfig = ToolConfig(
  functionCallingConfig: FunctionCallingConfig(
    mode: FunctionCallingMode.auto,
  ),
);

const _systemInstructions = '''
You are a light control system. You can adjust the brightness of the light in a room.

You can set the brightness of the light to a value between 0 and 100. Zero is off and 100 is full brightness.

''';
final controlLightSchemaProvider = GeminiProvider(
  model: GeminiModel.flash15.model,
  apiKey: kGeminiApiKey,
  functions: [_getBrightness, _updateBrightness],
  toolConfig: _controlLightToolConfig,
  systemInstruction: _systemInstructions,
  history: _history,
);
final controlLightProvider = GeminiProvider(
  model: GeminiModel.flash15.model,
  apiKey: kGeminiApiKey,
  functions: [_getBrightness, _updateBrightnessWidget],
  toolConfig: _controlLightToolConfig,
  systemInstruction: _systemInstructions,
  history: _history,
);

final _getBrightness = LlmFunctionDeclaration(
  name: 'getBrightness',
  description: 'Returns the current brightness level of the room.',
  handler: (args) => lightControlController.get(),
);

final _updateBrightness = LlmFunctionDeclaration(
  name: 'updateBrightness',
  description:
      'Update the brightness of the light. 0 is off and 100 is full brightness.',
  parameters: LightControlDto.schema,
  handler: (value) => lightControlController.post(value),
);

final _updateBrightnessWidget = AiWidgetDeclaration<LightControlDto>(
  name: _updateBrightness.name,
  parameters: _updateBrightness.parameters,
  description: _updateBrightness.description,
  handler: _updateBrightness.handler,
  parser: (value) => LightControlDto.fromMap(value),
  builder: (element) => LightControlWidgetResponse(
    element,
  ),
);
