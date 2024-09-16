import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mesh/mesh.dart';

import '../../ai/components/molecules/chat_input.dart';
import '../../ai/controllers/chat_controller.dart';
import '../../ai/providers/providers.dart';
import '../../main.dart';

part 'poster_designer_dto.dart';
part 'poster_designer_provider.dart';
part 'poster_designer_utils.dart';

_PosterDesignerDto _posterDesign = _PosterDesignerDto(
  topLeftColor: Colors.black,
  topRightColor: Colors.black,
  bottomLeftColor: Colors.black,
  bottomRightColor: Colors.black,
  posterText: 'Poster Text',
  posterFont: _PosterFont.raleway,
  posterTextColor: Colors.white,
);

class PosterPreviewWidget extends StatelessWidget {
  final _PosterDesignerDto data;

  const PosterPreviewWidget(this.data, {super.key});

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
    return Container(
      width: 300, // Increased size for better visibility
      height: 450,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Expanded(child: OMeshGradient(mesh: meshRect)),
          Center(
            child: Text(
              data.posterText,
              style: TextStyle(
                fontFamily: data.posterFont.fontFamily,
                color: data.posterTextColor,
                fontSize: 46,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class PosterDesignerWidget extends HookWidget {
  const PosterDesignerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize poster design state with default values.
    final posterDesign = useState(_posterDesign);
    final isProcessing = useState(false);
    // State to manage which color picker is active.
    final activeColorCorner = useState(PosterCorner.topLeft);
    // Available fonts list.

    final textController = useTextEditingController(
      text: posterDesign.value.posterText,
    );

    final controller = useChatController(posterDesignerProvider);

    final onChangeFont = useCallback((String? fontName) {
      if (fontName != null) {
        final selectedFont = _PosterFont.fromString(fontName);
        posterDesign.value =
            posterDesign.value.copyWith(posterFont: selectedFont);
      }
    }, [posterDesign]);

    final handleMessage = useCallback((String message,
        {Iterable<Attachment>? attachments}) async {
      isProcessing.value = true;
      try {
        final response = await controller.submitMessage(message);

        posterDesign.value = _PosterDesignerDto.fromJson(response.text);
        textController.text = posterDesign.value.posterText;
      } finally {
        isProcessing.value = false;
      }
    }, []);

    // Handler to change poster text.
    final onChangeText = useCallback((String text) {
      posterDesign.value = posterDesign.value.copyWith(posterText: text);
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
                      PosterPreviewWidget(posterDesign.value),
                      _PosterTextSelection(
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

class _PosterTextSelection extends HookWidget {
  const _PosterTextSelection({
    required this.posterDesign,
    required this.textController,
    required this.onChangeText,
    required this.onChangeFont,
  });

  final _PosterDesignerDto posterDesign;
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
        value: posterDesign.posterFont.name,
        items: _PosterFont.enumString
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

  final _PosterDesignerDto posterDesign;
  final PosterCorner activeColorCorner;
  final void Function(_PosterDesignerDto) applyColors;
  final void Function(PosterCorner) onCornerChange;

  @override
  Widget build(context) {
    void applyColor(Color color) {
      final corner = activeColorCorner;
      final updatedDto = posterDesign.copyWith(
        topLeftColor: corner == PosterCorner.topLeft ? color : null,
        topRightColor: corner == PosterCorner.topRight ? color : null,
        bottomLeftColor: corner == PosterCorner.bottomLeft ? color : null,
        bottomRightColor: corner == PosterCorner.bottomRight ? color : null,
      );
      applyColors(updatedDto);
    }

    final currentColor = posterDesign.getColor(activeColorCorner);

    // Handler to open color picker.
    void openColorPicker(PosterCorner corner) {
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
          children: PosterCorner.values.map((corner) {
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
enum PosterCorner {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight;

  String getLabel() => switch (this) {
        PosterCorner.topLeft => 'Top Left',
        PosterCorner.topRight => 'Top Right',
        PosterCorner.bottomLeft => 'Bottom Left',
        PosterCorner.bottomRight => 'Bottom Right',
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
