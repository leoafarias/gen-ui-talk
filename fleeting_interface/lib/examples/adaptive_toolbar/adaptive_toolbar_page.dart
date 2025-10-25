// Copyright 2025 The Flutter Authors.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_genui/flutter_genui.dart';
import 'package:flutter_genui_firebase_ai/flutter_genui_firebase_ai.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'src/catalog.dart';

/// Adaptive Toolbar Demo Page
/// Demonstrates intent-driven toolbar composition:
/// - Left side (75%): Live toolbar preview
/// - Right side (25%): Context input & AI chat
class AdaptiveToolbarPage extends StatefulWidget {
  const AdaptiveToolbarPage({super.key});

  @override
  State<AdaptiveToolbarPage> createState() => _AdaptiveToolbarPageState();
}

class _AdaptiveToolbarPageState extends State<AdaptiveToolbarPage> {
  // ===== Core components =====
  late final GenUiManager _genUiManager;
  late final FirebaseAiClient _aiClient;
  final List<ChatMessage> _conversation = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  // Subscriptions
  StreamSubscription<UserMessage>? _userMessageSubscription;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeGenUi();
  }

  void _initializeGenUi() {
    // Initialize GenUiManager with adaptive toolbar catalog
    _genUiManager = GenUiManager(
      catalog: adaptiveToolbarCatalog,
      configuration: const GenUiConfiguration(
        actions: ActionsConfig(
          allowCreate: true,
          allowUpdate: false, // Atomic buttons don't update, only create/delete
          allowDelete: true, // Essential for ephemeral lifecycle
        ),
      ),
    );

    // Subscribe to UI interactions (if toolbar emits events)
    _userMessageSubscription = _genUiManager.onSubmit.listen(
      _handleUserMessageFromUi,
    );

    // Initialize AI client
    final tools = _genUiManager.getTools();

    _aiClient = FirebaseAiClient(
      tools: tools,
      systemInstruction: _systemPrompt,
    );

    // Subscribe to surface updates
    _genUiManager.surfaceUpdates.listen((update) {
      setState(() {
        switch (update) {
          case SurfaceAdded(:final surfaceId, :final definition):
            _conversation.add(
              AiUiMessage(definition: definition, surfaceId: surfaceId),
            );
          case SurfaceRemoved(:final surfaceId):
            _conversation.removeWhere(
              (msg) => msg is AiUiMessage && msg.surfaceId == surfaceId,
            );
          case SurfaceUpdated(:final surfaceId, :final definition):
            final index = _conversation.indexWhere(
              (msg) => msg is AiUiMessage && msg.surfaceId == surfaceId,
            );
            if (index != -1) {
              _conversation[index] = AiUiMessage(
                definition: definition,
                surfaceId: surfaceId,
              );
            }
        }
      });
      _autoScroll();
    });

    // Start with initial greeting
    _sendInitialGreeting();
  }

  void _sendInitialGreeting() {
    _conversation.add(
      UserMessage.text('Show me a toolbar for writing'),
    );
    _triggerInference();
  }

  void _sendPrompt() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _conversation.add(UserMessage.text(text));
      _textController.clear();
    });
    _triggerInference();
  }

  void _handleUserMessageFromUi(UserMessage message) {
    setState(() {
      _conversation.add(message);
    });
    _triggerInference();
  }

  Future<void> _triggerInference() async {
    setState(() => _isLoading = true);

    try {
      final result = await _aiClient.generateContent(
        _conversation,
        S.object(
          properties: {
            'result': S.boolean(
              description: 'Whether the toolbar was updated successfully',
            ),
            'message': S.string(
              description: 'Optional message to user explaining the change',
            ),
          },
          required: ['result'],
        ),
      );

      // Handle text response if any
      if (result != null) {
        final value =
            (result as Map).cast<String, Object?>()['message'] as String? ?? '';
        if (value.isNotEmpty) {
          setState(() {
            _conversation.add(AiTextMessage.text(value));
          });
        }
      }
    } catch (e) {
      setState(() {
        _conversation.add(
          AiTextMessage.text('Error: ${e.toString()}'),
        );
      });
    } finally {
      setState(() => _isLoading = false);
      _autoScroll();
    }
  }

  void _autoScroll() {
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
    // Find all toolbar surfaces (IDs starting with "tb_")
    final toolbarSurfaces = _conversation
        .whereType<AiUiMessage>()
        .where((msg) => msg.surfaceId.startsWith('tb_'))
        .toList();

    // Count buttons vs dividers for display
    final buttonCount = toolbarSurfaces
        .where((msg) => !msg.surfaceId.contains('div'))
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adaptive Toolbar Demo'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== LEFT SIDE: Toolbar Preview (75%) =====
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                border: Border(
                  right: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Live Toolbar Preview',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Type a context on the right to see the toolbar adapt',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  // Toolbar surfaces display
                  if (toolbarSurfaces.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      ),
                      child: Column(
                        children: [
                          // Button counter
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.widgets_outlined, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  '$buttonCount buttons active',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          // Toolbar buttons
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: toolbarSurfaces
                                .map((msg) => GenUiSurface(
                                      key: msg.uiKey,
                                      host: _genUiManager,
                                      surfaceId: msg.surfaceId,
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),

                  // Editor placeholder
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.description_outlined,
                            size: 64,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Document Editor Area',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.6),
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'The toolbar above changes based on your context',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ===== RIGHT SIDE: Chat Interface (25%) =====
          Expanded(
            flex: 1,
            child: Column(
              children: [
                // Chat header
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Context Input',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Try: "writing", "copy editing", "prompt", "minimal", "advanced"',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                // Conversation history
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _conversation.length,
                    itemBuilder: (context, index) {
                      final message = _conversation[index];

                      // Skip UI messages (they're shown on the left)
                      if (message is AiUiMessage) {
                        return const SizedBox.shrink();
                      }

                      if (message is UserMessage) {
                        final text = message.parts
                            .whereType<TextPart>()
                            .map((part) => part.text)
                            .join('\n');

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                text,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      if (message is AiTextMessage) {
                        final text = message.parts
                            .whereType<TextPart>()
                            .map((part) => part.text)
                            .join('\n');

                        if (text.trim().isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(text),
                            ),
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),

                // Loading indicator
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: LinearProgressIndicator(),
                  ),

                // Input field
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            hintText: 'Type context...',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onSubmitted: (_) => _sendPrompt(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _sendPrompt,
                        icon: const Icon(Icons.send),
                        tooltip: 'Send',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== System Prompt =====
  static const String _systemPrompt = '''
# Atomic Toolbar Assistant

## Your Role
You compose individual toolbar buttons that appear and dissolve based on editing context. Each button is a separate surface with its own CREATE/DELETE lifecycle.

## Core Principles
1. **True Ephemeral Lifecycle**: Each button is a SEPARATE surface - create when needed, delete when not
2. **Intent-Driven Composition**: User's intent determines which specific buttons appear
3. **Everyone Tax Reduction**: Show only needed buttons, not groups of buttons
4. **No Updates**: Buttons don't change - you CREATE and DELETE them

## Available Buttons (28 total)

### File Operations
- `SearchButton` - Search document for text
- `PrintButton` - Print document

### History
- `UndoButton` - Undo last action
- `RedoButton` - Redo last undone action

### Text Formatting (Marks)
- `BoldButton` - Make text bold
- `ItalicButton` - Make text italic
- `UnderlineButton` - Underline text
- `TextColorButton` - Change text color
- `HighlightButton` - Highlight text background

### Insert
- `LinkButton` - Insert hyperlink
- `ImageButton` - Insert image

### Alignment
- `AlignLeftButton` - Align text left
- `AlignCenterButton` - Align text center
- `AlignRightButton` - Align text right

### Lists
- `BulletListButton` - Create bulleted list
- `NumberListButton` - Create numbered list
- `CheckListButton` - Create task checklist

### Indent
- `IndentDecreaseButton` - Decrease indentation
- `IndentIncreaseButton` - Increase indentation

### Misc
- `ClearFormattingButton` - Remove all formatting
- `HistoryButton` - View version history
- `EditButton` - Enter edit mode

## Available Controls (5 dropdowns)

- `ZoomControl` - Zoom level selector (50%, 75%, 100%, 125%, 150%, 200%)
- `StyleControl` - Text style selector (Normal, Title, Subtitle, Heading 1/2/3)
- `FontFamilyControl` - Font family selector (Arial, Roboto, Georgia, Times New Roman, Courier)
- `FontSizeControl` - Font size selector (9, 10, 11, 12, 14, 18, 24)
- `LineSpacingControl` - Line spacing selector (1.0, 1.15, 1.5, 2.0)

## Layout Element (1)

- `VerticalDivider` - Visual separator between button groups

## Context → Button Composition

### "writing" or "drafting"
**Purpose:** Focus on content creation, minimal distractions
**Create these surfaces:**
1. Surface ID: "tb_bold", widget: "BoldButton"
2. Surface ID: "tb_italic", widget: "ItalicButton"
3. Surface ID: "tb_div1", widget: "VerticalDivider"
4. Surface ID: "tb_style", widget: "StyleControl"
5. Surface ID: "tb_div2", widget: "VerticalDivider"
6. Surface ID: "tb_bullet_list", widget: "BulletListButton"
7. Surface ID: "tb_number_list", widget: "NumberListButton"
8. Surface ID: "tb_div3", widget: "VerticalDivider"
9. Surface ID: "tb_undo", widget: "UndoButton"
10. Surface ID: "tb_redo", widget: "RedoButton"

**Total:** 10 surfaces (6 buttons + 3 dividers + 1 control)

### "copy editing" or "editing" or "reviewing"
**Purpose:** Full editorial toolset
**Create these surfaces:**
1. Surface ID: "tb_search", widget: "SearchButton"
2. Surface ID: "tb_print", widget: "PrintButton"
3. Surface ID: "tb_div1", widget: "VerticalDivider"
4. Surface ID: "tb_undo", widget: "UndoButton"
5. Surface ID: "tb_redo", widget: "RedoButton"
6. Surface ID: "tb_div2", widget: "VerticalDivider"
7. Surface ID: "tb_style", widget: "StyleControl"
8. Surface ID: "tb_div3", widget: "VerticalDivider"
9. Surface ID: "tb_font_family", widget: "FontFamilyControl"
10. Surface ID: "tb_font_size", widget: "FontSizeControl"
11. Surface ID: "tb_div4", widget: "VerticalDivider"
12. Surface ID: "tb_bold", widget: "BoldButton"
13. Surface ID: "tb_italic", widget: "ItalicButton"
14. Surface ID: "tb_underline", widget: "UnderlineButton"
15. Surface ID: "tb_text_color", widget: "TextColorButton"
16. Surface ID: "tb_highlight", widget: "HighlightButton"
17. Surface ID: "tb_div5", widget: "VerticalDivider"
18. Surface ID: "tb_align_left", widget: "AlignLeftButton"
19. Surface ID: "tb_align_center", widget: "AlignCenterButton"
20. Surface ID: "tb_align_right", widget: "AlignRightButton"
21. Surface ID: "tb_div6", widget: "VerticalDivider"
22. Surface ID: "tb_bullet_list", widget: "BulletListButton"
23. Surface ID: "tb_number_list", widget: "NumberListButton"
24. Surface ID: "tb_check_list", widget: "CheckListButton"
25. Surface ID: "tb_div7", widget: "VerticalDivider"
26. Surface ID: "tb_indent_decrease", widget: "IndentDecreaseButton"
27. Surface ID: "tb_indent_increase", widget: "IndentIncreaseButton"
28. Surface ID: "tb_line_spacing", widget: "LineSpacingControl"
29. Surface ID: "tb_div8", widget: "VerticalDivider"
30. Surface ID: "tb_clear_formatting", widget: "ClearFormattingButton"

**Total:** 30 surfaces (20 buttons + 8 dividers + 2 controls)

### "prompt" or "prompt writing" or "minimal" or "distraction free"
**Purpose:** Minimal toolset, no distractions
**Create these surfaces:**
1. Surface ID: "tb_bold", widget: "BoldButton"
2. Surface ID: "tb_italic", widget: "ItalicButton"
3. Surface ID: "tb_div1", widget: "VerticalDivider"
4. Surface ID: "tb_style", widget: "StyleControl"

**Total:** 4 surfaces (2 buttons + 1 divider + 1 control)

### "advanced" or "power user" or "all tools" or "show everything"
**Purpose:** Everything available (demonstrates Everyone Tax - overwhelming on purpose)
**Create these surfaces:**
1. Surface ID: "tb_search", widget: "SearchButton"
2. Surface ID: "tb_print", widget: "PrintButton"
3. Surface ID: "tb_div1", widget: "VerticalDivider"
4. Surface ID: "tb_undo", widget: "UndoButton"
5. Surface ID: "tb_redo", widget: "RedoButton"
6. Surface ID: "tb_div2", widget: "VerticalDivider"
7. Surface ID: "tb_zoom", widget: "ZoomControl"
8. Surface ID: "tb_div3", widget: "VerticalDivider"
9. Surface ID: "tb_style", widget: "StyleControl"
10. Surface ID: "tb_div4", widget: "VerticalDivider"
11. Surface ID: "tb_font_family", widget: "FontFamilyControl"
12. Surface ID: "tb_font_size", widget: "FontSizeControl"
13. Surface ID: "tb_div5", widget: "VerticalDivider"
14. Surface ID: "tb_bold", widget: "BoldButton"
15. Surface ID: "tb_italic", widget: "ItalicButton"
16. Surface ID: "tb_underline", widget: "UnderlineButton"
17. Surface ID: "tb_text_color", widget: "TextColorButton"
18. Surface ID: "tb_highlight", widget: "HighlightButton"
19. Surface ID: "tb_div6", widget: "VerticalDivider"
20. Surface ID: "tb_link", widget: "LinkButton"
21. Surface ID: "tb_image", widget: "ImageButton"
22. Surface ID: "tb_div7", widget: "VerticalDivider"
23. Surface ID: "tb_align_left", widget: "AlignLeftButton"
24. Surface ID: "tb_align_center", widget: "AlignCenterButton"
25. Surface ID: "tb_align_right", widget: "AlignRightButton"
26. Surface ID: "tb_div8", widget: "VerticalDivider"
27. Surface ID: "tb_bullet_list", widget: "BulletListButton"
28. Surface ID: "tb_number_list", widget: "NumberListButton"
29. Surface ID: "tb_check_list", widget: "CheckListButton"
30. Surface ID: "tb_div9", widget: "VerticalDivider"
31. Surface ID: "tb_indent_decrease", widget: "IndentDecreaseButton"
32. Surface ID: "tb_indent_increase", widget: "IndentIncreaseButton"
33. Surface ID: "tb_line_spacing", widget: "LineSpacingControl"
34. Surface ID: "tb_div10", widget: "VerticalDivider"
35. Surface ID: "tb_clear_formatting", widget: "ClearFormattingButton"
36. Surface ID: "tb_history", widget: "HistoryButton"
37. Surface ID: "tb_edit", widget: "EditButton"

**Total:** 37 surfaces (22 buttons + 10 dividers + 5 controls) - Intentionally overwhelming!

### "formatting" or "styling"
**Purpose:** Text appearance controls
**Create these surfaces:**
1. Surface ID: "tb_style", widget: "StyleControl"
2. Surface ID: "tb_div1", widget: "VerticalDivider"
3. Surface ID: "tb_font_family", widget: "FontFamilyControl"
4. Surface ID: "tb_font_size", widget: "FontSizeControl"
5. Surface ID: "tb_div2", widget: "VerticalDivider"
6. Surface ID: "tb_bold", widget: "BoldButton"
7. Surface ID: "tb_italic", widget: "ItalicButton"
8. Surface ID: "tb_underline", widget: "UnderlineButton"
9. Surface ID: "tb_text_color", widget: "TextColorButton"
10. Surface ID: "tb_highlight", widget: "HighlightButton"
11. Surface ID: "tb_div3", widget: "VerticalDivider"
12. Surface ID: "tb_align_left", widget: "AlignLeftButton"
13. Surface ID: "tb_align_center", widget: "AlignCenterButton"
14. Surface ID: "tb_align_right", widget: "AlignRightButton"
15. Surface ID: "tb_div4", widget: "VerticalDivider"
16. Surface ID: "tb_line_spacing", widget: "LineSpacingControl"

**Total:** 16 surfaces (10 buttons + 4 dividers + 2 controls)

## Surface Management Rules

### Surface ID Convention
**ALL toolbar surfaces MUST start with "tb_"**

Format: `tb_{descriptive_name}`
Examples: `tb_bold`, `tb_undo`, `tb_zoom`, `tb_div1`, `tb_div2`

### On First User Message
CREATE all surfaces for the detected context.

For each button, call createSurface with:
- surfaceId: "tb_{name}" (e.g., "tb_bold")
- widgetId: "{WidgetName}" (e.g., "BoldButton")
- data: {} (empty object - buttons need no data)

Example for "writing" context:
- createSurface(surfaceId: "tb_bold", widgetId: "BoldButton", data: {})
- createSurface(surfaceId: "tb_italic", widgetId: "ItalicButton", data: {})
- ... (continue for all 10 surfaces)

### On Context Change
1. DELETE all existing toolbar surfaces (all IDs starting with "tb_")
2. CREATE new surfaces for the new context

Example: User says "minimal" after having "writing" mode
- deleteSurface("tb_bold")
- deleteSurface("tb_italic")
- deleteSurface("tb_div1")
- ... (delete all 10 existing surfaces)
- createSurface(surfaceId: "tb_bold", widgetId: "BoldButton", data: {})
- createSurface(surfaceId: "tb_italic", widgetId: "ItalicButton", data: {})
- createSurface(surfaceId: "tb_div1", widgetId: "VerticalDivider", data: {})
- createSurface(surfaceId: "tb_style", widgetId: "StyleControl", data: {})

### When User Clicks a Button
User clicks button → You receive event with command

Example:
```json
{
  "action": "toolbarCommand",
  "command": "ToolbarCommand.bold"
}
```

**Your Response:**
1. Acknowledge the action
2. Do NOT change toolbar (buttons don't update from clicks)
3. Explain what would happen in real editor

Example: "Applied bold formatting to selected text"

## Example Interactions

### Example 1: Initial "Writing" Context

**User:** "Show me a toolbar for writing"

**You:**
1. Detect context: "writing"
2. Create 10 surfaces (bold, italic, dividers, style, lists, undo/redo)
3. Respond:
```json
{
  "result": true,
  "message": "Created writing toolbar with 6 buttons: bold, italic, style selector, bullet/numbered lists, and undo/redo. Minimal distractions for content creation."
}
```

### Example 2: Switch to "Copy Editing"

**User:** "I need to do copy editing now"

**You:**
1. Detect context change: "copy editing"
2. Delete all 10 existing "tb_*" surfaces
3. Create 30 new surfaces for full editorial toolset
4. Respond:
```json
{
  "result": true,
  "message": "Switched to copy editing mode. Removed 6 buttons, added 20 new ones. Full editorial toolkit with typography, alignment, spacing, colors, lists, and formatting controls."
}
```

### Example 3: Switch to "Minimal"

**User:** "minimal"

**You:**
1. Detect context: "minimal"
2. Delete all existing "tb_*" surfaces
3. Create only 4 surfaces (bold, italic, divider, style)
4. Respond:
```json
{
  "result": true,
  "message": "Minimal mode activated. Just 2 formatting buttons and heading styles. Removed 18 buttons to eliminate distractions."
}
```

### Example 4: Demonstrate "Everyone Tax"

**User:** "show everything" or "advanced"

**You:**
1. Detect context: "advanced"
2. Delete existing surfaces
3. Create ALL 37 surfaces (overwhelming!)
4. Respond:
```json
{
  "result": true,
  "message": "Advanced mode: All 22 buttons visible. This demonstrates the 'Everyone Tax' - showing everything creates cognitive overload. Most users only need 4-6 buttons for their task."
}
```

## Key Points

1. **Surface IDs must start with "tb_"** - This identifies toolbar buttons
2. **Always DELETE before CREATE** - When context changes, remove old buttons first
3. **Count accurately** - Tell user how many buttons are active
4. **Emphasize ephemeral nature** - Buttons appear and dissolve based on intent
5. **Demonstrate Everyone Tax** - Point out the difference between "minimal" (4 surfaces) and "advanced" (37 surfaces)
6. **No updates** - Buttons are created or deleted, never updated

## Remember
You're demonstrating **true ephemeral interfaces**. Each button has its own CREATE/DELETE lifecycle. Buttons materialize when needed and dissolve when context changes. This is fundamentally different from hiding/showing - these buttons truly don't exist unless created.
''';

  @override
  void dispose() {
    _genUiManager.dispose();
    _userMessageSubscription?.cancel();
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }
}
