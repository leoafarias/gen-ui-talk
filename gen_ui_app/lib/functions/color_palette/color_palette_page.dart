import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mesh/mesh.dart';

import '../../ai/components/molecules/playground.dart';
import '../../ai/controllers/chat_controller.dart';
import '../../ai/helpers/color_helpers.dart';
import '../../ai/models/ai_response.dart';
import '../../ai/models/content.dart';
import '../../ai/views/chat_view.dart';
import 'color_palette_controller.dart';
import 'color_palette_dto.dart';
import 'color_palette_provider.dart';
import 'color_palette_widget.dart';

class ColorPalettePage extends HookWidget {
  final bool schemaOnly;
  const ColorPalettePage({super.key, this.schemaOnly = false});

  Widget? _textElementBuilder(AiTextElement part) {
    try {
      return ColorPaletteResponseView(
        key: ValueKey(part.text),
        ColorPaletteDto.fromJson(part.text),
      );
    } catch (e) {
      return null;
    }
  }

  Widget _userContentBuilder(UserContent content) {
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize poster design state with default values.
    final controller = useChatController(colorPaletteProvider);
    final palette = useColorPalette((c) => c.colorPalette);

    return PlaygroundPage(
        leftFlex: 6,
        rightFlex: 4,
        rightWidget: ChatView(
          controller: controller,
          textElementBuilder: _textElementBuilder,
          userContentBuilder: _userContentBuilder,
        ),
        leftWidget: _ColorPaletteMesh(
          palette ?? _defaultPalette,
        ));
  }
}

final _defaultPalette = ColorPaletteDto(
  name: 'Build your own color palette',
  colorPaletteTextFont: ColorPaletteTextFontFamily.bungee,
  colorPaletteTextColor: const Color(
      0xFF00D486), // Vibrant green to stand out against the cool colors
  topLeftColor: const Color.fromARGB(255, 1, 157, 234),
  topRightColor: const Color(0xFF4527A0),
  bottomRightColor: const Color.fromARGB(255, 0, 169, 143),
  bottomLeftColor: const Color.fromARGB(255, 0, 212, 134),
);

class _ColorPaletteMesh extends StatelessWidget {
  final ColorPaletteDto data;

  const _ColorPaletteMesh(this.data);

  @override
  Widget build(BuildContext context) {
    final meshRect = OMeshRect(
      width: 2,
      height: 2,
      fallbackColor: const Color(0xff0e0e0e),
      backgroundColor: const Color(0x00d6d6d6),
      vertices: [
        OVertex(0, 0), OVertex(1, 0), // Row 1
        OVertex(0, 1), OVertex(1, 1), // Row 2
      ],
      colors: [
        data.topLeftColor, data.topRightColor, // Row 1
        data.bottomLeftColor, data.bottomRightColor, // Row 2
      ],
    );

    return Stack(
      children: [
        AnimatedOMeshGradient(
          mesh: meshRect,
          duration: const Duration(seconds: 1),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              data.name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontFamily: data.colorPaletteTextFont.fontFamily,
                height: 1,
                color: getContrastColorFromPalette(data),
                fontSize: 90,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
