import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:mesh/mesh.dart';
import 'package:mix/mix.dart';

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
    return Box(
      style: Style(
        $box.chain
          ..wrap.intrinsicWidth()
          ..padding(24)
          ..color(data.backgroundColor)
          ..borderRadius(data.borderRadius),
      ),
      child: StyledColumn(
        style: Style(
          $flex.gap(16),
          $flex.mainAxisSize.min(),
          $flex.mainAxisAlignment.center(),
          $flex.crossAxisAlignment.center(),
        ),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(data.borderRadius)),
            child: AnimatedOMeshGradient(
              duration: Durations.short1,
              mesh: mesh,
              size: Size(250, 250),
            ),
          ),
          StyledColumn(
            style: Style(
              $flex.mainAxisAlignment.center(),
              $flex.crossAxisAlignment.center(),
              $flex.mainAxisSize.min(),
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
                    ..style.fontSize(16)
                    ..style.fontWeight.w300(),
                ),
              ),
            ],
          ),
          Slider(
            value: 0.5,
            onChanged: (_) {},
            activeColor: data.accentColor,
          ),
          StyledRow(
            style: Style(
              $flex.chain
                ..mainAxisAlignment.center()
                ..gap(24)
                ..wrap.padding.bottom(8),
              $icon.chain
                ..size(20)
                ..color(data.textColor),
            ),
            children: [
              StyledIcon(
                CupertinoIcons.backward_end_fill,
              ),
              Box(
                inherit: true,
                style: Style(
                  $box.chain
                    ..borderRadius(data.borderRadius)
                    ..height(50)
                    ..width(50)
                    ..color(data.accentColor),
                ),
                child: StyledIcon(CupertinoIcons.play_fill),
              ),
              StyledIcon(
                CupertinoIcons.forward_end_fill,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
