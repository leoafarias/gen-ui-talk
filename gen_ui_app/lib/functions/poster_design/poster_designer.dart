import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mesh/mesh.dart';

import '../../ai/helpers.dart';
import '../../ai/models/llm_function.dart';

part './poster_designer_utils.dart';
part 'poster_designer_dto.dart';

final _updatePosterDesign = LlmFunctionDeclaration(
  name: 'updatePosterDesign',
  description: 'Update the design elements of the poster.',
  parameters: _PosterDesignerDto.schema,
);

final _getCurrentPosterDesign = LlmFunctionDeclaration(
  name: 'getPosterDesign',
  description: 'Get the current design elements of the poster.',
  parameters: _PosterDesignerDto.schema,
);

_PosterDesignerDto _posterDesign = _PosterDesignerDto(
  topLeftColor: Colors.black,
  topRightColor: Colors.grey,
  bottomLeftColor: Colors.grey,
  bottomRightColor: Colors.black,
  posterText: 'Poster Text',
  posterFont: _PosterFont.raleway,
  posterTextColor: Colors.white,
);

JSON _updatePosterDesignHandler(JSON parameters) {
  final posterDesign = _PosterDesignerDto.fromMap(parameters);
  _posterDesign = posterDesign;
  return posterDesign.toMap();
}

JSON _getCurrentPosterDesignHandler(JSON parameters) {
  return _posterDesign.toMap();
}

Widget _designerUiHandler(
  JSON value,
) {
  return PosterDesignerWidget(_PosterDesignerDto.fromMap(value));
}

final getCurrentPosterDesignFunction = LlmFunction(
  function: _getCurrentPosterDesign,
  handler: _getCurrentPosterDesignHandler,
  uiHandler: _designerUiHandler,
);

final updatePosterDesignFunction = LlmFunction(
  function: _updatePosterDesign,
  handler: _updatePosterDesignHandler,
  uiHandler: _designerUiHandler,
);

final posterDesignerToolConfig = ToolConfig(
  functionCallingConfig: FunctionCallingConfig(
    mode: FunctionCallingMode.any,
    allowedFunctionNames: {
      updatePosterDesignFunction.name,
      getCurrentPosterDesignFunction.name
    },
  ),
);

const posterDesignerInstructions = '''
You are a professional poster designer. Your job is to ensure that all design elements are cohesive, visually appealing, and adhere to best design practices.

A poster can have the following elements:

- **posterText**: Central message on the poster.
- **posterFont**: Font style for the text, defining the tone.
- **posterTextColor**: Hex color for the text, ensuring readability.
- **topLeftColor**: Hex color for the top-left corner, part of a mesh gradient.
- **topRightColor**: Hex color for the top-right corner, blending into the gradient.
- **bottomLeftColor**: Hex color for the bottom-left corner, contributing to the gradient.
- **bottomRightColor**: Hex color for the bottom-right corner, completing the gradient.

The four corner colors form a smooth mesh gradient to enhance the visual appeal.
''';

class PosterPreviewWidget extends StatelessWidget {
  final _PosterDesignerDto data;

  const PosterPreviewWidget({super.key, required this.data});

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
                fontSize: 32,
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
  const PosterDesignerWidget(this.data, {super.key});

  final _PosterDesignerDto data;

  @override
  Widget build(BuildContext context) {
    // Initialize poster design state with default values.
    final posterDesign = useState<_PosterDesignerDto>(data);

    final textController =
        useTextEditingController(text: posterDesign.value.posterText);

    // State to manage which color picker is active.
    final activeColorCorner = useState(PosterCorner.topLeft);

    // Available fonts list.
    final fonts = useMemoized(() => _PosterFont.enumString, []);

    // Handler to apply selected color.
    void applyColor(Color color) {
      final corner = activeColorCorner.value;
      final updatedDto = posterDesign.value.copyWith(
        topLeftColor: corner == PosterCorner.topLeft ? color : null,
        topRightColor: corner == PosterCorner.topRight ? color : null,
        bottomLeftColor: corner == PosterCorner.bottomLeft ? color : null,
        bottomRightColor: corner == PosterCorner.bottomRight ? color : null,
      );
      posterDesign.value = updatedDto;
    }

    final currentColor = posterDesign.value.getColor(activeColorCorner.value);

    // Handler to open color picker.
    void openColorPicker(PosterCorner corner) {
      activeColorCorner.value = corner;

      showDialogColorPicker(context, currentColor, applyColor);
    }

    // Handler to change font.
    void changeFont(String? fontName) {
      if (fontName != null) {
        final selectedFont = _PosterFont.fromString(fontName);
        posterDesign.value =
            posterDesign.value.copyWith(posterFont: selectedFont);
      }
    }

    // Handler to change poster text.
    void changePosterText(String text) {
      posterDesign.value = posterDesign.value.copyWith(posterText: text);
    }

    // Handler for confirmation action.
    void confirmDesign() {
      // Update the design via handler or API.
      _updatePosterDesignHandler(posterDesign.value.toMap());

      // Provide user feedback.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Poster design updated successfully!')),
      );
    }

    // Effect to synchronize local state with handlers or external systems.
    useEffect(() {
      _updatePosterDesignHandler(posterDesign.value.toMap());
      return;
    }, [posterDesign.value]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            PosterPreviewWidget(
              data: posterDesign.value,
            ),
          ],
        ),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          onChanged: changePosterText,
          controller: textController,
        ),
        const SizedBox(height: 24),

        // Font Selector
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Select Font',
            border: OutlineInputBorder(),
          ),
          value: posterDesign.value.posterFont.name,
          items: fonts
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
          onChanged: changeFont,
        ),
        const SizedBox(height: 24),
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
            final currentColor = posterDesign.value.getColor(corner);

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

        const SizedBox(height: 24),

        // Confirmation Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: confirmDesign,
            child: const Text('Confirm Design'),
          ),
        ),
      ],
    );
    // Poster Text Input
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
