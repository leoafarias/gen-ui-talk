import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mesh/mesh.dart';
import 'package:superdeck/superdeck.dart';

import '../../ai/components/atoms/code_highlighter.dart';
import '../../ai/components/molecules/playground.dart';
import '../../ai/controllers/chat_controller.dart';
import '../../ai/helpers.dart';
import '../../ai/helpers/color_helpers.dart';
import '../../ai/models/content.dart';
import '../../ai/models/llm_response.dart';
import '../../ai/views/chat_view.dart';
import '../light_control/light_control_page.dart';
import 'color_palette_controller.dart';
import 'color_palette_dto.dart';
import 'color_palette_provider.dart';
import 'color_palette_widget.dart';

class ColorPalettePage extends HookWidget {
  const ColorPalettePage(this.options, {super.key});

  final WidgetBlock options;

  Widget _userContentBuilder(UserContent content) {
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final options = GenAiWidgetOptions.fromMap(this.options.args);
    // Initialize poster design state with default values.
    final controller =
        useChatController(colorPaletteProvider, streamResponse: false);
    final colorPaletteController = useColorPaletteController();
    final palette = colorPaletteController.colorPalette;
    final selectSample = useOnSelectSample(controller);

    final isProcessing = useListenableSelector(
      controller,
      () => controller.isProcessing,
    );

    useEffect(() {
      try {
        if (!isProcessing) {
          final lastResponse = controller.transcript.lastOrNull;

          if (lastResponse is LlmContent) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              colorPaletteController.setColorPalette(
                ColorPaletteDto.fromJson(lastResponse.text),
              );
            });
          }
        }
      } catch (e) {
        print(e);
      }
    }, [isProcessing]);

    final elementBuilder = useCallback((LlmTextElement part) {
      try {
        if (options.isSchema) {
          return JsonSyntax(prettyJson(jsonDecode(part.text)));
        }
        return ColorPaletteResponseView(
          key: ValueKey(part.text),
          controller: colorPaletteController,
          ColorPaletteDto.fromJson(part.text),
        );
      } catch (e) {
        return null;
      }
    }, [colorPaletteController]);

    return Stack(
      children: [
        PlaygroundPage(
          leftFlex: 6,
          rightFlex: 4,
          sampleInputs: options.prompts,
          onSampleSelected: selectSample,
          rightWidget: ChatView(
            controller: controller,
            textElementBuilder: elementBuilder,
            userContentBuilder: _userContentBuilder,
          ),
          leftWidget: _ColorPaletteMesh(palette),
        ),
        renderOptionTypeWidget(options.type),
      ],
    );
  }
}

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
                fontFamily: data.font.fontFamily,
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
