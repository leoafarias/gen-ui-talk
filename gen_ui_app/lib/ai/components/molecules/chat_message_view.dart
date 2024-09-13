// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '../../models/message.dart';
import '../../views/circle_button.dart';
import '../../views/message_builders.dart';
import '../atoms/markdown_view.dart';
import 'attachment_view.dart';

class ChatMessageView extends StatefulWidget {
  const ChatMessageView({
    required this.message,
    this.onEdit,
    this.onSelected,
    this.selected = false,
    this.messageBuilder,
    this.functionResponseBuilder,
    super.key,
  });

  final Message message;

  final void Function()? onEdit;

  final void Function(bool)? onSelected;

  final bool selected;

  final MessageBuilder? messageBuilder;
  final FunctionResponseBuilder? functionResponseBuilder;

  @override
  State<ChatMessageView> createState() => _ChatMessageViewState();

  Widget _responseBuilder(BuildContext context, Message message) {
    return switch (message) {
      (UserMessage message) => _UserMessageView(message),
      (LlmMessage message) => _LlmMessageView(
          message,
          partBuilder: _responseLlmPartBuilder,
        )
    };
  }

  Widget _responseLlmPartBuilder(BuildContext context, LlmResponse message) {
    final functionResponseBuilder =
        this.functionResponseBuilder ?? _LlmFunctionPartView.new;
    return switch (message) {
      (LlmTextResponse message) => _LlmTextPartView(message),
      (LlmFunctionResponse message) => functionResponseBuilder(message),
    };
  }
}

typedef LlmPartBuilder = Widget Function(
    BuildContext context, LlmResponse message);

class _ChatMessageViewState extends State<ChatMessageView> {
  bool get _isUser => widget.message.origin.isUser;

  @override
  Widget build(BuildContext context) {
    final responseBuilder = widget.messageBuilder ?? widget._responseBuilder;
    return GestureDetector(
      onLongPress: _onSelect,
      child: Column(
        children: [
          responseBuilder(context, widget.message),
          const Gap(6),
          if (widget.selected)
            Align(
              alignment: _isUser ? Alignment.centerRight : Alignment.centerLeft,
              child: CircleButtonBar(
                _isUser
                    ? [
                        CircleButton(
                          onPressed: _onEdit,
                          icon: Icons.edit,
                        ),
                        CircleButton(
                          onPressed: () => _onCopy(context),
                          icon: Icons.copy,
                        ),
                        CircleButton(
                          onPressed: _onSelect,
                          icon: Icons.close,
                        ),
                      ]
                    : [
                        CircleButton(
                          onPressed: _onSelect,
                          icon: Icons.close,
                        ),
                        CircleButton(
                          onPressed: () => _onCopy(context),
                          icon: Icons.copy,
                        ),
                      ],
              ),
            ),
        ],
      ),
    );
  }

  void _onSelect() => widget.onSelected?.call(!widget.selected);

  void _onEdit() {
    widget.onSelected?.call(false);
    widget.onEdit?.call();
  }

  Future<void> _onCopy(BuildContext context) async {
    widget.onSelected?.call(false);
    await Clipboard.setData(
        ClipboardData(text: widget.message.toClipboardText()));

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class _UserMessageView extends StatelessWidget {
  const _UserMessageView(this.message);
  final UserMessage message;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Flexible(flex: 2, child: SizedBox()),
          Flexible(
            flex: 6,
            child: Column(
              children: [
                ...[
                  for (final attachment in message.attachments)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          height: 80,
                          width: 200,
                          child: AttachmentView(attachment),
                        ),
                      ),
                    ),
                ],
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.zero,
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        message.prompt,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}

class _LlmMessageView extends StatelessWidget {
  const _LlmMessageView(this.message, {required this.partBuilder});

  final LlmMessage message;
  final LlmPartBuilder partBuilder;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 3,
          child: Column(
            children: message.parts
                .map((part) => partBuilder(context, part))
                .toList(),
          ),
        ),
        const Flexible(flex: 1, child: SizedBox()),
      ],
    );
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

class _LlmFunctionPartView extends StatelessWidget {
  const _LlmFunctionPartView(this.message);
  final LlmFunctionResponse message;

  @override
  Widget build(BuildContext context) {
    return MarkdownView(data: '```json\n${message.args.toString()}\n```');
  }
}
