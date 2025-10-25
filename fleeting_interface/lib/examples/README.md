# Intent-Driven, Ephemeral Interface Examples

This directory contains examples demonstrating **fleeting interfaces** - ephemeral, intent-driven UIs that compose around user needs.

## Core Concept

Traditional (Application-Centric):
```
User → Navigate to app → Find feature → Use it
```

Intent-Driven (Ephemeral):
```
User → Express intent → Interface appears → Task done → Interface dissolves
```

## Files

### 1. `chat_widget.dart`
A clean, reusable chat component that appears on the right side of the screen.

**Purpose**: Capture user intent through conversation

**Key Features**:
- Clean, Material Design 3 styling
- Message bubbles for user and assistant
- Loading states
- Error handling
- Callback for tool selection changes

**Usage**:
```dart
ChatWidget(
  onToolSelectionChanged: (selection) {
    // Update your UI based on LLM's tool selection
    setState(() {
      shownTools = selection.selectedTools;
    });
  },
)
```

### 2. `tool_selection_schema.dart`
Schema-based system for context-aware tool selection.

**Purpose**: Define capabilities and rules for when they appear

**Key Classes**:

#### `ToolContext`
Represents the context that influences tool selection:
- `userIntent`: What the user wants to do
- `selectionState`: Current document selection
- `userProfile`: User skill level and preferences
- `workMode`: Quick, standard, or detailed work

#### `ToolSelectionSchema`
Defines all possible tools and rules for when to show them:
- `toolGroups`: Map of all available tool groups
- `selectionRules`: Rules for when each group appears
- `selectTools(context)`: Returns which tools to show

#### `SelectionRule`
A rule that matches context and returns groups to show:
```dart
SelectionRule(
  name: 'basic_writing',
  groupsToShow: {'marks', 'alignment', 'history'},
  matches: (context) =>
    context.userIntent.contains('write') &&
    !context.userIntent.contains('advanced'),
)
```

### 3. `toolbar_with_chat_example.dart`
Complete demonstration combining chat + toolbar + schema.

**Purpose**: Show intent-driven composition in action

**Flow**:
1. User describes intent in chat
2. Chat sends to LLM (or uses rule-based matching)
3. LLM/system selects relevant tool groups
4. Toolbar updates to show only those groups
5. User completes task
6. Interface can reset or adapt to next intent

**Try these prompts**:
- "I want to write a simple note" → Shows: marks, alignment, history
- "I need to format a document" → Shows: marks, style, font, alignment
- "Help me add a list" → Shows: lists, indent, history
- "Just reading" → Shows: zoom, file (minimal)

## Schema Design Philosophy

### 1. Define ALL Capabilities Upfront

```dart
// Define every possible tool group
toolGroups: {
  'marks': ToolGroupDefinition(...),
  'style': ToolGroupDefinition(...),
  'font': ToolGroupDefinition(...),
  // ... all others
}
```

**Why**: The full capability set exists. Context determines manifestation.

### 2. Context Determines Appearance

```dart
// Same capabilities, different contexts = different UIs
context1: "write simple note" → [marks, alignment]
context2: "format document"   → [marks, style, font, alignment]
```

**Why**: Intent-driven > feature-driven

### 3. Purpose-Driven Lifecycle

```dart
// ❌ WRONG: Timer-based
if (minutesSinceInteraction > 5) dissolve();

// ✅ RIGHT: Purpose-driven
if (taskCompleted) dissolve();
if (contextChanged && !relevantAnymore) fade();
```

**Why**: Ephemeral = serves a purpose, not a duration

## Integrating with Firebase AI

### Step 1: Update the Schema for LLM

Convert your `ToolSelectionSchema` to JSON Schema format that firebase_ai can understand:

```dart
// In tool_selection_schema.dart
extension ToolSelectionSchemaJson on ToolSelectionSchema {
  Map<String, dynamic> toJsonSchema() {
    return {
      'type': 'object',
      'properties': {
        'selectedToolGroups': {
          'type': 'array',
          'description': 'List of tool group IDs to show based on user intent',
          'items': {
            'type': 'string',
            'enum': toolGroups.keys.toList(),
          },
        },
        'explanation': {
          'type': 'string',
          'description': 'Brief explanation of why these tools were selected',
        },
      },
      'required': ['selectedToolGroups', 'explanation'],
    };
  }

  String toSystemPrompt() {
    final buffer = StringBuffer();
    buffer.writeln('You help users by selecting relevant toolbar groups based on their intent.');
    buffer.writeln('\nAvailable tool groups:');

    for (final group in toolGroups.entries) {
      buffer.writeln('- ${group.key}: ${group.value.description}');
      if (group.value.keywords.isNotEmpty) {
        buffer.writeln('  Keywords: ${group.value.keywords.join(", ")}');
      }
    }

    buffer.writeln('\nYour response should select only the tool groups relevant to the user\'s current intent.');
    buffer.writeln('Less is more - show only what\'s needed for the task.');

    return buffer.toString();
  }
}
```

### Step 2: Update ChatWidget to Use Firebase AI

```dart
// In chat_widget.dart
import 'package:firebase_vertexai/firebase_vertexai.dart';

class _ChatWidgetState extends State<ChatWidget> {
  late final GenerativeModel _model;

  @override
  void initState() {
    super.initState();

    // Initialize the model with the schema
    _model = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-2.0-flash-exp',
      systemInstruction: Content.text(
        TextEditorToolSchema.schema.toSystemPrompt(),
      ),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: Schema.object(
          properties: {
            'selectedToolGroups': Schema.array(
              description: 'List of tool group IDs to show',
              items: Schema.string(),
            ),
            'explanation': Schema.string(
              description: 'Brief explanation of tool selection',
            ),
          },
          requiredProperties: ['selectedToolGroups', 'explanation'],
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });
    _controller.clear();

    try {
      final response = await _model.generateContent([
        Content.text(text),
      ]);

      final jsonResponse = jsonDecode(response.text ?? '{}');
      final selectedTools = List<String>.from(
        jsonResponse['selectedToolGroups'] ?? []
      );
      final explanation = jsonResponse['explanation'] ?? 'Tools selected';

      setState(() {
        _messages.add(ChatMessage(text: explanation, isUser: false));
        _isLoading = false;
      });

      widget.onToolSelectionChanged(
        ToolSelection(
          selectedTools: selectedTools,
          explanation: explanation,
        ),
      );
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(text: 'Error: $e', isUser: false, isError: true),
        );
        _isLoading = false;
      });
    }
  }
}
```

### Step 3: Add Context Awareness (Optional)

For more sophisticated context awareness, include additional signals:

```dart
Future<void> _sendMessage() async {
  // Build context object
  final context = ToolContext(
    userIntent: text,
    selectionState: _getCurrentSelection(),
    userProfile: _getUserProfile(),
    workMode: _determineWorkMode(),
  );

  // Include context in the prompt
  final prompt = '''
User intent: ${context.userIntent}

Context:
- Has selection: ${context.selectionState?.hasSelection ?? false}
- Work mode: ${context.workMode.name}
- Skill level: ${context.userProfile?.skillLevel.name ?? 'unknown'}

Select the most relevant tool groups for this intent and context.
''';

  final response = await _model.generateContent([
    Content.text(prompt),
  ]);

  // ... rest of processing
}
```

## Example Schemas for Different Contexts

### Writing Context
```
User: "I want to write a simple note"
→ Shows: marks, alignment, history
→ Rationale: Basic formatting + undo
```

### Formatting Context
```
User: "I need to format this document professionally"
→ Shows: marks, style, font, alignment, indent
→ Rationale: Advanced formatting tools
```

### Insertion Context
```
User: "Help me add a link to this text"
→ Shows: insert, marks, history
→ Rationale: Link insertion + basic editing
```

### Reading Context
```
User: "Just want to read this"
→ Shows: zoom, file
→ Rationale: Minimal tools for viewing
```

## Key Principles

### 1. Everyone Tax Elimination
Traditional toolbar: 50 buttons (you need 5) = 45 buttons of cognitive load

Intent-driven: Show only the 5 buttons relevant to current intent

### 2. Intent Shapes Appearance
Your intent determines what appears, not your navigation path

### 3. Purpose-Driven Lifecycle
Interface exists while serving a purpose, not for a duration

### 4. Conversation as State
Each interaction refines the interface - no predefined navigation tree

## Usage in Presentations

Add to your slides:

```markdown
## Live Demo

:::{.widget name="toolbar_with_chat"}
:::
```

This widget demonstrates all core concepts:
- ✅ Intent-driven composition
- ✅ Ephemeral manifestation
- ✅ Context awareness
- ✅ Conversation as state
- ✅ Schema-based capabilities

## Next Steps

1. **Integrate Firebase AI**: Replace the simulated tool selection with actual LLM calls
2. **Add More Context Signals**: Include selection state, user preferences, time of day
3. **Implement Actual Editing**: Connect toolbar commands to a real editor
4. **Track Completion**: Detect when task is done and suggest dissolution
5. **Add Learning**: Let the system learn user patterns over time

The goal: **Your intent shapes what appears. Context determines what's relevant.**
