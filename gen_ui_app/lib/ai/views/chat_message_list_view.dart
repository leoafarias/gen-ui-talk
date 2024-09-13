// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../components/molecules/llm_message_view.dart';
import '../components/molecules/user_message_view.dart';
import '../models/message.dart';
import 'message_builders.dart';

class ChatMessageList extends StatefulWidget {
  const ChatMessageList({
    required this.transcript,
    this.onEditMessage,
    this.messageBuilder,
    this.functionResponseBuilder,
    super.key,
  });

  final List<Message> transcript;

  final void Function(Message message)? onEditMessage;

  final MessageBuilder? messageBuilder;
  final FunctionResponseBuilder? functionResponseBuilder;

  @override
  State<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList> {
  Widget _messageBuilder(BuildContext context, Message message) {
    if (widget.messageBuilder != null) {
      return widget.messageBuilder!(context, message);
    }

    final messageKey = Key('message-${message.id}');
    return switch (message) {
      (UserMessage message) => UserMessageView(
          message,
          key: messageKey,
        ),
      (LlmMessage message) => LlmMessageView(
          message,
          key: messageKey,
          functionResponseBuilder: widget.functionResponseBuilder,
        )
    };
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => ListView.builder(
          reverse: true,
          itemCount: widget.transcript.length,
          itemBuilder: (context, index) {
            final messageIndex = widget.transcript.length - index - 1;
            final message = widget.transcript[messageIndex];

            return Padding(
              padding: const EdgeInsets.only(top: 6),
              child: _messageBuilder(context, message),
            );
          },
        ),
      );
}
