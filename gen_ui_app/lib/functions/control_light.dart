import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../ai/controllers/chat_controller.dart';
import '../ai/helpers.dart';
import '../ai/models/llm_function.dart';
import '../ai/models/llm_runnable_ui.dart';

part 'control_light.mapper.dart';

@MappableClass()
class ControlLightDto with ControlLightDtoMappable {
  int? brightness;

  ControlLightDto({
    required this.brightness,
  });

  static const fromMap = ControlLightDtoMapper.fromMap;

  static final schema = Schema.object(
    properties: {
      'brightness': Schema.number(
        description:
            'Light level from 0 to 100. Zero is off and 100 is full brightness.',
        nullable: false,
      ),
    },
  );
}

final _controlLightDeclaration = LlmFunctionDeclaration(
  name: 'controlLight',
  description: 'Control lighting in the room and sets brightness level.',
  parameters: ControlLightDto.schema,
);

JSON _controlLightHandler(JSON parameters) {
  return parameters;
}

ControlLightRunnableUi _controlLightUiHandler(
  JSON value,
) {
  return ControlLightRunnableUi(ControlLightDto.fromMap(value));
}

final controlLightFunction = LlmFunction(
  function: _controlLightDeclaration,
  handler: _controlLightHandler,
  uiHandler: _controlLightUiHandler,
);

class ControlLightRunnableUi extends RunnableUi<ControlLightDto> {
  const ControlLightRunnableUi(super.data, {super.key});

  @override
  Widget build(context, RunnableUiState<ControlLightDto> state) {
    final brightness = state.value.brightness ?? 50;

    final chatController = ChatController.of(context);
    ControlLightDto updateState(int brightness) {
      return state.value = state.value.copyWith(
        brightness: brightness,
      );
    }

    return Column(
      children: [
        LightBulb(
          brightness: brightness,
        ),
        Slider(
          value: brightness.toDouble(),
          min: 0,
          max: 100,
          onChanged: (value) => updateState(value.toInt()),
          onChangeEnd: (value) => chatController.submitMessage(
            'Ok I have made the change!',
          ),
        ),
      ],
    );
  }
}

class LightBulb extends StatelessWidget {
  final int brightness;

  const LightBulb({
    super.key,
    required this.brightness,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          // Make the light glow stronger with higher brightness
          BoxShadow(
            color: Colors.white.withOpacity(brightness / 100),
            blurRadius: brightness / 10,
            spreadRadius: brightness / 30,
          ),
        ],
        color: Color.lerp(
          Colors.grey,
          Colors.white,
          brightness / 100,
        ),
      ),
    );
  }
}
