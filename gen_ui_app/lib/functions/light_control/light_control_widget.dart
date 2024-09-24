import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../ai/components/molecules/llm_content_view.dart';
import '../../ai/controllers/chat_controller.dart';
import '../../ai/models/llm_response.dart';
import '../../ai/style.dart';
import 'light_control_controller.dart';
import 'light_control_dto.dart';

class _LightControlWidgetResponse extends HookWidget {
  const _LightControlWidgetResponse(this.data);

  final LightControlDto data;

  void _updateBrightness(num value) {
    lightControlController.setBrightness(value.toInt());
  }

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

    final isOn = brightness.value != 0;

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
                onChangeEnd: _updateBrightness,
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
                        final previousValue = previousBrightness == null ||
                                previousBrightness == 0
                            ? 100
                            : previousBrightness;

                        brightness.value = value ? previousValue : 0;
                        _updateBrightness(brightness.value.toDouble());
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

class LightControlWidgetResponse extends HookWidget {
  final LlmFunctionElement element;
  const LightControlWidgetResponse(this.element, {super.key});

  @override
  Widget build(BuildContext context) {
    final provider = LlmContentViewProvider.of(context);
    if (!provider.active) {
      return const SizedBox.shrink();
    }

    if (!element.isComplete) {
      return const _LightControlWidgetSkeleton();
    }
    return _LightControlWidgetResponse(
        LightControlDto.fromMap(element.requiredData));
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
  late AnimationController controller;
  late Animation<double> animation;
  late Animation<Color?> colorAnimation;
  late Animation<Color?> thumbColorAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    colorAnimation = ColorTween(
      begin: Colors.grey[700],
      end: chatTheme.backgroundColor,
    ).animate(animation);

    thumbColorAnimation = ColorTween(
      begin: Colors.grey[300],
      end: chatTheme.onBackGroundColor,
    ).animate(animation);

    // Set the initial animation state based on the initial value
    if (widget.value) {
      controller.value = 1.0;
    } else {
      controller.value = 0.0;
    }
  }

  @override
  void didUpdateWidget(LightSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the animation when the value changes externally
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        controller.forward();
      } else {
        controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
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
          animation: controller,
          builder: (context, child) {
            return Container(
              width: switchWidth,
              height: switchHeight,
              decoration: BoxDecoration(
                color: colorAnimation.value,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 10 + (switchWidth - switchHeight) * animation.value,
                    child: Container(
                      width: switchHeight - 20,
                      height: switchHeight - 20,
                      decoration: BoxDecoration(
                        color: thumbColorAnimation.value,
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

class _LightControlWidgetSkeleton extends StatefulWidget {
  const _LightControlWidgetSkeleton({super.key});

  @override
  _LightControlWidgetSkeletonState createState() =>
      _LightControlWidgetSkeletonState();
}

class _LightControlWidgetSkeletonState
    extends State<_LightControlWidgetSkeleton> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 20), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: _opacity,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              constraints: const BoxConstraints(minHeight: 125),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.4),
                    Colors.white.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.4),
                  Colors.white.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
