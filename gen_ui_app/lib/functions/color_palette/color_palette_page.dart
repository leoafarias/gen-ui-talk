import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mesh/mesh.dart';

import '../../ai/components/atoms/markdown_view.dart';
import '../../ai/components/molecules/playground.dart';
import '../../ai/helpers/color_helpers.dart';
import '../../ai/models/message.dart';
import 'color_palette_controller.dart';
import 'color_palette_dto.dart';
import 'color_palette_provider.dart';
import 'color_palette_widget.dart';

class ColorPalettePage extends HookWidget {
  const ColorPalettePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize poster design state with default values.
    final controller = useListenable(colorPaletteController);
    final colorPalette = controller.colorPalette;

    final noColorSelected = colorPalette == null;

    final messageBuilder = useCallback((BuildContext context, Message message) {
      if (message is ILlmMessage) {
        return ColorPaletteWidgetResponse(
          key: ValueKey(message.id),
          ColorPaletteDto.fromJson(message.text),
        );
      } else {
        return const SizedBox();
      }
    }, []);

    return PlaygroundPage(
      provider: colorPaletteSchemaProvider,
      stream: false,
      bodyFlex: 6,
      chatFlex: 4,
      messageBuilder: messageBuilder,
      body: noColorSelected
          ? _ColorPaletteMesh(
              _defaultPalette,
            )
          : _ColorPaletteMesh(colorPalette),
    );
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
        // Addf a  button that when you tap it adds a modal with the snippet of the json
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.black,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      title: const Text('Color Palette JSON'),
                      content: buildCodeHighlighter(
                        data.toJson(),
                        'json',
                        textStyle: GoogleFonts.jetBrainsMono().copyWith(
                          height: 1.4,
                          fontSize: 22,
                        ),
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Icon(Icons.code),
            ),
          ),
        )
      ],
    );
  }
}
