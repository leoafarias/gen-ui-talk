import 'package:flutter/material.dart';

import '../../models/message.dart';
import '../../views/message_builders.dart';
import '../atoms/markdown_view.dart';
import 'base_message_view.dart';

class LlmMessageView extends MessageView<LlmMessage> {
  const LlmMessageView(
    super.message, {
    super.key,
    this.functionResponseBuilder,
    super.onSelected,
  });

  final FunctionResponseBuilder? functionResponseBuilder;

  Widget _llmResponseBuilder(LlmResponse response) {
    return switch (response) {
      (LlmTextResponse message) => _LlmTextPartView(message),
      (LlmFunctionResponse message) => _functionResponseBuilder(message),
    };
  }

  Widget _functionResponseBuilder(LlmFunctionResponse response) {
    if (functionResponseBuilder == null) {
      return _LlmFunctionPartView(response);
    }

    return functionResponseBuilder!(response);
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

class _LlmFunctionPartView extends StatelessWidget {
  const _LlmFunctionPartView(this.message);
  final LlmFunctionResponse message;

  @override
  Widget build(BuildContext context) {
    return MarkdownView(data: '```json\n${message.args.toString()}\n```');
  }
}

class _LlmTextPartView extends StatelessWidget {
  const _LlmTextPartView(this.message);
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
