// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../components/molecules/chat_input.dart';
import '../controllers/chat_controller.dart';
import '../models/ai_response.dart';
import 'builder_types.dart';
import 'chat_message_list_view.dart';

class LlmChatViewStyle {
  final Color backgroundColor;

  const LlmChatViewStyle({
    required this.backgroundColor,
  });
}

class ChatView extends HookWidget {
  final ChatController controller;

  final ControllerWidgetBuilder? inputBuilder;

  const ChatView({
    required this.controller,
    this.userContentBuilder,
    super.key,
    this.inputBuilder,
    this.textElementBuilder,
    this.widgetElementBuilder,
    this.functionElementBuilder,
    this.style = const LlmChatViewStyle(backgroundColor: Colors.black),
  });

  final LlmChatViewStyle style;
  final UserContentViewBuilder? userContentBuilder;
  final WidgetElementViewBuilder<AiWidgetElement>? widgetElementBuilder;
  final WidgetElementViewBuilder<AiTextElement>? textElementBuilder;
  final WidgetElementViewBuilder<AiFunctionElement>? functionElementBuilder;

  Widget _chatInputBuilder(
    ChatController controller,
    FocusNode focusNode,
  ) {
    if (inputBuilder != null) {
      return inputBuilder!(controller);
    }

    return ChatInput(
      controller: controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();

    return ChatControllerProvider(
      notifier: controller,
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          return Container(
            color: style.backgroundColor,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: ChatMessageList(
                    transcript: controller.transcript,
                    textElementBuilder: textElementBuilder,
                    widgetElementBuilder: widgetElementBuilder,
                    functionElementBuilder: functionElementBuilder,
                    onEditMessage: !controller.isProcessing
                        ? controller.editMessage
                        : null,
                    userContentBuilder: userContentBuilder,
                  ),
                ),
                _chatInputBuilder(controller, focusNode),
              ],
            ),
          );
        },
      ),
    );
  }
}
