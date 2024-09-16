import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mesh/mesh.dart';

import '../../ai/components/molecules/chat_input.dart';
import '../../ai/controllers/chat_controller.dart';
import '../../ai/helpers/color_helpers.dart';
import '../../ai/providers/providers.dart';
import 'quote_designer_dto.dart';
import 'quote_designer_provider.dart';

final _defaultPosterDesign = QuoteDesignDto(
  topLeftColor: Colors.black,
  topRightColor: Colors.black,
  bottomLeftColor: Colors.black,
  bottomRightColor: Colors.black,
  quote: 'Quote goes here',
  quoteTextFont: QuoteTextFontFamily.raleway,
  quoteTextColor: Colors.white,
  quoteTextShadowColor: Colors.black,
  quoteTextFontWeight: QuoteTextFontWeight.normal,
);

class QuotePreview extends StatelessWidget {
  final QuoteDesignDto data;

  const QuotePreview(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    final theDarkestColor = [
      data.topLeftColor,
      data.topRightColor,
      data.bottomLeftColor,
      data.bottomRightColor
    ].reduce((value, element) =>
        value.computeLuminance() < element.computeLuminance()
            ? value
            : element);

    final lightestColor = [
      data.topLeftColor,
      data.topRightColor,
      data.bottomLeftColor,
      data.bottomRightColor
    ].reduce((value, element) =>
        value.computeLuminance() > element.computeLuminance()
            ? value
            : element);

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

    return Container(
      width: 300, // Increased size for better visibility
      height: 450,
      clipBehavior: Clip.hardEdge,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Stack(
        children: [
          Expanded(child: OMeshGradient(mesh: meshRect)),
          Positioned.fill(
            child: FractionallySizedBox(
              widthFactor: 1.5,
              heightFactor: 1.5,
              alignment: Alignment.center,
              child: ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    data.quote,
                    style: TextStyle(
                      fontFamily: data.quoteTextFont.fontFamily,
                      height: 0.8,
                      color: lightestColor,
                      fontSize: 120,
                      fontWeight: data.quoteTextFontWeight.fontWeight,
                      shadows: [
                        Shadow(
                          color: lightestColor,
                          // offset: const Offset(40, 10),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                data.quote,
                style: TextStyle(
                  height: 1.5,
                  fontFamily: data.quoteTextFont.fontFamily,
                  color: data.quoteTextColor,
                  shadows: [
                    Shadow(
                      color: theDarkestColor,
                      offset: const Offset(2, 2),
                      blurRadius: 2,
                    ),
                  ],
                  fontSize: 26,
                  fontWeight: data.quoteTextFontWeight.fontWeight,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuoteDesignerExample extends HookWidget {
  const QuoteDesignerExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize poster design state with default values.
    final posterDesign = useState(_defaultPosterDesign);
    final isProcessing = useState(false);
    // State to manage which color picker is active.
    final activeColorCorner = useState(ColorCorner.topLeft);
    // Available fonts list.

    final textController = useTextEditingController(
      text: posterDesign.value.quote,
    );

    final controller = useChatController(quoteDesignProvider);

    final onChangeFont = useCallback((String? fontName) {
      if (fontName != null) {
        final selectedFont = QuoteTextFontFamily.fromString(fontName);
        posterDesign.value =
            posterDesign.value.copyWith(quoteTextFont: selectedFont);
      }
    }, [posterDesign]);

    final handleMessage = useCallback((String message,
        {Iterable<Attachment>? attachments}) async {
      isProcessing.value = true;
      try {
        final response = await controller.sendMessage(message);

        posterDesign.value = QuoteDesignDto.fromJson(response.text);
        textController.text = posterDesign.value.quote;
      } finally {
        isProcessing.value = false;
      }
    }, []);

    // Handler to change poster text.
    final onChangeText = useCallback((String text) {
      posterDesign.value = posterDesign.value.copyWith(quote: text);
    }, [posterDesign]);

    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      QuotePreview(posterDesign.value),
                      _QuoteTextSelection(
                        posterDesign: posterDesign.value,
                        textController: textController,
                        onChangeText: onChangeText,
                        onChangeFont: onChangeFont,
                      ),
                      const SizedBox(height: 24),
                      _ColorSelectionGrid(
                        posterDesign: posterDesign.value,
                        activeColorCorner: activeColorCorner.value,
                        applyColors: (poster) => posterDesign.value = poster,
                        onCornerChange: (corner) =>
                            activeColorCorner.value = corner,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        ChatInput(
          initialMessage: controller.initialMessage,
          submitting: isProcessing.value,
          onSubmit: handleMessage,
          onCancel: controller.cancelMessage,
        ),
      ],
    );
    // Poster Text Input
  }
}

class _QuoteTextSelection extends HookWidget {
  const _QuoteTextSelection({
    required this.posterDesign,
    required this.textController,
    required this.onChangeText,
    required this.onChangeFont,
  });

  final QuoteDesignDto posterDesign;
  final TextEditingController textController;
  final ValueChanged<String> onChangeText;
  final ValueChanged<String?> onChangeFont;

  @override
  Widget build(context) {
    return Column(children: [
      TextField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        onChanged: onChangeText,
        controller: textController,
      ),
      const SizedBox(height: 24),

      // Font Selector
      DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: 'Select Font',
          border: OutlineInputBorder(),
        ),
        value: posterDesign.quoteTextFont.name,
        items: QuoteTextFontFamily.enumString
            .map(
              (font) => DropdownMenuItem(
                value: font,
                child: Text(font,
                    style: TextStyle(
                      fontFamily: font,
                      fontSize: 16,
                    )),
              ),
            )
            .toList(),
        onChanged: onChangeFont,
      ),
    ]);
  }
}

class _ColorSelectionGrid extends StatelessWidget {
  const _ColorSelectionGrid({
    required this.posterDesign,
    required this.activeColorCorner,
    required this.applyColors,
    required this.onCornerChange,
  });

  final QuoteDesignDto posterDesign;
  final ColorCorner activeColorCorner;
  final void Function(QuoteDesignDto) applyColors;
  final void Function(ColorCorner) onCornerChange;

  @override
  Widget build(context) {
    void applyColor(Color color) {
      final corner = activeColorCorner;
      final updatedDto = posterDesign.copyWith(
        topLeftColor: corner == ColorCorner.topLeft ? color : null,
        topRightColor: corner == ColorCorner.topRight ? color : null,
        bottomLeftColor: corner == ColorCorner.bottomLeft ? color : null,
        bottomRightColor: corner == ColorCorner.bottomRight ? color : null,
      );
      applyColors(updatedDto);
    }

    final currentColor = posterDesign.getColor(activeColorCorner);

    // Handler to open color picker.
    void openColorPicker(ColorCorner corner) {
      onCornerChange(corner);

      showDialogColorPicker(context, currentColor, applyColor);
    }

    return Column(
      children: [
        const Text(
          'Colors',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: ColorCorner.values.map((corner) {
            final currentColor = posterDesign.getColor(corner);

            final label = corner.getLabel();

            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => openColorPicker(corner),
                child: Container(
                  color: currentColor,
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: currentColor.toContrastColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Enum to represent poster corners for color selection.
enum ColorCorner {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight;

  String getLabel() => switch (this) {
        ColorCorner.topLeft => 'Top Left',
        ColorCorner.topRight => 'Top Right',
        ColorCorner.bottomLeft => 'Bottom Left',
        ColorCorner.bottomRight => 'Bottom Right',
      };
}

void showDialogColorPicker(
  BuildContext context,
  Color currentColor,
  ValueChanged<Color> changeColor,
) =>
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog.adaptive(
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Done'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
            content: SingleChildScrollView(
              child: ColorPicker(
                onColorChanged: changeColor,
                paletteType: PaletteType.hsvWithHue,
                portraitOnly: true,
                labelTypes: const [],
                // paletteType: PaletteType.hslWithHue,
                pickerAreaBorderRadius: BorderRadius.circular(10),
                pickerAreaHeightPercent: 0.7,
                pickerColor: currentColor,
              ),
            ),
          );
        });
