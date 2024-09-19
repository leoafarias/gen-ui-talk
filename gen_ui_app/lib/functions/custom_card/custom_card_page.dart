import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:mesh/mesh.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';

import '../../ai/components/molecules/playground.dart';
import '../../ai/controllers/chat_controller.dart';

import '../../ai/models/ai_response.dart';
import '../../ai/models/content.dart';
import '../../ai/views/chat_view.dart';
import 'custom_card_controller.dart';
import 'custom_card_dto.dart';
import 'custom_card_widget.dart';
import 'custom_card_provider.dart';

final global = GlobalKey();

class CustomCardPage extends HookWidget {
  final bool schemaOnly;
  const CustomCardPage({super.key, this.schemaOnly = false});

  Widget? _textElementBuilder(AiTextElement part) {
    try {
      return CustomCardResponseView(
        key: ValueKey(part.text),
        CustomCardDto.fromJson(part.text),
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
    final controller = useChatController(customCardProvider);
    final dto = useCustomCard((c) => c.cardDto);

    return PlaygroundPage(
      leftFlex: 6,
      rightFlex: 4,
      rightWidget: ChatView(
        controller: controller,
        textElementBuilder: _textElementBuilder,
        userContentBuilder: _userContentBuilder,
      ),
      leftWidget: _CustomCardMesh(
        dto ?? _defaultDto,
      ),
    );
  }
}

final _defaultDto = CustomCardDto(
  name: 'With or Without You',
  subtitle: 'Rock',
  backgroundColor: Colors.white,
  borderRadius: 20,
  fontFamily: CustomCardTextFontFamily.bungee,
  accentColor: Colors.redAccent,
  textColor: Colors.black,
  bottomLeftColor: Colors.red,
  bottomRightColor: Colors.black,
  topLeftColor: Colors.redAccent,
  topRightColor: Colors.amber.shade900,
  iconEmotion: 'Love',
);

class _CustomCardMesh extends StatelessWidget {
  final CustomCardDto data;

  const _CustomCardMesh(this.data);

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
        data.topLeftColor,
        data.topRightColor,
        data.bottomLeftColor,
        data.bottomRightColor,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data.name,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  color: data.textColor,
                  fontFamily: data.fontFamily.fontFamily,
                  height: 1,
                  fontSize: 90,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Gap(60),
              MusicPlayer(
                data: data,
                mesh: meshRect,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MusicPlayer extends StatelessWidget {
  const MusicPlayer({
    super.key,
    required this.data,
    required this.mesh,
  });

  final CustomCardDto data;
  final OMeshRect mesh;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(data.borderRadius)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Box(
          style: Style(
            $box.chain
              ..width(400)
              ..padding(8)
              ..color(data.backgroundColor.withOpacity(0.3))
              ..borderRadius(data.borderRadius),
          ),
          child: StyledRow(
            style: Style(
              $flex.chain
                ..mainAxisSize.min()
                ..mainAxisAlignment.start()
                ..crossAxisAlignment.center(),
            ),
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(data.borderRadius)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedOMeshGradient(
                      duration: Durations.short1,
                      mesh: mesh,
                      size: Size(180, 180),
                    ),
                    StyledIcon(
                      EmotionIcons.getIcon(data.iconEmotion),
                      style: Style(
                        $icon.chain..size(70),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StyledColumn(
                  style: Style(
                    $flex.chain
                      ..wrap.padding.left(24)
                      ..wrap.padding.right(16)
                      ..mainAxisAlignment.start()
                      ..crossAxisAlignment.start(),
                  ),
                  children: [
                    StyledText(
                      data.name,
                      style: Style(
                        $text.chain
                          ..style.color(data.textColor)
                          ..style.fontSize(20)
                          ..style.fontFamily(data.fontFamily.fontFamily)
                          ..style.fontWeight.w700(),
                      ),
                    ),
                    StyledText(
                      data.subtitle,
                      style: Style(
                        $text.chain
                          ..style.color(data.textColor)
                          ..style.color.withOpacity(0.8)
                          ..style.fontSize(15)
                          ..style.fontWeight.w300(),
                      ),
                    ),
                    StyledRow(
                      style: Style(
                        $flex.chain
                          ..wrap.padding.vertical(24)
                          ..mainAxisAlignment.spaceAround()
                          ..crossAxisAlignment.end(),
                        $icon.chain
                          ..size(25)
                          ..color(data.textColor),
                      ),
                      children: [
                        StyledIcon(
                          CupertinoIcons.backward_fill,
                        ),
                        StyledIcon(CupertinoIcons.play_fill),
                        StyledIcon(
                          CupertinoIcons.forward_fill,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                      child: Stack(
                        children: [
                          LayoutBuilder(builder: (context, constraints) {
                            return Container(
                              decoration: BoxDecoration(
                                color: data.accentColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: constraints.maxWidth * 0.3,
                            );
                          }),
                          Container(
                            decoration: BoxDecoration(
                              color: data.accentColor.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
