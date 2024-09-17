import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../ai/components/molecules/playground.dart';
import 'light_control_controller.dart';
import 'light_control_provider.dart';

class LightControlPage extends HookWidget {
  const LightControlPage({super.key, this.schema = false});

  // If should display only schema
  final bool schema;

  @override
  Widget build(BuildContext context) {
    final lightControl = useListenable(lightControlController);

    final provider = schema ? controlLightSchemaProvider : controlLightProvider;

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 500),
      initialValue: lightControl.brightness.toDouble(),
      lowerBound: 0,
      upperBound: 100,
    );

    useEffect(() {
      animationController.animateTo(
        lightControl.brightness.toDouble(),
        curve: Curves.easeInOut,
      );
      return null;
    }, [lightControl.brightness]);

    return PlaygroundPage(
      provider: provider,
      body: Column(
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.cover,
              child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, _) {
                    return CustomPaint(
                      size: const Size(647, 457),
                      painter: RPSCustomPainter(
                        brightness: animationController.value.toInt(),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  final int brightness;
  const RPSCustomPainter({
    required this.brightness,
    super.repaint,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final isOff = brightness < 1;
    final lightColor =
        Color.lerp(Colors.black, Colors.white, brightness / 100)!;
    final floorColor = Color.lerp(Colors.black,
        const ui.Color.fromARGB(255, 44, 44, 44), brightness / 100)!;
    final reflectionColor =
        Color.lerp(Colors.black, Colors.white, brightness / 100)!;

    const foreGround = ui.Color.fromARGB(255, 6, 6, 6);
    const background = ui.Color.fromARGB(255, 9, 9, 9);

    Path floorPath = Path();
    floorPath.moveTo(size.width, 0);
    floorPath.lineTo(0, 0);
    floorPath.lineTo(0, size.height);
    floorPath.lineTo(size.width, size.height);
    floorPath.lineTo(size.width, 0);
    floorPath.close();

    Paint floorFill = Paint()..style = PaintingStyle.fill;
    floorFill.shader =
        ui.Gradient.linear(const Offset(0, 0), Offset(0, size.height), [
      isOff ? background : floorColor,
    ], [
      1
    ]);
    canvas.drawPath(floorPath, floorFill);

    Path wallPath = Path();
    wallPath.moveTo(size.width, 0);
    wallPath.lineTo(0, 0);
    wallPath.lineTo(0, size.height * 0.5886214);
    wallPath.lineTo(size.width, size.height * 0.5886214);
    wallPath.lineTo(size.width, 0);
    wallPath.close();

    Paint wallFill = Paint()..style = PaintingStyle.fill;
    wallFill.shader = ui.Gradient.linear(const Offset(0, 0),
        Offset(0, size.height), [isOff ? foreGround : Colors.black], [1]);
    canvas.drawPath(wallPath, wallFill);

    Path lightReflectionPath = Path();
    lightReflectionPath.moveTo(size.width * 0.5641422, size.height * 0.5886214);
    lightReflectionPath.lineTo(size.width * 0.4204019, size.height * 0.5886214);
    lightReflectionPath.lineTo(
        size.width * -0.003091190, size.height * 0.9956236);
    lightReflectionPath.lineTo(size.width * 1.001546, size.height * 0.9956236);
    lightReflectionPath.lineTo(size.width * 0.5641422, size.height * 0.5886214);
    lightReflectionPath.close();

    Paint lightReflectionFill = Paint()..style = PaintingStyle.fill;
    lightReflectionFill.shader = ui.Gradient.linear(
        Offset(size.width * 0.4204019, size.height * 0.5886214),
        Offset(size.width * 0.4204019, size.height * 0.9956236), [
      isOff ? Colors.transparent : reflectionColor,
      isOff ? Colors.transparent : Colors.transparent,
    ], [
      0,
      0.8,
    ]);
    canvas.drawPath(lightReflectionPath, lightReflectionFill);

    if (isOff) {
      Path darkLightReflectionPath = Path();
      darkLightReflectionPath.moveTo(
          size.width * 0.5641422, size.height * 0.5886214);
      darkLightReflectionPath.lineTo(size.width * 0.2, size.height * 0.5886214);
      darkLightReflectionPath.lineTo(
          size.width * -0.003091190, size.height * 0.9956236);
      darkLightReflectionPath.lineTo(
          size.width * 1.001546, size.height * 0.9956236);
      darkLightReflectionPath.lineTo(
          size.width * 0.5641422, size.height * 0.5886214);
      darkLightReflectionPath.close();

      Paint darkLightReflection = Paint()..style = PaintingStyle.fill;
      darkLightReflection.shader = ui.Gradient.linear(
          Offset(size.width * 0.2, size.height * 0.5886214),
          Offset(size.width * 0.2, size.height * 0.9956236), [
        isOff ? foreGround : Colors.transparent,
        isOff ? background : Colors.transparent,
      ], [
        0,
        0.8,
      ]);
      canvas.drawPath(darkLightReflectionPath, darkLightReflection);
    }

    Path doorGapPath = Path();
    doorGapPath.moveTo(size.width * 0.5641422, size.height * 0.2516411);
    doorGapPath.lineTo(size.width * 0.4204019, size.height * 0.2516411);
    doorGapPath.lineTo(size.width * 0.4204019, size.height * 0.5886214);
    doorGapPath.lineTo(size.width * 0.5641422, size.height * 0.5886214);
    doorGapPath.lineTo(size.width * 0.5641422, size.height * 0.2516411);
    doorGapPath.close();

    Paint doorGapFill = Paint()..style = PaintingStyle.fill;
    doorGapFill.color = isOff ? Colors.transparent : lightColor;
    canvas.drawPath(doorGapPath, doorGapFill);

    Path doorDarkGapPath = Path();
    doorDarkGapPath.moveTo(size.width * 0.5641422, size.height * 0.2516411);
    doorDarkGapPath.lineTo(size.width * 0.4204019, size.height * 0.2516411);
    doorDarkGapPath.lineTo(size.width * 0.4204019, size.height * 0.5886214);
    doorDarkGapPath.lineTo(size.width * 0.5641422, size.height * 0.5886214);
    doorDarkGapPath.lineTo(size.width * 0.5641422, size.height * 0.2516411);
    doorDarkGapPath.close();

    if (isOff) {
      Paint doorDarkGapFill = Paint()..style = PaintingStyle.fill;
      doorDarkGapFill.shader = ui.Gradient.linear(
          Offset(size.width * 0.4204019, size.height * 0.2516411),
          Offset(size.width * 0.4204019, size.height * 0.5886214),
          [Colors.black.withOpacity(0.7), Colors.black.withOpacity(0.1)],
          [0, 1]);
      canvas.drawPath(doorDarkGapPath, doorDarkGapFill);
    }
    Path doorPath = Path();
    doorPath.moveTo(size.width * 0.4204019, size.height * 0.2516411);
    doorPath.lineTo(size.width * 0.3663060, size.height * 0.1903720);
    doorPath.lineTo(size.width * 0.3663060, size.height * 0.6433260);
    doorPath.lineTo(size.width * 0.4204019, size.height * 0.5886214);
    doorPath.lineTo(size.width * 0.4204019, size.height * 0.2516411);
    doorPath.close();

    Paint doorFill = Paint()..style = PaintingStyle.fill;
    doorFill.shader = ui.Gradient.linear(
        Offset(size.width * 0.3663060, size.height * 0.4168490),
        Offset(size.width * 0.4204019, size.height * 0.4168490), [
      isOff ? Colors.transparent : lightColor,
    ], [
      1,
    ]);
    canvas.drawPath(doorPath, doorFill);

    // Glow effect around the door with intensity based on brightness
    double glowIntensity = brightness / 100;
    double glowStrokeWidth = 30 * glowIntensity;
    double glowBlurRadius = 30 * glowIntensity;
    Paint glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = glowStrokeWidth
      ..color = lightColor.withOpacity(0.7 * glowIntensity)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowBlurRadius);

    canvas.drawPath(doorGapPath, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
