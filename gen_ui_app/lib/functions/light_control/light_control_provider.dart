import 'package:google_generative_ai/google_generative_ai.dart';

import '../../ai/providers/gemini_provider.dart';
import '../../main.dart';
import 'light_control_dto.dart';
import 'light_control_example.dart';

final _whatIsBrightnessLevel = [
  Content.text('What is the brightness level?'),
  Content.model([FunctionCall(getLightControlStateFunction.name, {})]),
  Content.functionResponse(getLightControlStateFunction.name,
      LightControlDto(brightness: 0).toMap()),
  Content.model([TextPart('The light is currently off.')]),
];

final _testConstraints = [
  Content.text('increase brightness by 30'),
  Content.model([FunctionCall(getLightControlStateFunction.name, {})]),
  Content.functionResponse(getLightControlStateFunction.name,
      LightControlDto(brightness: 90).toMap()),
  Content.model([
    FunctionCall(setLightControlStateFunction.name, {'brightness': 100}),
  ]),
  Content.functionResponse(setLightControlStateFunction.name,
      LightControlDto(brightness: 100).toMap()),
  Content.model([
    TextPart(
      'Cannot increase brightness by 30. I have changed the brightness to 100%',
    )
  ]),
];

final List<Content> _increaseBrightnessBy20 = [
  Content.text('Increase the brightness of the light by 20%'),
  Content.model([FunctionCall(getLightControlStateFunction.name, {})]),
  Content.functionResponse(getLightControlStateFunction.name,
      LightControlDto(brightness: 35).toMap()),
  Content.model([
    FunctionCall(setLightControlStateFunction.name, {'brightness': 35 + 20})
  ]),
  Content.functionResponse(setLightControlStateFunction.name,
      LightControlDto(brightness: 35 + 20).toMap()),
  Content.model([TextPart('I have changed the brightness to 55%')]),
];

final _dimLightBy50 = [
  Content.text('Dim the light by 50%'),
  Content.model([FunctionCall(getLightControlStateFunction.name, {})]),
  Content.functionResponse(getLightControlStateFunction.name,
      LightControlDto(brightness: 85).toMap()),
  Content.model([
    FunctionCall(setLightControlStateFunction.name, {'brightness': 35})
  ]),
  Content.functionResponse(setLightControlStateFunction.name,
      LightControlDto(brightness: 35).toMap()),
  Content.model([TextPart('I have dimmed the light to 35%')]),
];

// final _lightAlreadyOn = [
//   Content.text('Turn on the light!'),
//   Content.model([FunctionCall(getLightControlStateFunction.name, {})]),
//   Content.functionResponse(getLightControlStateFunction.name,
//       LightControlDto(brightness: 35).toMap()),
//   Content.model([TextPart('The light is already on.')]),
// ];

List<Content> get _history => [
      ..._whatIsBrightnessLevel,
      ..._increaseBrightnessBy20,
      ..._dimLightBy50,
      ..._testConstraints
    ];

final _controlLightToolConfig = ToolConfig(
  functionCallingConfig: FunctionCallingConfig(
    mode: FunctionCallingMode.auto,
  ),
);
final controlLightProvider = GeminiProvider(
  model: GeminiModel.flash15Latest.model,
  apiKey: kGeminiApiKey,
  config: GenerationConfig(),
  functions: [getLightControlStateFunction, setLightControlStateFunction],
  toolConfig: _controlLightToolConfig,
  systemInstruction: '''
You are a light control system. You can adjust the brightness of the light in a room.

You can set the brightness of the light to a value between 0 and 100. Zero is off and 100 is full brightness.
''',
  history: _history,
);