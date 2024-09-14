import 'package:flutter/material.dart';

import '../../models/message.dart';
import '../atoms/markdown_view.dart';
import 'base_message_view.dart';

class LlmMessageView extends MessageView<LlmMessage> {
  const LlmMessageView(
    super.message, {
    super.key,
    super.onSelected,
  });

  Widget _llmResponseBuilder(LlmResponse response) {
    return switch (response) {
      (LlmTextResponse message) => _LlmTextResponseView(message),
      (LlmFunctionResponse message) => _functionResponseBuilder(message),
    };
  }

  Widget _functionResponseBuilder(LlmFunctionResponse response) {
    if (response is LlmRunnableUiResponse) {
      return response.render();
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
  final LlmFunctionResponse message;

  @override
  Widget build(BuildContext context) {
    return MarkdownView(data: '```json\n${message.args.toString()}\n```');
  }
}

class _LlmTextResponseView extends StatelessWidget {
  const _LlmTextResponseView(this.message);
  final LlmTextResponse message;

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
