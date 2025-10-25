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
class ToolbarWithChatExample extends StatefulWidget {
  const ToolbarWithChatExample({super.key});

  @override
  State<ToolbarWithChatExample> createState() => _ToolbarWithChatExampleState();
}

class _ToolbarWithChatExampleState extends State<ToolbarWithChatExample> {
  // Start with basic writing tools
  Set<ToolbarGroup> _shownGroups = {
    ToolbarGroup.marks,
    ToolbarGroup.alignment,
    ToolbarGroup.history,
  };

  void _handleToolSelection(ToolSelection selection) {
    setState(() {
      // Convert string tool IDs to ToolbarGroup enums
      _shownGroups = _convertToToolbarGroups(selection.selectedTools);
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

    return toolIds.map((id) => groupMap[id]).whereType<ToolbarGroup>().toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Row(
        children: [
          // Toolbar showcase on the left
          Expanded(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                child: _StyledToolbar(
                  groups: _shownGroups,
                  onCommand: (cmd, payload) {
                    debugPrint('Toolbar -> $cmd payload=$payload');
                  },
                ),
              ),
            ),
          ),
          // Chat on the right
          ChatWidget(
            onToolSelectionChanged: _handleToolSelection,
            initialSystemPrompt: ToolbarDefinitions.generateSystemPrompt(),
          ),
        ],
      ),
    );
  }
}

/// Styled toolbar where each group has its own black rounded background
class _StyledToolbar extends StatelessWidget {
  const _StyledToolbar({
    required this.groups,
    required this.onCommand,
  });

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
              _btn(Icons.format_color_text, ToolbarCommand.textColor),
              _btn(Icons.highlight, ToolbarCommand.highlight),
            ],
          ),
        if (groups.contains(ToolbarGroup.alignment))
          _ToolGroup(
            children: [
              _btn(Icons.format_align_left, ToolbarCommand.alignLeft),
              _btn(Icons.format_align_center, ToolbarCommand.alignCenter),
              _btn(Icons.format_align_right, ToolbarCommand.alignRight),
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
            ],
          ),
        if (groups.contains(ToolbarGroup.style))
          _ToolGroup(
            children: [
              _dropdownBtn('Normal', ToolbarCommand.style),
            ],
          ),
        if (groups.contains(ToolbarGroup.font))
          _ToolGroup(
            children: [
              _dropdownBtn('Arial', ToolbarCommand.fontFamily),
              _dropdownBtn('12', ToolbarCommand.fontSize),
            ],
          ),
        if (groups.contains(ToolbarGroup.zoom))
          _ToolGroup(
            children: [
              _dropdownBtn('100%', ToolbarCommand.zoom),
            ],
          ),
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
            const Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: Colors.white,
            ),
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
