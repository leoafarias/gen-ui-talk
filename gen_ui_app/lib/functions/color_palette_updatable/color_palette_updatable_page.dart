import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:superdeck/superdeck.dart';

import '../../ai/components/atoms/code_highlighter.dart';
import '../../ai/components/molecules/playground.dart';
import '../../ai/controllers/chat_controller.dart';
import '../../ai/helpers.dart';
import '../../ai/models/content.dart';
import '../../ai/models/llm_response.dart';
import '../../ai/views/chat_view.dart';
import '../color_palette/color_palette_controller.dart';
import '../light_control/light_control_page.dart';
import 'color_palette_updatable_dto.dart';
import 'color_palette_updatable_provider.dart';
import 'color_palette_widget.dart';

class ColorPaletteUpdatablePage extends HookWidget {
  const ColorPaletteUpdatablePage(this.options, {super.key});

  final WidgetBlock options;

  Widget _userContentBuilder(UserContent content) {
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final options = GenAiWidgetOptions.fromMap(this.options.args);
    // Initialize poster design state with default values.
    final controller =
        useChatController(colorPaletteUpdatableProvider, streamResponse: false);
    final colorPaletteController = useColorPaletteController();
    final palette = colorPaletteController.colorPalette;
    final selectSample = useOnSelectSample(controller);

    final elementBuilder = useCallback((LlmTextElement part) {
      try {
        if (options.isSchema) {
          return JsonSyntax(prettyJson(jsonDecode(part.text)));
        }
        return ColorPaletteUpdatableResponseView(
          data: WidgetSchemaDto.fromMap(jsonDecode(part.text)),
        );
      } catch (e) {
        return null;
      }
    }, [colorPaletteController]);

    return Stack(
      children: [
        PlaygroundPage(
          leftFlex: 0,
          rightFlex: 4,
          sampleInputs: options.prompts,
          onSampleSelected: selectSample,
          rightWidget: Row(
            children: [
              const Spacer(),
              Expanded(
                flex: 4,
                child: ChatView(
                  controller: controller,
                  textElementBuilder: elementBuilder,
                  userContentBuilder: _userContentBuilder,
                ),
              ),
              const Spacer(),
            ],
          ),
          leftWidget: const SizedBox(),
        ),
        renderOptionTypeWidget(options.type),
      ],
    );
  }
}
