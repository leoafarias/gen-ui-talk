// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

import '../components/molecules/chat_input.dart';
import '../models/message.dart';
import '../providers/llm_provider_interface.dart';
import 'chat_message_list_view.dart';
import 'message_builders.dart';

/// A widget that displays a chat interface for interacting with an LLM
/// (Language Learning Model).
///
/// This widget creates a chat view where users can send messages to an LLM and
/// receive responses. It handles the display of the chat transcript and the
/// input mechanism for sending new messages.
///
/// The [provider] parameter is required and specifies the LLM provider to use
/// for generating responses.
class LlmChatView extends StatefulWidget {
  /// Creates an LlmChatView.
  ///
  /// The [provider] parameter must not be null.
  const LlmChatView({
    required this.provider,
    this.messageBuilder,
    this.functionResponseBuilder,
    super.key,
  });

  /// The LLM provider used to generate responses in the chat.
  final LlmProvider provider;

  final MessageBuilder? messageBuilder;
  final FunctionResponseBuilder? functionResponseBuilder;

  @override
  State<LlmChatView> createState() => _LlmChatViewState();
}

class _LlmResponse {
  final LlmMessage message;
  final void Function()? onDone;
  StreamSubscription<LlmResponse>? _subscription;
  final void Function()? onUpdate;

  _LlmResponse({
    required Stream<LlmResponse> stream,
    required this.message,
    this.onDone,
    this.onUpdate,
  }) {
    _subscription = stream.listen(
      _handleOnData,
      onDone: _handleOnDone,
      cancelOnError: true,
      onError: _handleOnError,
    );
  }

  void cancel() => _handleClose(LlmMessageStatus.canceled);
  void _handleOnError(dynamic err) {
    message.append(LlmTextResponse(text: 'ERROR: $err'));
    _handleClose(LlmMessageStatus.error);
  }

  void _handleOnDone() {
    message.updateStatus(LlmMessageStatus.success);
    onDone?.call();
  }

  void _handleOnData(LlmResponse part) {
    message.append(part);
    onDone?.call();
  }

  void _handleClose(LlmMessageStatus status) {
    assert(_subscription != null);
    _subscription!.cancel();
    _subscription = null;
    message.updateStatus(status);
    onDone?.call();
  }
}

class _LlmChatViewState extends State<LlmChatView> {
  final _transcript = List<Message>.empty(growable: true);
  _LlmResponse? _current;
  UserMessage? _initialMessage;

  @override
  Widget build(BuildContext context) => Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ChatMessageList(
                transcript: _transcript,
                onEditMessage: _current == null ? _onEditMessage : null,
                messageBuilder: widget.messageBuilder,
                functionResponseBuilder: widget.functionResponseBuilder,
              ),
            ),
            ChatInput(
              initialMessage: _initialMessage,
              submitting: _current != null,
              onSubmit: _onSubmit,
              onCancel: _onCancel,
            ),
          ],
        ),
      );

  Future<void> _onSubmit(
    String prompt,
    Iterable<Attachment> attachments,
  ) async {
    _initialMessage = null;

    final userMessage = UserMessage(prompt: prompt, attachments: attachments);
    final llmMessage = LlmMessage();

    _transcript.addAll([userMessage, llmMessage]);

    _current = _LlmResponse(
      stream: widget.provider.generateStream(prompt, attachments: attachments),
      message: llmMessage,
      onDone: _onDone,
      onUpdate: _onUpdate,
    );

    setState(() {});
  }

  Timer? _updateTimer;

  void _onUpdate() {
    if (_updateTimer?.isActive ?? false) return;
    _updateTimer = Timer(const Duration(milliseconds: 150), () {
      setState(() {});
    });
  }

  void _onDone() => setState(() => _current = null);
  void _onCancel() => _current?.cancel();
  void _onEditMessage(Message message) {
    assert(_current == null);

    // remove the last llm message
    assert(_transcript.last.origin.isLlm);
    _transcript.removeLast();

    // remove the last user message
    assert(_transcript.last.origin.isUser);
    final userMessage = _transcript.removeLast() as UserMessage?;

    // set the text of the controller to the last userMessage
    setState(() => _initialMessage = userMessage);
  }
}
