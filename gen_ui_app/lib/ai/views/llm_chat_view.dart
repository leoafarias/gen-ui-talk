// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../components/molecules/chat_input.dart';
import '../controllers/chat_controller.dart';
import '../helpers/hooks.dart';
import '../providers/llm_provider_interface.dart';
import 'chat_message_list_view.dart';
import 'message_builders.dart';

class LlmChatViewStyle {
  final Color backgroundColor;

  const LlmChatViewStyle({
    required this.backgroundColor,
  });
}

class LlmChatView extends HookWidget {
  final LlmProvider provider;
  final MessageBuilder? messageBuilder;
  final bool stream;

  const LlmChatView({
    required this.provider,
    this.messageBuilder,
    super.key,
    this.stream = false,
    this.style = const LlmChatViewStyle(backgroundColor: Colors.black),
  });

  final LlmChatViewStyle style;

  @override
  Widget build(BuildContext context) {
    final chat = useChatController(provider);
    final focusNode = useFocusNode();
    final isProcessing = useListenableSelector(chat, () => chat.isProcessing);
    final initialMessage =
        useListenableSelector(chat, () => chat.initialMessage);
    final transcript = useListenableSelector(chat, () => chat.transcript);

    usePostFrameEffect(() {
      if (!chat.isProcessing) {
        focusNode.requestFocus();
      }
    }, [isProcessing]);
    return ChatControllerProvider(
      notifier: chat,
      child: ListenableBuilder(
        listenable: chat,
        builder: (context, _) {
          return Container(
            color: style.backgroundColor,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: ChatMessageList(
                    transcript: transcript,
                    onEditMessage: !isProcessing ? chat.editMessage : null,
                    messageBuilder: messageBuilder,
                  ),
                ),
                ChatInput(
                  focusNode: focusNode,
                  initialMessage: initialMessage,
                  submitting: isProcessing,
                  onSubmit: stream ? chat.sendMessageStream : chat.sendMessage,
                  onCancel: chat.cancelMessage,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
