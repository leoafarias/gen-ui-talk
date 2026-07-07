import 'package:flutter/material.dart';

import 'chat_widget.dart';
import 'tool_bar_example_widget.dart';
import 'tool_definitions.dart';

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
class ToolbarDemo extends StatefulWidget {
  const ToolbarDemo({super.key, this.all = false, this.chat = true});

  /// If true, shows all toolbar groups (for demo/presentation purposes)
  final bool all;

  /// If true, shows the chat widget on the right side
  final bool chat;

  @override
  State<ToolbarDemo> createState() => _ToolbarDemoState();
}

class _ToolbarDemoState extends State<ToolbarDemo> {
  late Set<ToolbarGroup> _shownGroups;

  bool _isThinking = false;

  @override
  void initState() {
    super.initState();
    // If 'all' parameter is true, show all groups. Otherwise start with basic writing tools.
    _shownGroups = widget.all
        ? ToolbarGroup.values.toSet()
        : {ToolbarGroup.marks, ToolbarGroup.alignment, ToolbarGroup.history};
  }

  void _handleToolSelection(ToolSelection selection) {
    setState(() {
      // Convert string tool IDs to ToolbarGroup enums
      _shownGroups = _convertToToolbarGroups(selection.selectedTools);
    });
  }

  Set<ToolbarGroup> _convertToToolbarGroups(List<String> toolIds) {
    // Use enum.name for automatic mapping - no manual sync needed
    final groupsByName = {for (var g in ToolbarGroup.values) g.name: g};
    return toolIds
        .map((id) => groupsByName[id])
        .whereType<ToolbarGroup>()
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.transparent, // Dark charcoal background
        child: Row(
          children: [
            // Toolbar showcase on the left
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      color: Colors.transparent,
                      child: _StyledToolbar(
                        groups: _shownGroups,
                        onCommand: (cmd, payload) {
                          debugPrint('Toolbar -> $cmd payload=$payload');
                        },
                      ),
                    ),
                  ),
                  // Thinking bubble at bottom left
                  if (_isThinking)
                    Positioned(left: 24, bottom: 24, child: _ThinkingBubble()),
                ],
              ),
            ),
            // Chat on the right (conditionally shown)
            if (widget.chat)
              ChatWidget(
                onToolSelectionChanged: _handleToolSelection,
                initialSystemPrompt: ToolbarDefinitions.generateSystemPrompt(),
                isThinking: _isThinking,
                onThinkingChanged: (isThinking) {
                  setState(() => _isThinking = isThinking);
                },
                suggestedPrompts: const [
                  'I need to format text',
                  'Help me align content',
                  'Show me list options',
                  "Reading",
                  "Writing Minimal",
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Styled toolbar with black rounded group containers for presentation
class _StyledToolbar extends StatelessWidget {
  const _StyledToolbar({required this.groups, required this.onCommand});

  final Set<ToolbarGroup> groups;
  final void Function(ToolbarCommand command, dynamic payload) onCommand;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        if (groups.contains(ToolbarGroup.file))
          _ToolGroup(
            children: [
              _btn(Icons.search, ToolbarCommand.search),
              _btn(Icons.print, ToolbarCommand.print),
            ],
          ),
        if (groups.contains(ToolbarGroup.history))
          _ToolGroup(
            children: [
              _btn(Icons.undo, ToolbarCommand.undo),
              _btn(Icons.redo, ToolbarCommand.redo),
            ],
          ),
        if (groups.contains(ToolbarGroup.marks))
          _ToolGroup(
            children: [
              _btn(Icons.format_bold, ToolbarCommand.bold),
              _btn(Icons.format_italic, ToolbarCommand.italic),
              _btn(Icons.format_underline, ToolbarCommand.underline),
              _btn(Icons.strikethrough_s, ToolbarCommand.strikethrough),
              _btn(Icons.subscript, ToolbarCommand.subscript),
              _btn(Icons.superscript, ToolbarCommand.superscript),
              _colorPickerBtn(),
              _btn(Icons.highlight, ToolbarCommand.highlight),
            ],
          ),
        if (groups.contains(ToolbarGroup.alignment))
          _ToolGroup(
            children: [
              _btn(Icons.format_align_left, ToolbarCommand.alignLeft),
              _btn(Icons.format_align_center, ToolbarCommand.alignCenter),
              _btn(Icons.format_align_right, ToolbarCommand.alignRight),
              _btn(Icons.format_align_justify, ToolbarCommand.alignJustify),
            ],
          ),
        if (groups.contains(ToolbarGroup.lists))
          _ToolGroup(
            children: [
              _btn(Icons.format_list_bulleted, ToolbarCommand.bulletList),
              _btn(Icons.format_list_numbered, ToolbarCommand.numberList),
              _btn(Icons.checklist, ToolbarCommand.checkList),
            ],
          ),
        if (groups.contains(ToolbarGroup.insert))
          _ToolGroup(
            children: [
              _btn(Icons.link, ToolbarCommand.link),
              _btn(Icons.image, ToolbarCommand.image),
              _btn(Icons.table_chart, ToolbarCommand.table),
              _btn(Icons.emoji_emotions, ToolbarCommand.emoji),
            ],
          ),
        if (groups.contains(ToolbarGroup.style))
          _ToolGroup(children: [_dropdownBtn('Normal', ToolbarCommand.style)]),
        if (groups.contains(ToolbarGroup.font))
          _ToolGroup(
            children: [
              _dropdownBtn('Arial', ToolbarCommand.fontFamily),
              _dropdownBtn('12', ToolbarCommand.fontSize),
            ],
          ),
        if (groups.contains(ToolbarGroup.zoom))
          _ToolGroup(children: [_dropdownBtn('100%', ToolbarCommand.zoom)]),
        if (groups.contains(ToolbarGroup.indent))
          _ToolGroup(
            children: [
              _btn(Icons.format_indent_increase, ToolbarCommand.increaseIndent),
              _btn(Icons.format_indent_decrease, ToolbarCommand.decreaseIndent),
              _btn(Icons.format_line_spacing, ToolbarCommand.lineSpacing),
            ],
          ),
        if (groups.contains(ToolbarGroup.misc))
          _ToolGroup(
            children: [
              _btn(Icons.clear_all, ToolbarCommand.clearFormatting),
              _btn(Icons.history, ToolbarCommand.history),
              _btn(Icons.edit, ToolbarCommand.edit),
            ],
          ),
      ],
    );
  }

  Widget _btn(IconData icon, ToolbarCommand command) {
    return IconButton(
      icon: Icon(icon, color: Colors.white, size: 24),
      onPressed: () => onCommand(command, null),
      tooltip: command.name,
      padding: const EdgeInsets.all(10),
      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
    );
  }

  Widget _colorPickerBtn() {
    return Tooltip(
      message: 'Text color',
      child: InkWell(
        onTap: () => onCommand(ToolbarCommand.textColor, null),
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: 44,
          height: 44,
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.purple.shade400,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.shade400.withValues(alpha: 0.4),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dropdownBtn(String label, ToolbarCommand command) {
    return SizedBox(
      height: 44,
      child: TextButton(
        onPressed: () => onCommand(command, null),
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          minimumSize: const Size(70, 44),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.0,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 18, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

/// Container for a group of toolbar buttons with black rounded background
class _ToolGroup extends StatelessWidget {
  const _ToolGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

/// Animated thinking bubble that appears at bottom left
class _ThinkingBubble extends StatefulWidget {
  @override
  State<_ThinkingBubble> createState() => _ThinkingBubbleState();
}

class _ThinkingBubbleState extends State<_ThinkingBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _AnimatedDot(controller: _controller, delay: 0),
          const SizedBox(width: 6),
          _AnimatedDot(controller: _controller, delay: 0.2),
          const SizedBox(width: 6),
          _AnimatedDot(controller: _controller, delay: 0.4),
        ],
      ),
    );
  }
}

class _AnimatedDot extends StatelessWidget {
  const _AnimatedDot({required this.controller, required this.delay});

  final AnimationController controller;
  final double delay;

  @override
  Widget build(BuildContext context) {
    final animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(delay, delay + 0.4, curve: Curves.easeInOut),
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
