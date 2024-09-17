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

    final renderableWidgets = <String, Widget>{};

    for (final functionPart in functionParts) {
      final widget = functionPart.getRunnableUi();
      if (widget != null) {
        renderableWidgets[functionPart.function.name] = WidgetResponseProvider(
          isRunning: active,
          child: widget,
        );
      }
    }

    final shouldRenderText = message.text.trim().isNotEmpty;

    return [
      ...renderableWidgets.values,
      if (shouldRenderText) _LlmTextResponseView(message.text),
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

class SchemaDisplayView extends StatelessWidget {
  const SchemaDisplayView(this.message, {super.key});
  final LlmFunctionResponsePart message;

  @override
  Widget build(BuildContext context) {
    return MarkdownView(data: '```json\n${message.result.toString()}\n```');
  }
}

class _LlmTextResponseView extends StatelessWidget {
  const _LlmTextResponseView(this.message);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          flex: 6,
          child: MessageBubble(
            text: message.trim(),
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
