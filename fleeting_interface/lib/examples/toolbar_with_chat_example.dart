import 'package:flutter/material.dart';

import 'chat_widget.dart';
import 'tool_bar_example_widget.dart';

/// Demonstration of intent-driven, ephemeral toolbar composition.
///
/// Key concepts:
/// 1. Define ALL capabilities upfront (toolbar groups)
/// 2. Show only RELEVANT tools based on user intent
/// 3. Interface adapts through conversation, not navigation
///
/// This is the core of "fleeting interfaces":
/// - Your intent shapes what appears
/// - Context determines what's relevant
/// - Appears when needed, dissolves when done
class ToolbarWithChatExample extends StatefulWidget {
  const ToolbarWithChatExample({super.key});

  @override
  State<ToolbarWithChatExample> createState() =>
      _ToolbarWithChatExampleState();
}

class _ToolbarWithChatExampleState extends State<ToolbarWithChatExample> {
  // Start with basic writing tools
  Set<ToolbarGroup> _shownGroups = {
    ToolbarGroup.marks,
    ToolbarGroup.alignment,
    ToolbarGroup.history,
  };

  String _currentIntent = 'Basic writing';

  void _handleToolSelection(ToolSelection selection) {
    setState(() {
      // Convert string tool IDs to ToolbarGroup enums
      _shownGroups = _convertToToolbarGroups(selection.selectedTools);
      _currentIntent = selection.explanation;
    });
  }

  Set<ToolbarGroup> _convertToToolbarGroups(List<String> toolIds) {
    final groupMap = {
      'file': ToolbarGroup.file,
      'history': ToolbarGroup.history,
      'zoom': ToolbarGroup.zoom,
      'style': ToolbarGroup.style,
      'font': ToolbarGroup.font,
      'marks': ToolbarGroup.marks,
      'insert': ToolbarGroup.insert,
      'alignment': ToolbarGroup.alignment,
      'lists': ToolbarGroup.lists,
      'indent': ToolbarGroup.indent,
      'misc': ToolbarGroup.misc,
    };

    return toolIds
        .map((id) => groupMap[id])
        .whereType<ToolbarGroup>()
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intent-Driven Toolbar'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Chip(
              avatar: const Icon(Icons.psychology, size: 16),
              label: Text(
                _currentIntent,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          // Main content area with toolbar
          Expanded(
            child: Column(
              children: [
                // Intent explanation banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ephemeral, Intent-Driven Interface',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '→ Describe your intent in the chat\n'
                        '→ Toolbar shows only relevant tools\n'
                        '→ Same capabilities, different manifestation',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // The actual toolbar (intent-driven)
                SimpleToolbar(
                  groups: _shownGroups,
                  onCommand: (cmd, payload) {
                    debugPrint('Toolbar -> $cmd payload=$payload');
                  },
                ),

                const Divider(height: 1),

                // Editor area with helpful prompts
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit_document,
                              size: 64,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Try these in the chat →',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                            ),
                            const SizedBox(height: 16),
                            ..._buildExamplePrompts(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Chat widget on the right
          ChatWidget(
            onToolSelectionChanged: _handleToolSelection,
            initialSystemPrompt:
                'You help users by selecting relevant toolbar groups based on their intent. '
                'Available groups: file, history, zoom, style, font, marks, insert, alignment, lists, indent, misc.',
          ),
        ],
      ),
    );
  }

  List<Widget> _buildExamplePrompts(BuildContext context) {
    final examples = [
      '• "I want to write a simple note"',
      '• "I need to format a document"',
      '• "Help me add a list"',
      '• "I want to insert a link"',
      '• "Just reading, minimal tools"',
    ];

    return examples
        .map(
          (example) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              example,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                  ),
            ),
          ),
        )
        .toList();
  }
}
