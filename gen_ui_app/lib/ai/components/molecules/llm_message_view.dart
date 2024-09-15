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

  Widget _llmResponseBuilder(LlmMessagePart response) {
    return switch (response) {
      (LlmTextPart message) => _LlmTextResponseView(message),
      (LlmFunctionResponsePart message) => _functionResponseBuilder(message),
    };
  }

  Widget _functionResponseBuilder(
    LlmFunctionResponsePart response,
  ) {
    final isFinalizedMessage = message is LlmMessage;
    final widget = response.getRunnableUi();
    if (widget != null) {
      return WidgetResponseProvider(
        isRunning: active && isFinalizedMessage,
        child: widget,
      );
    }

    return _LlmFunctionResponseView(response);
  }

  List<LlmMessagePart> get _orderedParts {
    final functionParts =
        message.parts.whereType<LlmFunctionResponsePart>().toList();
    final textParts = message.parts.whereType<LlmTextPart>().toList();

    return [
      ...textParts,
      ...functionParts,
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
            children: _orderedParts
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: _llmResponseBuilder(e),
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
