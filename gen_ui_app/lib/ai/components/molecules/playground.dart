import 'package:flutter/material.dart';

import '../../models/message.dart';
import '../../providers/llm_provider_interface.dart';
import '../../views/llm_chat_view.dart';

class PlaygroundPage extends StatelessWidget {
  const PlaygroundPage({
    super.key,
    required this.provider,
    required this.body,
    this.messageBuilder,
    this.stream = true,
    this.bodyFlex = 1,
    this.chatFlex = 1,
  });

  final LlmProvider provider;
  final Widget body;
  final bool stream;
  final int bodyFlex;
  final int chatFlex;
  final Widget? Function(BuildContext, Message)? messageBuilder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: bodyFlex,
            child: body,
          ),
          Expanded(
            flex: chatFlex,
            child: LlmChatView(
              messageBuilder: messageBuilder,
              provider: provider,
              stream: stream,
            ),
          )
        ],
      ),
    );
  }
}
