import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../ai/views/llm_chat_view.dart';
import 'light_control_provider.dart';

class LightControlPage extends StatelessWidget {
  const LightControlPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          CustomPaint(
            size: const Size(647, 457),
            painter: RPSCustomPainter(),
          ),
          Expanded(child: LlmChatView(provider: controlLightProvider))
        ],
      ),
    );
  }
}

//Add this CustomPaint widget to the Widget Tree

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 1.245000, 0);
    path_0.lineTo(size.width * -0.2450000, 0);
    path_0.lineTo(size.width * -0.2450000, size.height);
    path_0.lineTo(size.width * 1.245000, size.height);
    path_0.lineTo(size.width * 1.245000, size.height * 0.5000000);
    path_0.lineTo(size.width * 1.245000, 0);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xff192A41).withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);

    Path wallPath = Path();
    wallPath.moveTo(size.width, 0);
    wallPath.lineTo(0, 0);
    wallPath.lineTo(0, size.height * 0.5886214);
    wallPath.lineTo(size.width, size.height * 0.5886214);
    wallPath.lineTo(size.width, 0);
    wallPath.close();

    Paint wallFill = Paint()..style = PaintingStyle.fill;
    wallFill.shader = ui.Gradient.linear(
        const Offset(0, 0), Offset(0, size.height * 58.86214), [
      Colors.black,
      Colors.transparent,
    ], [
      0,
      1
    ]);
    canvas.drawPath(wallPath, wallFill);

    Path doorGapPath = Path();
    doorGapPath.moveTo(size.width * 0.5641422, size.height * 0.2516411);
    doorGapPath.lineTo(size.width * 0.4204019, size.height * 0.2516411);
    doorGapPath.lineTo(size.width * 0.4204019, size.height * 0.5886214);
    doorGapPath.lineTo(size.width * 0.5641422, size.height * 0.5886214);
    doorGapPath.lineTo(size.width * 0.5641422, size.height * 0.2516411);
    doorGapPath.close();

    Paint doorGapFill = Paint()..style = PaintingStyle.fill;
    doorGapFill.color =
        const ui.Color.fromARGB(255, 255, 104, 23).withOpacity(1.0);
    canvas.drawPath(doorGapPath, doorGapFill);

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
      const Color(0xffFF00BF).withOpacity(1),
      Colors.transparent.withOpacity(1)
    ], [
      0,
      0.8
    ]);
    canvas.drawPath(lightReflectionPath, lightReflectionFill);

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
      const Color(0xffFF5500).withOpacity(1),
      const Color(0xffFF1100).withOpacity(1)
    ], [
      0,
      1
    ]);
    canvas.drawPath(doorPath, doorFill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
