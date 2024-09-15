import 'package:flutter/material.dart';

import '../../models/message.dart';
import '../atoms/markdown_view.dart';
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
    final widget = response.getRunnableUi();
    if (widget != null && active) {
      return widget;
    }

    return _LlmFunctionResponseView(response);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 3,
          child: Column(
            children: message.parts.map(_llmResponseBuilder).toList(),
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
    return Stack(
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.bolt,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 28),
          child: MarkdownView(data: message.text),
        ),
      ],
    );
  }
}
