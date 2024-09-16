import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../ai/controllers/chat_controller.dart';
import '../ai/helpers.dart';
import '../ai/models/llm_function.dart';
import '../ai/models/llm_runnable_ui.dart';
import '../ai/style.dart';

class ControlLightDto {
  final int brightness;

  ControlLightDto({
    required this.brightness,
  });

  static ControlLightDto fromMap(Map<String, dynamic> map) {
    return ControlLightDto(
      brightness: map['brightness'] as int,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'brightness': brightness,
    };
  }

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
final controlLightToolConfig = ToolConfig(
  functionCallingConfig: FunctionCallingConfig(
    mode: FunctionCallingMode.auto,
  ),
);
const controlLightInstructions =
    'You are a lighting control system. You will use the functions below to control the lighting in the room.';

class ControlLightWidget extends HookWidget {
  const ControlLightWidget(this.data, {super.key});

  final ControlLightDto data;

  @override
  Widget build(BuildContext context) {
    final brightness = useState(data.brightness);
    final previousBrightness = usePrevious(brightness.value);
    final chatController = ChatController.of(context);

    void handleConfirmation() {
      var message = 'Confirmed';
      if (brightness.value != data.brightness) {
        if (brightness.value == 0.0) {
          message = 'Light turned off';
        } else {
          message = 'Light level updated to ${brightness.value}%';
        }
      }

      chatController.addSystemMessage(message);
    }

    void onChangeUpdate(double value) {
      final dto = ControlLightDto(brightness: value.toInt());
      _controlLightHandler(dto.toMap());
    }

    final active = isActiveWidget();

    final isOn = brightness.value != 0;

    if (!active) {
      return const SizedBox.shrink();
    }

    Widget buildDisplay() {
      return Row(
        children: [
          Icon(
            Icons.light_mode_outlined,
            size: 30,
            color: chatTheme.backgroundColor,
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: chatTheme.backgroundColor,
                inactiveTrackColor: chatTheme.backgroundColor.withOpacity(0.5),
                trackHeight: 8.0,
                thumbColor: chatTheme.backgroundColor,
                overlayShape: SliderComponentShape.noOverlay,
                activeTickMarkColor: Colors.white,
                inactiveTickMarkColor: Colors.grey,
              ),
              child: Slider(
                min: 0,
                max: 100,
                value: brightness.value.toDouble(),
                onChangeEnd: (value) => onChangeUpdate(value),
                onChanged: (value) => brightness.value = value.toInt(),
              ),
            ),
          ),
          Icon(
            Icons.light_mode,
            size: 30,
            color: chatTheme.backgroundColor,
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: chatTheme.onBackGroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Lights",
                              style: chatTheme.textStyle.copyWith(
                                fontSize: 22,
                                color: chatTheme.backgroundColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              constraints: const BoxConstraints(minWidth: 45),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: chatTheme.backgroundColor,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Text(isOn ? '${brightness.value}%' : 'Off',
                                  style: chatTheme.textStyle.copyWith(
                                    color: chatTheme.accentColor,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      buildDisplay(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: LightSwitch(
                      value: isOn,
                      onChanged: (value) {
                        brightness.value =
                            value ? (previousBrightness ?? 100) : 0;
                        _controlLightHandler({
                          'brightness': brightness.value,
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10.0),
          decoration: BoxDecoration(
            color: chatTheme.accentColor,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            color: chatTheme.onAccentColor,
            onPressed: handleConfirmation,
            icon: const Icon(Icons.check),
          ),
        ),
      ],
    );
  }
}

class LightSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const LightSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  _LightSwitchState createState() => _LightSwitchState();
}

class _LightSwitchState extends State<LightSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Color?> _colorAnimation;
  late Animation<Color?> _thumbColorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _colorAnimation = ColorTween(
      begin: Colors.grey[700],
      end: chatTheme.backgroundColor,
    ).animate(_animation);

    _thumbColorAnimation = ColorTween(
      begin: Colors.grey[300],
      end: chatTheme.onBackGroundColor,
    ).animate(_animation);

    // Set the initial animation state based on the initial value
    if (widget.value) {
      _controller.value = 1.0;
    } else {
      _controller.value = 0.0;
    }
  }

  @override
  void didUpdateWidget(LightSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the animation when the value changes externally
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleSwitch() {
    widget.onChanged(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    const switchWidth = 100.0;
    const switchHeight = 50.0;
    const borderRadius = switchHeight / 2;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: toggleSwitch,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: switchWidth,
              height: switchHeight,
              decoration: BoxDecoration(
                color: _colorAnimation.value,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 10 + (switchWidth - switchHeight) * _animation.value,
                    child: Container(
                      width: switchHeight - 20,
                      height: switchHeight - 20,
                      decoration: BoxDecoration(
                        color: _thumbColorAnimation.value,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
