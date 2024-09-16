// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../components/molecules/chat_input.dart';
import '../controllers/chat_controller.dart';
import '../providers/llm_provider_interface.dart';
import 'llm_chat_view.dart';

class LlmSandboxView extends HookWidget {
  final Widget child;
  final LlmProvider provider;

  const LlmSandboxView({
    super.key,
    required this.child,
    required this.provider,
    this.style = const LlmChatViewStyle(backgroundColor: Colors.black),
  });

  final LlmChatViewStyle style;

  @override
  Widget build(BuildContext context) {
    final controller = useChatController(provider);
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
                  child: Row(
                    children: [child],
                  ),
                ),
                ChatInput(
                  initialMessage: controller.initialMessage,
                  submitting: controller.isProcessing,
                  onSubmit: controller.submitMessage,
                  onCancel: controller.cancelMessage,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
