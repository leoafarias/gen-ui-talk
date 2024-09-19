import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:mesh/mesh.dart';

import '../../ai/components/atoms/alert_dialog.dart';

import 'custom_card_controller.dart';
import 'custom_card_dto.dart';

class CustomCardResponseView extends HookWidget {
  const CustomCardResponseView(this.data, {super.key});

  final CustomCardDto data;

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);

    final handleSelection = useCallback(() {
      customCardController.setCustomCard(data);
    }, []);

    final showCodeSnippet = useCallback(() {
      showWidgetDetails(
        context,
        title: 'Color Palette JSON',
        contents: data.toMap(),
      );
    });

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
        data.topLeftColor,
        data.topRightColor,
        data.bottomLeftColor,
        data.bottomRightColor,
      ],
    );

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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                            Radius.circular(data.borderRadius)),
                        child: AnimatedOMeshGradient(
                          duration: Durations.short1,
                          mesh: meshRect,
                          size: Size(30, 30),
                        ),
                      ),
                    ),
                    Gap(16),
                    Text(
                      data.name,
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: data.fontFamily.fontFamily,
                      ),
                    )
                  ],
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
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
