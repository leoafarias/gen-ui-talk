import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../ai/controllers/chat_controller.dart';
import '../ai/helpers.dart';
import '../ai/models/llm_function.dart';
import '../ai/models/llm_runnable_ui.dart';

part 'control_light.mapper.dart';

@MappableClass()
class ControlLightDto with ControlLightDtoMappable {
  int brightness;

  ControlLightDto({
    required this.brightness,
  });

  static const fromMap = ControlLightDtoMapper.fromMap;

  static final schema = Schema.object(properties: {
    'brightness': Schema.number(
      description:
          'Light level from 0 to 100. Zero is off and 100 is full brightness.',
      nullable: false,
    ),
  }, requiredProperties: [
    'brightness'
  ]);
}

final _controlLightDeclaration = LlmFunctionDeclaration(
  name: 'controlLight',
  description: 'Control lighting in the room and sets brightness level.',
  parameters: ControlLightDto.schema,
);

final _currentLightState = LlmFunctionDeclaration(
  name: 'currentRoomBrightness',
  description: 'Returns the current brightness level of the room.',
  parameters: ControlLightDto.schema,
);

int _brightness = 0;

JSON _controlLightHandler(JSON parameters) {
  _brightness = parameters['brightness'] as int;
  return parameters;
}

JSON _currentLightStateHandler(JSON parameters) {
  return {
    'brightness': _brightness,
  };
}

Widget _controlLightUiHandler(
  JSON value,
) {
  return ControlLightWidget(ControlLightDto.fromMap(value));
}

final currentlightControlStateFunction = LlmFunction(
  function: _currentLightState,
  handler: _currentLightStateHandler,
  uiHandler: _controlLightUiHandler,
);

final controlLightFunction = LlmFunction(
  function: _controlLightDeclaration,
  handler: _controlLightHandler,
  uiHandler: _controlLightUiHandler,
);

class ControlLightWidget extends HookWidget {
  const ControlLightWidget(this.data, {super.key});

  final ControlLightDto data;

  @override
  Widget build(BuildContext context) {
    final brightness = useState(data.brightness);
    final editingValue = useState(false);
    final isRunning = useIsRunning();
    final chatController = useChatController();

    final isOff = brightness.value == 0;

    final canEdit = isRunning && editingValue.value;

    Widget buildSideButton() {
      Color backgroundColor;
      if (!isRunning) {
        return const SizedBox.shrink();
      }
      Widget current;
      if (!editingValue.value) {
        backgroundColor = Colors.white10;
        current = IconButton(
          color: Colors.black,
          icon: const Icon(Icons.edit),
          onPressed: () {
            editingValue.value = true;
          },
        );
      } else {
        backgroundColor = Colors.green;
        current = IconButton(
          color: Colors.white,
          icon: const Icon(Icons.check),
          onPressed: () {
            chatController.submitMessage(
              'Change the brightness to ${brightness.value}%',
            );
          },
        );
      }

      return Container(
        height: 100,
        margin: const EdgeInsets.all(8),
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: backgroundColor,
        ),
        child: current,
      );
    }

    Widget buildDisplay() {
      return Row(
        children: [
          const Icon(
            Icons.light_mode_outlined,
            size: 30,
            color: Colors.white,
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.grey[600],
                trackHeight: 8.0,
                thumbColor: Colors.white,

                overlayShape: SliderComponentShape.noOverlay,

                // minThumbSeparation: 10,
                // tickMarkShape: const RoundSliderTickMarkShape(),
                activeTickMarkColor: Colors.white,
                inactiveTickMarkColor: Colors.grey,
              ),
              child: Slider(
                min: 0,
                max: 100,
                value: brightness.value.toDouble(),
                onChanged: canEdit
                    ? (value) => brightness.value = value.toInt()
                    : null,
              ),
            ),
          ),
          const Icon(Icons.light_mode, size: 30, color: Colors.white),
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Lights",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          constraints: const BoxConstraints(minWidth: 45),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            isOff ? 'off' : '${brightness.value}%',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildDisplay(),
                ],
              ),
            ),
          ),
          buildSideButton(),
        ],
      ),
    );
  }
}
