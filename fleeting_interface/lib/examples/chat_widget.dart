import 'package:flutter/material.dart';

/// A clean, reusable chat widget that appears on the right side of the screen.
/// Demonstrates ephemeral, intent-driven interfaces.
class ChatWidget extends StatefulWidget {
  const ChatWidget({
    super.key,
    required this.onToolSelectionChanged,
    this.width = 320,
    this.initialSystemPrompt,
  });

  /// Callback when the LLM returns tool selections based on user intent
  final ValueChanged<ToolSelection> onToolSelectionChanged;

  /// Width of the chat panel
  final double width;

  /// Optional system prompt to guide the LLM
  final String? initialSystemPrompt;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      // In a real implementation, this would call firebase_ai
      // For now, this is a placeholder for the schema-based tool selection
      await Future.delayed(const Duration(milliseconds: 500));

      // Simulate LLM response with tool selection
      // This will be replaced with actual firebase_ai integration
      final response = _simulateToolSelection(text);

      setState(() {
        _messages.add(
          ChatMessage(
            text: response.explanation,
            isUser: false,
          ),
        );
        _isLoading = false;
      });

      // Notify parent of tool selection
      widget.onToolSelectionChanged(response);
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: 'Error: ${e.toString()}',
            isUser: false,
            isError: true,
          ),
        );
        _isLoading = false;
      });
    }
  }

  // TODO: Replace with actual firebase_ai integration
  ToolSelection _simulateToolSelection(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    // Simple intent matching for demonstration
    if (lowerMessage.contains('write') || lowerMessage.contains('type')) {
      if (lowerMessage.contains('advanced') ||
          lowerMessage.contains('format')) {
        return ToolSelection(
          selectedTools: ['style', 'font', 'marks', 'alignment'],
          explanation: 'Showing advanced writing tools',
        );
      } else {
        return ToolSelection(
          selectedTools: ['marks', 'alignment'],
          explanation: 'Showing basic writing tools',
        );
      }
    } else if (lowerMessage.contains('edit')) {
      return ToolSelection(
        selectedTools: ['history', 'marks'],
        explanation: 'Showing editing tools',
      );
    } else if (lowerMessage.contains('insert') ||
        lowerMessage.contains('add')) {
      return ToolSelection(
        selectedTools: ['insert', 'lists'],
        explanation: 'Showing insertion tools',
      );
    }

    return ToolSelection(
      selectedTools: [],
      explanation: 'No specific tools needed for this task',
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          left: BorderSide(color: colorScheme.outlineVariant),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              border: Border(
                bottom: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Intent Assistant',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _MessageBubble(message: message);
              },
            ),
          ),

          // Loading indicator
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Thinking...',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

          // Input field
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              border: Border(
                top: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Describe what you want to do...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(Icons.send, color: colorScheme.primary),
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.primaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: message.isError
                  ? colorScheme.errorContainer
                  : colorScheme.primaryContainer,
              child: Icon(
                message.isError ? Icons.error_outline : Icons.smart_toy,
                size: 16,
                color: message.isError
                    ? colorScheme.onErrorContainer
                    : colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: message.isUser
                    ? colorScheme.primaryContainer
                    : message.isError
                        ? colorScheme.errorContainer
                        : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: message.isUser
                          ? colorScheme.onPrimaryContainer
                          : message.isError
                              ? colorScheme.onErrorContainer
                              : colorScheme.onSurface,
                    ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: colorScheme.secondaryContainer,
              child: Icon(
                Icons.person,
                size: 16,
                color: colorScheme.onSecondaryContainer,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Represents a message in the chat
class ChatMessage {
  final String text;
  final bool isUser;
  final bool isError;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isError = false,
  });
}

/// Represents tool selection from the LLM
class ToolSelection {
  final List<String> selectedTools;
  final String explanation;

  ToolSelection({
    required this.selectedTools,
    required this.explanation,
  });
}
