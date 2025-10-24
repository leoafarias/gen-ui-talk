import 'package:flutter/material.dart';

import '../../models/content.dart';
import '../../style.dart';
import '../atoms/message_bubble.dart';

class UserContentView extends StatelessWidget {
  final UserContent message;

  const UserContentView(
    this.message, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Flexible(flex: 2, child: SizedBox()),
        Flexible(
          flex: 6,
          child: MessageBubble(
            text: message.prompt,
            style: MessageBubbleStyle(
              textStyle: chatTheme.textStyle.copyWith(
                color: chatTheme.onAccentColor,
              ),
              backgroundColor: chatTheme.accentColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.zero,
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              alignment: Alignment.topRight,
            ),
            attachments: message.attachments.toList(),
          ),
        ),
      ],
    );
  }
}
