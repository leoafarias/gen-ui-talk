# Fleeting Interface Example Generation Guide

## Purpose
This guide enables systematic generation of new Fleeting Interface examples. Follow each step sequentially. Each section includes required questions, decisions, and validation.

---

## Phase 1: Discovery & Requirements

### Step 1.1: Understand the Domain
**Ask the user these questions:**

1. **What is the example about?** (e.g., "weather app", "task manager", "music player")
2. **What is the primary user goal?** (e.g., "check forecast", "organize tasks", "find songs")
3. **Is this a single-purpose or multi-purpose example?**
   - Single: One main flow (like simple_chat)
   - Multi: Multiple related flows (like travel_planner)

**Record answers before proceeding.**

### Step 1.2: Map User Interactions
**Ask the user:**

4. **What are the 3-5 main things users do?** (e.g., search, view details, configure, submit)
5. **Do users browse/explore data, or accomplish specific tasks, or both?**
6. **What information do users input?** (text, selections, numbers, dates, etc.)

**Create a flow diagram mentally:**
```
User Intent → AI Action → Surface Shown → User Interaction → Next Intent
```

### Step 1.3: Define Complexity Level
**Ask the user:**

7. **Complexity preference:**
   - **Minimal**: 1-2 widget types, simple conversation (reference: simple_chat)
   - **Moderate**: 3-4 widget types, structured flow (reference: travel_planner)
   - **Complex**: 5+ widget types, advanced patterns

8. **Does this need custom backend tools?** (e.g., API calls, data fetching)
   - Yes → Will create Tool classes
   - No → Widget catalog only

**Validation checkpoint:** You should now have clear answers to questions 1-8.

---

## Phase 2: Architecture Design

### Step 2.1: Design Widget Catalog
**For each user interaction from Step 1.2, decide which widget type:**

Use this decision tree:

```
Does user need to BROWSE multiple options?
├─ Yes → TravelCarousel (image-based) or ListWidget (text-based)
└─ No
   ├─ Does user need to VIEW details/information?
   │  └─ Yes → InformationCard or DetailPanel
   └─ No
      ├─ Does user need to INPUT data?
      │  └─ Yes → InputGroup or FormWidget
      └─ No
         └─ Does user take ACTION?
            └─ Yes → ActionButton or ConfirmationWidget
```

**Widget Selection Rules:**

| User Action | Widget Type | When to Use |
|-------------|-------------|-------------|
| Browse with images | `TravelCarousel` | Visual content (products, places, media) |
| Browse text items | `ListWidget` | Non-visual content (tasks, messages, settings) |
| See rich details | `InformationCard` | 3-5 key facts with optional image |
| See structured info | `DetailPanel` | 5+ fields, hierarchical data |
| Input 1-3 fields | `InputGroup` | Quick capture (search, filter) |
| Input 4+ fields | `FormWidget` | Complete forms (registration, booking) |
| Single action | `ActionButton` | One clear action (submit, delete, confirm) |
| Multiple choices | `ButtonGroup` | 2-5 related actions |
| Progress view | `ItineraryWidget` | Step-by-step process, timeline |
| Confirmation | `ConfirmationCard` | Verify before action |

**Output: List of 3-7 widgets needed for your example.**

Example:
```
Weather App Widgets:
- LocationInput (InputGroup) - User enters city
- ForecastCarousel (TravelCarousel) - Browse days
- WeatherDetail (InformationCard) - See daily details
- AlertCard (InformationCard) - Show weather warnings
```

### Step 2.2: Design Data Model
**For each widget that handles data:**

Ask yourself:
- What data does this widget display?
- What data does this widget collect from user?
- How is data passed between widgets?

**Create data model schema:**

```dart
// Example: Weather App
class WeatherData {
  final String location;
  final List<DayForecast> forecast;
  final List<WeatherAlert> alerts;
}

class DayForecast {
  final String date;
  final int temperature;
  final String condition;
  final String icon;
}
```

**Validation:** Each widget should map to a data structure.

### Step 2.3: Design Custom Tools (if needed)
**From Step 1.3, question 8:**

If user needs backend capabilities:

**For each capability, define:**
```dart
// Tool template
class [Capability]Tool extends Tool {
  // 1. Name (what AI calls it)
  String get name => '[action]_[noun]';

  // 2. Description (when to use it)
  String get description => 'Call this to [specific action]';

  // 3. Parameters (what AI provides)
  Schema get parameters => S.object(properties: {
    'param1': S.string(description: '...'),
  });

  // 4. Logic (what it does)
  FutureOr<String> call(Map<String, dynamic> args) async {
    // Implementation
    return json.encode(result);
  }
}
```

**Example: Weather App Tool**
```dart
class FetchForecastTool extends Tool {
  String get name => 'fetch_forecast';
  String get description => 'Fetch weather forecast for location';

  Schema get parameters => S.object(properties: {
    'location': S.string(description: 'City name'),
    'days': S.integer(description: 'Number of days (1-7)'),
  });

  FutureOr<String> call(Map<String, dynamic> args) async {
    final location = args['location'] as String;
    final days = args['days'] as int;
    final forecast = await _weatherService.getForecast(location, days);
    return json.encode(forecast);
  }
}
```

**Validation:** Each tool should have clear trigger conditions and return structured data.

### Step 2.4: Design System Prompt
**This is critical. The AI's behavior is defined here.**

**System Prompt Structure:**

```markdown
# [Example Name] Assistant

## Role
You are a [domain] assistant helping users [primary goal].

## Available Widgets
[For each widget, describe when/how to use it]

### [WidgetName]
**When to use:** [Specific trigger]
**What it shows:** [Content description]
**User can:** [Interaction options]
**After interaction:** [What happens next]

## Available Tools
[For each custom tool]

### [ToolName]
**When to call:** [Specific condition]
**Parameters:** [What to provide]
**Returns:** [What you get back]
**Next step:** [What to do with result]

## Conversation Flow
[Step-by-step user journey]

1. User [action] → You [response + widget]
2. User [interaction] → You [next step]
...

## Surface Management Rules
- **Create new surface when:** [Condition]
- **Update existing surface when:** [Condition]
- **Delete surface when:** [Condition]

## Data Management
[How to handle state, inputs, persistence]

## Examples
[2-3 example interactions showing complete flow]
```

**Validation:** Prompt should cover every widget, every tool, and primary flow.

---

## Phase 3: Implementation

### Step 3.1: Create Directory Structure

```
lib/examples/[example_name]/
├── main.dart                    # Entry point
├── [example_name]_page.dart     # Main page (conversation UI)
├── src/
│   ├── catalog/
│   │   └── [example_name]_catalog.dart    # Widget definitions
│   ├── widgets/
│   │   ├── [widget1]_widget.dart
│   │   ├── [widget2]_widget.dart
│   │   └── ...
│   ├── tools/                   # If custom tools needed
│   │   └── [tool_name]_tool.dart
│   ├── models/                  # Data models
│   │   └── [model_name].dart
│   └── data/                    # Mock data (optional)
│       └── [example_name]_data.dart
```

### Step 3.2: Implement Widget Catalog

**File:** `src/catalog/[example_name]_catalog.dart`

**Template:**
```dart
import 'package:gen_ui/gen_ui.dart';
import '../widgets/[widget1]_widget.dart';
import '../widgets/[widget2]_widget.dart';

final [exampleName]Catalog = Catalog(
  widgets: {
    // For each widget from Step 2.1
    '[widgetId]': WidgetDefinition(
      builder: (data) => [WidgetClass](data),
      schema: S.object(
        description: '[What this widget does]',
        properties: {
          // Define all properties the widget needs
          '[prop1]': S.string(description: '[What this is]'),
          '[prop2]': S.array(
            description: '[What this is]',
            items: S.object(properties: {
              // Nested structure if needed
            }),
          ),
        },
        required: ['[required_prop1]', '[required_prop2]'],
      ),
      supportedActions: const [
        // What user can do with this widget
        WidgetActionType.onClick,
        WidgetActionType.onSubmit,
      ],
    ),
  },
);
```

**Validation checklist for each widget:**
- [ ] Builder function creates widget from data
- [ ] Schema matches widget's data structure
- [ ] All required fields marked as required
- [ ] Supported actions match widget capabilities
- [ ] Description clearly explains widget purpose

### Step 3.3: Implement Widget Classes

**File:** `src/widgets/[widget_name]_widget.dart`

**Standard Widget Template:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_ui/gen_ui.dart';

class [WidgetName]Widget extends ConsumerWidget {
  const [WidgetName]Widget(this.data, {super.key});

  final WidgetData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Extract data from WidgetData
    final title = data.getValue<String>('title') ?? '';
    final items = data.getValue<List<dynamic>>('items') ?? [];

    // 2. Build UI
    return Card(
      child: Column(
        children: [
          // Your UI here

          // 3. Handle user interactions
          if (data.actions.contains(WidgetActionType.onSubmit))
            ElevatedButton(
              onPressed: () {
                // Submit user interaction
                data.submitValue({
                  'action': 'button_clicked',
                  'value': 'some_value',
                });
              },
              child: Text('Action'),
            ),
        ],
      ),
    );
  }
}
```

**Key patterns:**

1. **Extract data safely:**
```dart
// Simple value
final name = data.getValue<String>('name') ?? '';

// List
final items = data.getValue<List<dynamic>>('items') ?? [];
final typedItems = items.map((item) =>
  ItemModel.fromJson(item as Map<String, dynamic>)
).toList();

// Nested object
final address = data.getValue<Map<String, dynamic>>('address');
final street = address?['street'] as String? ?? '';
```

2. **Handle interactions:**
```dart
// Button click
data.submitValue({'action': 'clicked', 'itemId': item.id});

// Form submission
data.submitValue({'field1': value1, 'field2': value2});

// Selection
data.submitValue({'selected': selectedItem.id});
```

3. **Use WidgetData path for form inputs:**
```dart
TextField(
  controller: TextEditingController(
    text: data.getValue<String>('inputField'),
  ),
  onChanged: (value) {
    // Update via data path
    data.updateValue('inputField', value);
  },
)
```

**Validation checklist for each widget:**
- [ ] Extracts all schema properties from `data`
- [ ] Handles null/missing data gracefully
- [ ] Submits data in correct format
- [ ] UI matches widget purpose
- [ ] Responsive design (works on different sizes)

### Step 3.4: Implement Custom Tools (if needed)

**File:** `src/tools/[tool_name]_tool.dart`

**Template:**
```dart
import 'dart:async';
import 'dart:convert';
import 'package:gen_ui/gen_ui.dart';

class [ToolName]Tool extends Tool {
  [ToolName]Tool({
    // Dependencies (services, repositories, etc.)
  });

  @override
  String get name => '[action]_[noun]';

  @override
  String get description => '''
Call this tool to [specific purpose].
Use this when user [specific trigger condition].
Returns [what it returns].
''';

  @override
  Schema get parameters => S.object(
    properties: {
      '[param1]': S.string(
        description: '[What this parameter is]',
      ),
      '[param2]': S.integer(
        description: '[What this parameter is]',
      ),
    },
    required: ['[param1]'],
  );

  @override
  FutureOr<String> call(Map<String, dynamic> args) async {
    try {
      // 1. Extract parameters
      final param1 = args['param1'] as String;
      final param2 = args['param2'] as int?;

      // 2. Perform action (API call, data fetch, etc.)
      final result = await _doWork(param1, param2);

      // 3. Return structured JSON
      return json.encode({
        'success': true,
        'data': result,
      });
    } catch (e) {
      // 4. Handle errors gracefully
      return json.encode({
        'success': false,
        'error': e.toString(),
      });
    }
  }

  Future<dynamic> _doWork(String param1, int? param2) async {
    // Implementation here
    // For examples, can return mock data
  }
}
```

**Validation checklist:**
- [ ] Clear, specific name (verb_noun pattern)
- [ ] Description explains when to use it
- [ ] Parameters match expected inputs
- [ ] Returns valid JSON
- [ ] Handles errors without crashing
- [ ] Includes mock data for demo

### Step 3.5: Implement Main Page

**File:** `[example_name]_page.dart`

**Use this exact structure (based on travel_example):**

```dart
import 'package:flutter/material.dart';
import 'package:gen_ui/gen_ui.dart';
import 'package:gen_ui/widgets/conversation.dart';
import 'src/catalog/[example_name]_catalog.dart';
import 'src/tools/[tool_name]_tool.dart'; // If custom tools

class [ExampleName]Page extends StatefulWidget {
  const [ExampleName]Page({super.key});

  @override
  State<[ExampleName]Page> createState() => _[ExampleName]PageState();
}

class _[ExampleName]PageState extends State<[ExampleName]Page> {
  // ===== STEP 1: Declare core components =====
  late final GenUiManager _genUiManager;
  late final AiClient _aiClient;
  final List<ChatMessage> _conversation = [];
  final ScrollController _scrollController = ScrollController();

  // Subscriptions
  StreamSubscription<UserMessage>? _userMessageSubscription;
  StreamSubscription<SurfaceUpdate>? _surfaceUpdateSubscription;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeGenUi();
  }

  // ===== STEP 2: Initialize GenUiManager =====
  void _initializeGenUi() {
    _genUiManager = GenUiManager(
      catalog: [exampleName]Catalog,
      configuration: const GenUiConfiguration(
        actions: ActionsConfig(
          allowCreate: true,
          allowUpdate: true,
          allowDelete: true, // Set based on needs
        ),
      ),
    );

    // ===== STEP 3: Subscribe to UI interactions =====
    _userMessageSubscription = _genUiManager.onSubmit.listen(
      _handleUserMessageFromUi,
    );

    // ===== STEP 4: Initialize AI client =====
    final tools = _genUiManager.getTools();
    // Add custom tools if needed
    // tools.add([ToolName]Tool());

    _aiClient = FirebaseAiClient(
      tools: tools,
      systemInstruction: _systemPrompt,
    );

    // ===== STEP 5: Subscribe to surface updates =====
    _surfaceUpdateSubscription = _genUiManager.surfaceUpdates.listen(
      (update) {
        setState(() {
          switch (update) {
            case SurfaceAdded():
              _conversation.add(AiUiMessage(
                surface: update.surface,
              ));
            case SurfaceRemoved():
              _conversation.removeWhere(
                (msg) => msg is AiUiMessage && msg.surface.id == update.surfaceId,
              );
            case SurfaceUpdated():
              final index = _conversation.indexWhere(
                (msg) => msg is AiUiMessage && msg.surface.id == update.surface.id,
              );
              if (index != -1) {
                _conversation[index] = AiUiMessage(surface: update.surface);
              }
          }
        });
        _autoScroll();
      },
    );
  }

  // ===== STEP 6: Handle user text input =====
  void _sendPrompt(String text) {
    setState(() {
      _conversation.add(UserMessage.text(text));
    });
    _triggerInference();
  }

  // ===== STEP 7: Handle user UI interactions =====
  void _handleUserMessageFromUi(UserMessage message) {
    setState(() {
      _conversation.add(message);
    });
    _triggerInference();
  }

  // ===== STEP 8: Trigger AI inference =====
  Future<void> _triggerInference() async {
    setState(() => _isLoading = true);

    try {
      final response = await _aiClient.generateContent(
        _conversation,
        // Output schema (optional)
        responseSchema: S.object(
          properties: {
            'result': S.boolean(
              description: 'Whether the user request was completed',
            ),
            'message': S.string(
              description: 'Optional message to user',
              nullable: true,
            ),
          },
        ),
      );

      // Handle text response if any
      final message = response.data?['message'] as String?;
      if (message != null && message.isNotEmpty) {
        setState(() {
          _conversation.add(AiTextMessage(text: message));
        });
      }
    } catch (e) {
      setState(() {
        _conversation.add(
          AiTextMessage(text: 'Error: ${e.toString()}'),
        );
      });
    } finally {
      setState(() => _isLoading = false);
      _autoScroll();
    }
  }

  // ===== STEP 9: Auto-scroll helper =====
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

  // ===== STEP 10: Build UI =====
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('[Example Name]'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Conversation(
              messages: _conversation,
              scrollController: _scrollController,
            ),
          ),
          if (_isLoading)
            const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _sendPrompt,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== STEP 11: System prompt =====
  static const String _systemPrompt = '''
[Paste your system prompt from Step 2.4 here]
''';

  @override
  void dispose() {
    _userMessageSubscription?.cancel();
    _surfaceUpdateSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }
}
```

**This structure is FIXED. Always use it exactly as shown.**

**Validation checklist:**
- [ ] GenUiManager initialized with correct catalog
- [ ] Both subscriptions set up (onSubmit, surfaceUpdates)
- [ ] AI client has all tools (GenUI + custom)
- [ ] System prompt included
- [ ] Auto-scroll implemented
- [ ] Loading state shown
- [ ] Dispose called properly

### Step 3.6: Create Entry Point

**File:** `main.dart`

```dart
import 'package:flutter/material.dart';
import '[example_name]_page.dart';

void main() {
  runApp(const [ExampleName]App());
}

class [ExampleName]App extends StatelessWidget {
  const [ExampleName]App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '[Example Name]',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const [ExampleName]Page(),
    );
  }
}
```

### Step 3.7: Create Mock Data (if needed)

**File:** `src/data/[example_name]_data.dart`

```dart
// Example: Weather mock data
class MockWeatherData {
  static final List<Map<String, dynamic>> forecasts = [
    {
      'date': '2024-01-15',
      'temperature': 72,
      'condition': 'Sunny',
      'icon': '☀️',
    },
    // ... more data
  ];

  static Map<String, dynamic> getForecast(String location, int days) {
    return {
      'location': location,
      'forecast': forecasts.take(days).toList(),
    };
  }
}
```

---

## Phase 4: System Prompt Creation (Critical)

### Step 4.1: Write System Prompt

**Use this exact template:**

```markdown
# [Example Name] Assistant

## Your Role
You are a [domain] assistant helping users [primary goal from Step 1.1].
Your job is to create and manage UI surfaces that help users [accomplish what].

## Core Principles
1. **Intent-driven**: User expresses what they want, you show relevant UI
2. **Ephemeral**: Create surfaces when needed, remove when done
3. **Conversational**: Guide users through [domain] naturally

## Available Widgets

### [Widget1Name] (widgetId: '[widget1_id]')
**Purpose:** [What this widget is for]
**When to use:** [Specific trigger condition]
**What to show:** [What data to populate]

**Properties:**
- `[prop1]` (string, required): [Description]
- `[prop2]` (array, optional): [Description]

**User interaction:**
After user [interaction], they will submit: `{ "[field]": "[value]" }`

**Next step:** When user interacts, [what you do next]

**Example usage:**
```json
{
  "widgetId": "[widget1_id]",
  "data": {
    "prop1": "value",
    "prop2": [...]
  }
}
```

[Repeat for each widget]

## Available Tools

### [Tool1Name]
**When to call:** [Trigger condition]
**Parameters:**
- `[param1]`: [Description]

**Returns:** [What you get back]
**What to do with result:** [Next action]

[Repeat for each tool]

## Conversation Flow

### Initial Greeting
When user first arrives:
1. Greet them warmly
2. Explain what you can help with
3. Create [InitialWidget] showing [initial options]

### Primary Flow: [Main Task]
1. **User says:** "[example user input]"
2. **You do:**
   - Call `[tool_name]` with `[params]`
   - Create `[widget_name]` with results
   - Surface ID: Use descriptive name like "[domain]_[purpose]"

3. **User interacts:** Clicks item in widget
4. **You receive:** `{ "selectedId": "123" }`
5. **You do:**
   - Update `[widget_name]` OR create new `[detail_widget]`
   - Show next step

### Secondary Flow: [Other Task]
[Similar structure]

## Surface Management Strategy

**When to CREATE new surface:**
- User starts new task/question
- Showing different type of information
- Parallel information (e.g., comparison)

**When to UPDATE existing surface:**
- Refining same information (filtering, sorting)
- Adding detail to existing view
- User corrects/changes input

**When to DELETE surface:**
- Task completed successfully
- User explicitly requests removal
- Information no longer relevant

**Surface ID naming:**
- Format: `[domain]_[purpose]_[optional_specifier]`
- Examples: `weather_forecast_weekly`, `task_list_active`
- Keep consistent for updates

## Data Management

### Using Widget Data Paths for Inputs
When widget has input fields, use data paths:

```json
{
  "widgetId": "input_form",
  "data": {
    "fields": [
      {
        "id": "location",
        "label": "Location",
        "value": "" // AI can pre-fill if known
      }
    ]
  }
}
```

User can type in field, value stored at path: `fields[0].value`

### Remembering Context
Track these in conversation:
- User preferences mentioned
- Previous selections
- Current task state

## Example Interactions

### Example 1: [Typical Flow]
```
User: "[example input]"

AI: "[Friendly response]"
[Creates [widget_name] showing [what]]

User: [Interacts with widget]
Submits: { "[field]": "[value]" }

AI: "[Confirmation]"
[Updates widget OR creates next widget]
```

### Example 2: [Alternative Flow]
[Another complete example]

## Error Handling

If user request is unclear:
- Ask clarifying question
- Suggest options using widget

If tool call fails:
- Explain what went wrong simply
- Offer alternative or ask user to retry

If no relevant widget exists:
- Respond conversationally
- Explain what you can help with
- Show available options

## Response Format

Always respond with:
```json
{
  "result": true/false,
  "message": "Optional message to user"
}
```

Set `result: true` when task completed.
Set `result: false` when waiting for more input.

## Remember
- You are helpful and conversational
- Create UI to support conversation, not replace it
- Keep surfaces focused and simple
- Remove surfaces when done with them
- Guide user naturally through [domain]
```

**Validation checklist:**
- [ ] Every widget documented with example
- [ ] Every tool documented with trigger condition
- [ ] Main flow(s) shown step-by-step
- [ ] Surface management rules clear
- [ ] Example interactions complete (input → output)
- [ ] Error handling covered

---

## Phase 5: Validation & Testing

### Step 5.1: Code Validation Checklist

**Before running the example:**

**Catalog:**
- [ ] All widgets registered in catalog
- [ ] Schema properties match widget expectations
- [ ] Required fields marked correctly
- [ ] Supported actions match widget capabilities

**Widgets:**
- [ ] All widgets import necessary packages
- [ ] Data extraction uses safe null handling
- [ ] User interactions submit data correctly
- [ ] UI is reasonably styled

**Tools (if any):**
- [ ] Tool names follow verb_noun pattern
- [ ] Parameters schema is complete
- [ ] Returns valid JSON
- [ ] Errors handled gracefully

**Main Page:**
- [ ] Follows exact structure from Step 3.5
- [ ] Catalog imported correctly
- [ ] Tools added to AI client
- [ ] System prompt is complete
- [ ] Subscriptions set up properly

**Entry Point:**
- [ ] main.dart runs the page
- [ ] MaterialApp configured
- [ ] No import errors

### Step 5.2: Run the Example

```bash
# Navigate to example
cd lib/examples/[example_name]

# Run
flutter run -t main.dart
```

**Expected behavior:**
1. App launches without errors
2. Conversation UI appears
3. Can type message and submit

### Step 5.3: Test Conversation Flow

**Test Case 1: Initial Greeting**
```
Input: [First message that matches primary flow]
Expected:
- AI responds
- Appropriate widget appears
- Widget shows sensible data
```

**Test Case 2: Widget Interaction**
```
Input: Click/interact with widget element
Expected:
- Submission captured
- AI responds appropriately
- Widget updates OR new widget appears
```

**Test Case 3: Complete Flow**
```
Input: Complete primary user journey
Expected:
- Each step progresses naturally
- Surfaces appear/update/remove appropriately
- Final state is clean (completed task)
```

**Test Case 4: Error Handling**
```
Input: Invalid/unclear request
Expected:
- AI asks for clarification
- No crashes
- Graceful handling
```

### Step 5.4: Debug Common Issues

**Issue: Widget doesn't appear**
Check:
- Is widget ID in catalog?
- Is AI using correct widgetId in tool call?
- Check console for errors

**Issue: Widget appears but data is wrong**
Check:
- Schema properties match widget expectations
- AI is populating required fields
- Widget data extraction handles types correctly

**Issue: User interaction does nothing**
Check:
- Widget calls `data.submitValue()`
- Widget has correct `supportedActions` in catalog
- Subscription to `_genUiManager.onSubmit` is active

**Issue: AI doesn't respond**
Check:
- System prompt is set
- Tools are added to AI client
- No errors in console
- Firebase AI client configured

**Issue: Surfaces update incorrectly**
Check:
- Surface IDs are consistent
- Update logic in `_surfaceUpdateSubscription` is correct
- AI is using updateSurface vs createSurface correctly

---

## Phase 6: Documentation

### Step 6.1: Create Example README

**File:** `lib/examples/[example_name]/README.md`

```markdown
# [Example Name] Example

## Overview
This example demonstrates [what it does] using Fleeting Interface patterns.

## Features
- [Feature 1]
- [Feature 2]
- [Feature 3]

## Widgets Used
- **[Widget1]**: [Purpose]
- **[Widget2]**: [Purpose]

## Custom Tools
- **[Tool1]**: [Purpose]

## How to Run
```bash
cd lib/examples/[example_name]
flutter run -t main.dart
```

## User Journey
1. User [does this]
2. AI [responds with this]
3. User [interacts]
4. AI [follows up]

## Key Patterns Demonstrated
- [Pattern 1]: [How it's shown]
- [Pattern 2]: [How it's shown]

## Code Structure
```
[example_name]/
├── main.dart                    # Entry point
├── [example_name]_page.dart     # Main conversation page
└── src/
    ├── catalog/                 # Widget catalog
    ├── widgets/                 # Widget implementations
    ├── tools/                   # Custom tools (if any)
    └── models/                  # Data models
```
```

### Step 6.2: Add to Main Examples List

Update any examples index file to include the new example.

---

## Checklist: Am I Done?

Use this final checklist before considering example complete:

### Architecture ✓
- [ ] Answered all 8 discovery questions
- [ ] Designed 3-7 widgets (not too few, not too many)
- [ ] Created data models for widgets
- [ ] Designed custom tools (if needed)
- [ ] Wrote complete system prompt

### Implementation ✓
- [ ] Catalog file created with all widgets
- [ ] All widget classes implemented
- [ ] All tool classes implemented (if needed)
- [ ] Main page follows exact structure
- [ ] Entry point (main.dart) created
- [ ] Mock data created (if needed)

### Quality ✓
- [ ] No import errors
- [ ] No type errors
- [ ] Widgets extract data safely (null checks)
- [ ] User interactions submit correct data
- [ ] Tools return valid JSON
- [ ] System prompt covers all widgets and tools

### Testing ✓
- [ ] Example runs without crashes
- [ ] Initial greeting works
- [ ] Widget appears on first interaction
- [ ] User interaction triggers response
- [ ] Complete flow works end-to-end
- [ ] Error cases handled gracefully

### Documentation ✓
- [ ] README created
- [ ] Code structure explained
- [ ] User journey documented
- [ ] Key patterns highlighted

### Polish ✓
- [ ] UI looks reasonable
- [ ] Conversation flows naturally
- [ ] Surfaces appear/update/remove correctly
- [ ] Auto-scroll works
- [ ] Loading indicator shows during AI thinking

---

## Quick Reference: Decision Trees

### Widget Selection
```
User needs to:
├─ Browse → Carousel (visual) or List (text)
├─ View → Card (simple) or Panel (complex)
├─ Input → InputGroup (1-3 fields) or Form (4+)
├─ Act → Button (single) or ButtonGroup (multiple)
└─ Track progress → Itinerary/Timeline
```

### Surface Management
```
Should I:
├─ Create new surface?
│  ├─ New task/topic → YES
│  ├─ Different info type → YES
│  └─ Parallel info → YES
├─ Update existing surface?
│  ├─ Refining same info → YES
│  ├─ Adding detail → YES
│  └─ User changed input → YES
└─ Delete surface?
   ├─ Task completed → YES
   ├─ User requested → YES
   └─ No longer relevant → YES
```

### Tool vs Widget
```
User needs:
├─ External data (API, DB) → Tool
├─ Complex computation → Tool
├─ Display information → Widget
├─ Collect input → Widget
└─ Take action (non-data) → Widget with interaction
```

---

## Tips for Success

1. **Start simple**: First example should be minimal (2-3 widgets, 1 flow)
2. **Test incrementally**: Test after each widget addition
3. **Copy structure exactly**: Use travel_example structure as template
4. **System prompt is key**: Spend time on clear, complete prompt
5. **Mock data early**: Don't block on real APIs, use mocks
6. **Surface IDs matter**: Use consistent, descriptive IDs
7. **Think conversation-first**: Not app navigation, but dialogue flow
8. **One change at a time**: Don't modify multiple files without testing

---

## Common Mistakes to Avoid

❌ **Don't:**
- Skip discovery questions (you'll build wrong thing)
- Create too many widgets (starts as overwhelming)
- Make widgets too complex (break into smaller pieces)
- Write vague system prompt (AI won't know what to do)
- Forget null safety (will crash)
- Use timers for ephemeral (use purpose-driven lifecycle)
- Bypass the standard page structure (it works, don't change it)

✅ **Do:**
- Ask clarifying questions upfront
- Start with 2-3 widgets, add more later
- Keep widgets focused on one purpose
- Write detailed, example-rich system prompt
- Handle null/missing data everywhere
- Use conversation/context to determine surface lifecycle
- Follow the proven page structure exactly

---

## Example Generation Prompt Template

When you want an agent to generate an example, use this prompt:

```
I want to create a new Fleeting Interface example.

Domain: [What it's about]
Goal: [Primary user goal]
Complexity: [Minimal/Moderate/Complex]

Please follow the EXAMPLE_GENERATION_GUIDE.md step by step:
1. Ask me the discovery questions (Step 1)
2. Design the architecture (Step 2)
3. Implement all components (Step 3)
4. Create system prompt (Step 4)
5. Validate (Step 5)
6. Document (Step 6)

Start with Phase 1: Discovery & Requirements.
```

The agent should then walk through each phase, asking questions, confirming decisions, and implementing systematically.
