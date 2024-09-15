import 'package:flutter/material.dart';

import '../../models/message.dart';
import '../../style.dart';
import '../atoms/message_bubble.dart';
import 'base_message_view.dart';

class SystemMessageView extends MessageView<SystemMesssage> {
  const SystemMessageView(super.message, {super.key, super.onSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          flex: 6,
          child: Row(
            children: [
              MessageBubble(
                text: message.prompt,
                style: MessageBubbleStyle(
                  textStyle: chatTheme.textStyle.copyWith(
                    color: chatTheme.onBackGroundColor,
                  ),
                  backgroundColor: const Color.fromARGB(255, 16, 16, 16),
                  borderRadius: BorderRadius.circular(20),
                  alignment: Alignment.topLeft,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.check_circle,
                  color: chatTheme.onBackGroundColor,
                ),
              ),
            ],
          ),
        ),
        const Flexible(flex: 2, child: SizedBox()),
      ],
    );
  }
}
