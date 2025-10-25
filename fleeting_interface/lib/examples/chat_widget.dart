import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';

import 'tool_definitions.dart';

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
  bool _hasText = false;
  late final GenerativeModel _model;

  @override
  void initState() {
    super.initState();
    _initializeModel();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _initializeModel() {
    // Create JSON schema for tool selection
    final toolSchema = Schema.object(
      properties: {
        'selectedToolGroups': Schema.array(
          description: 'List of tool group IDs to show',
          items: Schema.enumString(
            enumValues: ToolbarDefinitions.allGroups.map((g) => g.id).toList(),
          ),
        ),
        'explanation': Schema.string(
          description: 'Brief explanation of why these tools were selected',
        ),
      },
    );

    // Create model with JSON response configuration
    _model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.5-flash',
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: toolSchema,
      ),
      systemInstruction: Content.text(
        widget.initialSystemPrompt ?? ToolbarDefinitions.generateSystemPrompt(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
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
      // Call firebase_ai with structured JSON output
      final response = await _model.generateContent([Content.text(text)]);
      final jsonText = response.text;

      if (jsonText == null || jsonText.isEmpty) {
        throw Exception('No response from AI');
      }

      // Parse JSON response
      final jsonData = jsonDecode(jsonText) as Map<String, dynamic>;
      final selectedTools =
          (jsonData['selectedToolGroups'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
      final explanation = jsonData['explanation'] as String? ?? '';

      final toolSelection = ToolSelection(
        selectedTools: selectedTools,
        explanation: explanation,
      );

      setState(() {
        _messages.add(ChatMessage(text: explanation, isUser: false));
        _isLoading = false;
      });

      // Notify parent of tool selection
      widget.onToolSelectionChanged(toolSelection);
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

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      color: Colors.black,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Messages area
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Text(
                      'Describe your intent',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: EdgeInsets.zero,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[_messages.length - 1 - index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: _MessageBubble(message: message),
                      );
                    },
                  ),
          ),

          const SizedBox(height: 6),

          // Input field with integrated submit button
          TextField(
            enabled: !_isLoading,
            controller: _controller,
            minLines: 1,
            maxLines: 4,
            style: const TextStyle(color: Colors.black, fontSize: 16),
            decoration: InputDecoration(
              hintText: _isLoading ? '' : 'context',
              hintStyle: const TextStyle(color: Colors.black54, fontSize: 16),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              suffixIcon: _SubmitButton(
                isLoading: _isLoading,
                hasText: _hasText,
                onSubmit: _sendMessage,
              ),
            ),
            onSubmitted: (_) => _sendMessage(),
            textInputAction: TextInputAction.send,
          ),
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.isLoading,
    required this.hasText,
    required this.onSubmit,
  });

  final bool isLoading;
  final bool hasText;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 150),
      scale: !hasText && !isLoading ? 0.0 : 1.0,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: isLoading
                  ? const Icon(Icons.stop, color: Colors.white, size: 20)
                  : IconButton(
                      onPressed: onSubmit,
                      icon: const Icon(Icons.play_arrow, color: Colors.white),
                      padding: EdgeInsets.zero,
                    ),
            ),
            if (isLoading)
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: message.isError
                    ? Colors.red.shade900
                    : Colors.grey.shade800,
                shape: BoxShape.circle,
              ),
              child: Icon(
                message.isError ? Icons.error_outline : Icons.auto_awesome,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Colors.white
                    : message.isError
                    ? Colors.red.shade900.withValues(alpha: 0.3)
                    : Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: 14,
                  color: message.isUser ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, size: 16, color: Colors.white),
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

  ChatMessage({required this.text, required this.isUser, this.isError = false});
}

/// Represents tool selection from the LLM
class ToolSelection {
  final List<String> selectedTools;
  final String explanation;

  ToolSelection({required this.selectedTools, required this.explanation});
}
