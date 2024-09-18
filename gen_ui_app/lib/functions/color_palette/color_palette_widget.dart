import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';

import '../../ai/components/atoms/alert_dialog.dart';
import '../../ai/helpers/color_helpers.dart';
import 'color_palette_controller.dart';
import 'color_palette_dto.dart';

class ColorPaletteResponseView extends HookWidget {
  const ColorPaletteResponseView(this.data, {super.key});

  final ColorPaletteDto data;

  Widget _buildCorner(ColorCorner corner) {
    final color = data.getColor(corner);
    return Expanded(
      child: Container(
        constraints: const BoxConstraints(minHeight: 60),
        color: data.getColor(corner),
        alignment: Alignment.center,
        child: Text(
          color.toHex(),
          style: TextStyle(color: color.toContrastColor()).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);

    final handleSelection = useCallback(() {
      colorPaletteController.setColorPalette(data);
    }, []);

    final showCodeSnippet = useCallback(() {
      showWidgetDetails(
        context,
        title: 'Color Palette JSON',
        contents: data.toMap(),
      );
    });

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SizedBox(
          height: 60,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Row(
                  children: ColorCorner.values.map(_buildCorner).toList(),
                ),
                if (isHovered.value)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton.filled(
                              onPressed: showCodeSnippet,
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black,
                              ),
                              icon: const Icon(
                                Icons.code,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const Gap(6),
                            IconButton.filled(
                              onPressed: handleSelection,
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black,
                              ),
                              icon: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        )),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
