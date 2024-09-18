import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../components/molecules/ai_content_view.dart';
import '../components/molecules/system_content_view.dart';
import '../components/molecules/user_content_view.dart';
import '../models/ai_response.dart';
import '../models/content.dart';
import 'builder_types.dart';

class ChatMessageList extends StatefulWidget {
  const ChatMessageList({
    required this.transcript,
    this.onEditMessage,
    this.userContentBuilder,
    this.textElementBuilder,
    this.widgetElementBuilder,
    this.functionElementBuilder,
    super.key,
  });

  final List<ContentBase> transcript;

  final void Function(ContentBase message)? onEditMessage;

  final UserContentViewBuilder? userContentBuilder;
  final WidgetElementViewBuilder<AiWidgetElement>? widgetElementBuilder;
  final WidgetElementViewBuilder<AiTextElement>? textElementBuilder;
  final WidgetElementViewBuilder<AiFunctionElement>? functionElementBuilder;

  @override
  State<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController _scrollController = ScrollController();
  List<ContentBase> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.transcript);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ChatMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (listEquals(
      oldWidget.transcript,
      widget.transcript,
    )) return;
    _updateMessages(oldWidget.transcript);
  }

  void _updateMessages(List<ContentBase> oldMessages) {
    final newMessages = widget.transcript;
    final messagesToRemove =
        oldMessages.where((message) => !newMessages.contains(message)).toList();
    final messagesToAdd =
        newMessages.where((message) => !oldMessages.contains(message)).toList();

    for (final message in messagesToRemove) {
      final index = _messages.indexOf(message);
      _listKey.currentState?.removeItem(
        index,
        (context, animation) => _buildMessageItem(message, animation),
      );
      _messages.removeAt(index);
    }

    for (final message in messagesToAdd) {
      _messages.add(message);
      _listKey.currentState?.insertItem(
        0,
      );
    }

    if (messagesToAdd.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Widget _buildMessageItem(ContentBase message, Animation<double> animation) {
    final isLast = _messages.lastOrNull == message;

    final scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    final opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    final slideAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: scaleAnimation.value,
          child: Opacity(
            opacity: opacityAnimation.value,
            child: Transform.translate(
              offset: Offset(0.0, slideAnimation.value),
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: _contentBuilder(context, message, isLast),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _contentBuilder(
      BuildContext context, ContentBase content, bool active) {
    final messageKey = Key('content-${content.id}');

    if (content is UserContent) {
      final userContent = widget.userContentBuilder?.call(content);
      if (userContent != null) {
        return userContent;
      }
    }

    return switch (content) {
      (SystemContent message) => SystemContentView(message, key: messageKey),
      (UserContent message) => UserContentView(message, key: messageKey),
      (AiContentBase message) => AiContentView(
          message,
          key: messageKey,
          active: active,
          widgetBuilder: widget.widgetElementBuilder,
          textBuilder: widget.textElementBuilder,
          functionBuilder: widget.functionElementBuilder,
        )
    };
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedList(
          key: _listKey,
          initialItemCount: _messages.length,
          reverse: true,
          controller: _scrollController,
          itemBuilder: (context, index, animation) {
            final messageIndex = _messages.length - index - 1;
            final message = _messages[messageIndex];
            return _buildMessageItem(message, animation);
          },
        );
      },
    );
  }
}
