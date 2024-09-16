import 'package:flutter/material.dart';

import '../../models/llm_runnable_ui.dart';
import '../../models/message.dart';
import '../../style.dart';
import '../atoms/markdown_view.dart';
import '../atoms/message_bubble.dart';
import 'base_message_view.dart';

class LlmMessageView extends MessageView<ILlmMessage> {
  const LlmMessageView(
    super.message, {
    super.key,
    super.onSelected,
    required this.active,
  });

  // Message is the active one in the chat.
  final bool active;

  List<Widget> _buildMessageParts() {
    final functionParts = message.parts.whereType<LlmFunctionResponsePart>();
    final textParts = message.parts.whereType<LlmTextPart>();

    final renderableWidgets = <String, Widget>{};

    final isFinalizedMessage = message is LlmMessage;

    for (final functionPart in functionParts) {
      final widget = functionPart.getRunnableUi();
      if (widget != null) {
        renderableWidgets[functionPart.function.name] = WidgetResponseProvider(
          isRunning: active && isFinalizedMessage,
          child: widget,
        );
      }
    }

    return [
      ...textParts.map((e) => _LlmTextResponseView(e)),
      ...renderableWidgets.values,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildMessageParts()
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: e,
                    ))
                .toList(),
          ),
        ),
        const Flexible(flex: 1, child: SizedBox()),
      ],
    );
  }
}

class _LlmFunctionResponseView extends StatelessWidget {
  const _LlmFunctionResponseView(
    this.message,
  );
  final LlmFunctionResponsePart message;

  @override
  Widget build(BuildContext context) {
    return MarkdownView(data: '```json\n${message.result.toString()}\n```');
  }
}

class _LlmTextResponseView extends StatelessWidget {
  const _LlmTextResponseView(this.message);
  final LlmTextPart message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          flex: 6,
          child: MessageBubble(
            text: message.text.trim(),
            style: MessageBubbleStyle(
              textStyle: chatTheme.textStyle.copyWith(
                color: chatTheme.onBackGroundColor,
              ),
              backgroundColor: const Color.fromARGB(255, 26, 26, 26),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.zero,
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              alignment: Alignment.topLeft,
            ),
          ),
        ),
        const Flexible(flex: 2, child: SizedBox()),
      ],
    );
  }
}
