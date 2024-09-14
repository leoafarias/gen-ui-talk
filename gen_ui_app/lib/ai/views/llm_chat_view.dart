// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../components/molecules/chat_input.dart';
import '../controllers/chat_controller.dart';
import '../providers/llm_provider_interface.dart';
import 'chat_message_list_view.dart';
import 'message_builders.dart';

class LlmChatView extends StatefulWidget {
  final LlmProvider provider;
  final MessageBuilder? messageBuilder;

  const LlmChatView({
    required this.provider,
    this.messageBuilder,
    super.key,
  });

  @override
  State<LlmChatView> createState() => _LlmChatViewState();
}

class _LlmChatViewState extends State<LlmChatView> {
  late final ChatController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ChatController(provider: widget.provider);
  }

  @override
  Widget build(BuildContext context) {
    return ChatControllerProvider(
      notifier: _controller,
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: ChatMessageList(
                    transcript: _controller.transcript,
                    onEditMessage: !_controller.isProcessing
                        ? _controller.editMessage
                        : null,
                    messageBuilder: widget.messageBuilder,
                  ),
                ),
                ChatInput(
                  initialMessage: _controller.initialMessage,
                  submitting: _controller.isProcessing,
                  onSubmit: _controller.submitMessage,
                  onCancel: _controller.cancelMessage,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
