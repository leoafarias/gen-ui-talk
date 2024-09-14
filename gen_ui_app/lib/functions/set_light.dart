import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../ai/controllers/chat_controller.dart';
import '../ai/models/llm_function.dart';
import '../ai/models/llm_runnable_ui.dart';

part 'set_light.mapper.dart';

@MappableEnum()
enum LightStatus {
  off,
  on;

  static List<String> get enumString => values.map((e) => e.name).toList();
}

@MappableClass()
class SetLightDto with SetLightDtoMappable {
  int? brightness;
  LightStatus? status;

  SetLightDto({
    required this.brightness,
    required this.status,
  });

  static final schema = Schema.object(
    properties: {
      'brightness': Schema.number(
        description:
            'Light level from 0 to 100. Zero is off and 100 is full brightness.',
        nullable: true,
      ),
      'status': Schema.enumString(
        enumValues: LightStatus.enumString,
        description:
            'Status of the light fixture which can be `on` or `off`. Default: `on`',
        nullable: true,
      ),
    },
  );
}

final setLightValuesFunction = LlmFunction(
  name: 'controlLight',
  description: 'Set the brightness of a room light. ',
  parameters: SetLightDto.schema,
);

final setLightValuesUi = LlmUiFunction<SetLightDto>(
  setLightValuesFunction,
  renderer: LLmUiRenderer(
    builder: (value) => _SetLightWidget(
      value: value,
    ),
    parser: RunnableUiParser(
      decoder: SetLightDtoMapper.fromMap,
      encoder: (SetLightDto value) => value.toMap(),
    ),
  ),
);

class _SetLightWidget extends RunnableUi<SetLightDto> {
  const _SetLightWidget({required super.value});

  @override
  Widget build(context, RunnableUiState<SetLightDto> state) {
    final brightness = state.value.brightness ?? 50;

    final chatController = ChatController.of(context);
    SetLightDto updateState({int? brightness, LightStatus? status}) {
      return state.value = value.copyWith(
        brightness: brightness,
        status: status,
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
          onChanged: (value) => updateState(brightness: value.toInt()),
          onChangeEnd: (value) => chatController
              .submitMessage('I have updated to ${state.value.toMap()}'),
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
