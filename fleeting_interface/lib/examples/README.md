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

### 2. `tool_definitions.dart`
Simple tool definitions for intent-driven selection.

**Purpose**: Define what each tool does. The LLM reads these and decides what to show based on user intent.

**Key Classes**:

#### `ToolGroupDefinition`
Simple definition of a tool group:
- `id`: Unique identifier (e.g., 'marks', 'style', 'font')
- `label`: Human-readable name
- `description`: What this tool group does

#### `ToolbarDefinitions`
Container for all available tools:
- `allGroups`: List of all 11 tool group definitions
- `generateSystemPrompt()`: Creates LLM prompt from definitions
- `toJsonSchema()`: JSON schema for structured LLM output

**Example**:
```dart
ToolGroupDefinition(
  id: 'marks',
  label: 'Text Formatting',
  description: 'Bold, italic, underline, text color, and highlighting',
)
```

The LLM reads these definitions and decides what to show based on user intent. No complex rules needed!

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

## Design Philosophy

### 1. Define ALL Capabilities Upfront

```dart
// Define every possible tool group - simple descriptions
const allGroups = [
  ToolGroupDefinition(
    id: 'marks',
    label: 'Text Formatting',
    description: 'Bold, italic, underline, text color, and highlighting',
  ),
  // ... all 11 groups
];
```

**Why**: The full capability set exists. Intent determines what appears.

### 2. Let the LLM Decide

```dart
// User intent → LLM reads definitions → Selects relevant tools
"write simple note" → LLM chooses: [marks, alignment, history]
"format document"   → LLM chooses: [marks, style, font, alignment]
"just reading"      → LLM chooses: [zoom, file]
```

**Why**: LLM understands intent better than hard-coded rules

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

### Step 1: Use the Built-in System Prompt

The `ToolbarDefinitions` class already generates everything you need:

```dart
// System prompt with all tool descriptions
final systemPrompt = ToolbarDefinitions.generateSystemPrompt();

// JSON schema for structured output
final jsonSchema = ToolbarDefinitions.toJsonSchema();
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

    // Initialize the model with the tool definitions
    _model = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-2.0-flash-exp',
      systemInstruction: Content.text(
        ToolbarDefinitions.generateSystemPrompt(),
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

### Step 3: Add Context (Optional)

You can include additional context in the user message:

```dart
Future<void> _sendMessage() async {
  // Simple approach - just the user's intent
  final prompt = text;

  // Or with additional context
  final promptWithContext = '''
Intent: $text

Current state:
- Has text selected: ${hasSelection ? 'yes' : 'no'}
- Document type: ${documentType}
''';

  final response = await _model.generateContent([
    Content.text(promptWithContext),
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
