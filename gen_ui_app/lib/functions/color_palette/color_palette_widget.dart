import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../ai/helpers/color_helpers.dart';
import 'color_palette_controller.dart';
import 'color_palette_dto.dart';

class ColorPaletteWidgetResponse extends HookWidget {
  const ColorPaletteWidgetResponse(this.data, {super.key});

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
          style: TextStyle(color: color.toContrastColor()),
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

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: GestureDetector(
        onTap: handleSelection,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: 300,
            height: 60,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Stack(
                children: [
                  Row(
                    children: ColorCorner.values.map(_buildCorner).toList(),
                  ),
                  if (isHovered.value)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
