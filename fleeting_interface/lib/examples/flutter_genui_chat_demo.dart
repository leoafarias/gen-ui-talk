import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_genui/flutter_genui.dart';
import 'package:flutter_genui_firebase_ai/flutter_genui_firebase_ai.dart';
import 'package:logging/logging.dart';

class FlutterGenUiChatDemo extends StatefulWidget {
  const FlutterGenUiChatDemo({super.key});

  @override
  State<FlutterGenUiChatDemo> createState() => _FlutterGenUiChatDemoState();
}

class _FlutterGenUiChatDemoState extends State<FlutterGenUiChatDemo> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_GenUiChatMessage> _messages = [];
  late final GenUiConversation _conversation;
  late final GenUiManager _manager;

  @override
  void initState() {
    super.initState();
    _initializeConversation();
  }

  void _initializeConversation() {
    if (!_loggingConfigured) {
      configureGenUiLogging(level: Level.INFO);
      _loggingConfigured = true;
    }

    final catalog = CoreCatalogItems.asCatalog();
    _manager = GenUiManager(catalog: catalog);
    final contentGenerator = FirebaseAiContentGenerator(
      catalog: catalog,
      systemInstruction: _buildSystemInstruction(),
    );

    _conversation = GenUiConversation(
      genUiManager: _manager,
      contentGenerator: contentGenerator,
      onSurfaceAdded: _handleSurfaceAdded,
      onTextResponse: _handleTextResponse,
      onError: _handleError,
    );
  }

  void _handleSurfaceAdded(SurfaceAdded surface) {
    if (!mounted) return;
    setState(() {
      _messages.add(_GenUiChatMessage.surface(surface.surfaceId));
    });
    _scrollToBottom();
  }

  void _handleTextResponse(String text) {
    if (!mounted) return;
    setState(() {
      _messages.add(_GenUiChatMessage.aiText(text));
    });
    _scrollToBottom();
  }

  void _handleError(ContentGeneratorError error) {
    genUiLogger.severe(
      'Error from content generator',
      error.error,
      error.stackTrace,
    );

    if (!mounted) return;
    setState(() {
      _messages.add(
        _GenUiChatMessage.aiText('Something went wrong: ${error.error}'),
      );
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900, maxHeight: 640),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white24, width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 20,
                    offset: Offset(0, 16),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Flutter Gen UI — Firebase AI Chat',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Describe your intent. Gen UI turns it into surfaces.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: _messages.isEmpty
                            ? _EmptyState(message: _emptyStateMessage)
                            : ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.only(bottom: 8),
                                physics: const BouncingScrollPhysics(),
                                itemCount: _messages.length,
                                itemBuilder: (context, index) {
                                  final message = _messages[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    child: _GenUiMessageBubble(
                                      message: message,
                                      host: _conversation.host,
                                    ),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 12),
                      ValueListenableBuilder<bool>(
                        valueListenable: _conversation.isProcessing,
                        builder: (_, isProcessing, __) {
                          return AnimatedOpacity(
                            opacity: isProcessing ? 1 : 0,
                            duration: const Duration(milliseconds: 220),
                            child: Row(
                              children: [
                                const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Generating widgets and copy…',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _Composer(
                        controller: _textController,
                        onSend: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    setState(() {
      _messages.add(_GenUiChatMessage.user(text));
    });
    _scrollToBottom();

    unawaited(_conversation.sendRequest(UserMessage([TextPart(text)])));
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _conversation.dispose();
    super.dispose();
  }
}

class _Composer extends StatelessWidget {
  const _Composer({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Ask for a UI: "show sliders for oven modes"',
                hintStyle: TextStyle(color: Colors.white54),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: Colors.white,
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}

class _GenUiMessageBubble extends StatelessWidget {
  const _GenUiMessageBubble({required this.message, required this.host});

  final _GenUiChatMessage message;
  final GenUiHost host;

  @override
  Widget build(BuildContext context) {
    final text = message.text;
    if (message.surfaceId != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white24),
          color: Colors.white.withValues(alpha: 0.02),
        ),
        padding: const EdgeInsets.all(12),
        child: GenUiSurface(host: host, surfaceId: message.surfaceId!),
      );
    }

    final alignment = message.isUser
        ? Alignment.centerRight
        : Alignment.centerLeft;
    final bubbleColor = message.isUser
        ? const Color(0xFF2563EB)
        : Colors.white.withValues(alpha: 0.08);
    final textColor = message.isUser ? Colors.white : Colors.white70;

    return Align(
      alignment: alignment,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white24,
            width: message.isUser ? 0 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            text ?? '',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: textColor, height: 1.3),
          ),
        ),
      ),
    );
  }
}

class _GenUiChatMessage {
  _GenUiChatMessage.user(String text)
    : text = 'You: $text',
      surfaceId = null,
      isUser = true;

  _GenUiChatMessage.aiText(String text)
    : text = 'AI: $text',
      surfaceId = null,
      isUser = false;

  _GenUiChatMessage.surface(this.surfaceId) : text = null, isUser = false;

  final String? text;
  final String? surfaceId;
  final bool isUser;
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.auto_awesome, color: Colors.white38, size: 40),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

bool _loggingConfigured = false;

const String _emptyStateMessage =
    'Ask for UI. Gen UI converts your intent into widgets.';

String _buildSystemInstruction() {
  return '''
You are a helpful assistant who chats with a user, giving exactly one response
for each user message. Your responses should acknowledge what the user said.

${GenUiPromptFragments.basicChat}
''';
}
