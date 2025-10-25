# Phase 3.3: Technical Content Selection
**Code Examples for 30-Minute Presentation**

---

## CLAUDE.MD GUIDANCE

**Principle**: "Concepts first, Flutter second"
**Maximum**: 3-4 code slides total
**Requirements**:
- <20 lines per example
- Clear purpose (demonstrates concept, not shows "how to build")
- Syntax highlighted
- Well-annotated

---

## CODE EXAMPLES SELECTED

### Example 1: Purpose-Driven vs Timer-Based (ESSENTIAL)

**Location**: Slide 13 (Act 2.1 - Defining Ephemeral)
**Purpose**: Clarify ephemeral ≠ timer-based (critical distinction)
**Concept**: Temporal Existence (Purpose-Driven)

**Code**:
```dart
// ❌ WRONG: Timer-based
if (minutesSinceInteraction > 5) {
  vanish();
}

// ✅ RIGHT: Purpose-driven
if (taskCompleted) {
  dissolve();
}
if (contextChanged && !relevantAnymore) {
  fade();
}
```

**Validation**:
- ✅ Line count: 11 lines (well under 20)
- ✅ Valid Dart syntax
- ✅ Clear annotations (❌ / ✅)
- ✅ Shows wrong way AND right way
- ✅ Demonstrates core concept (purpose not timer)

**Rationale**:
This is CRITICAL to prevent "Snapchat filter" misunderstanding. Without this, audience may think ephemeral = "disappears after 5 seconds". This code makes the distinction crystal clear.

**Slide Syntax**:
````markdown
```dart
// ❌ WRONG: Timer-based
if (minutesSinceInteraction > 5) {
  vanish();
}

// ✅ RIGHT: Purpose-driven
if (taskCompleted) {
  dissolve();
}
if (contextChanged && !relevantAnymore) {
  fade();
}
\```{.code}
````

**Status**: ✅ APPROVED for inclusion

---

## OPTIONAL CODE EXAMPLES (Not in current manifest)

### Optional Example 2: Schema Definition

**Potential Location**: Act 2.1 or Act 4.3 (if showing technical implementation)
**Purpose**: Show how to define capabilities (behaviors over states)
**Concept**: Intent-Driven Composition (schema-driven)

**Code** (from existing slides.md):
```dart
final schema = Schema.object(properties: {
  'textFields': Schema.array(
    description: 'A list of text fields',
    items: TextFieldSchemaDto.schema,
    nullable: true,
  ),
  'dropdowns': Schema.array(
    description: 'A list of dropdowns',
    items: DropdownSchemaDto.schema,
    nullable: true,
  ),
  'colorPickers': Schema.array(
    description: 'A list of color pickers',
    items: ColorPickerDtoSchema.schema,
    nullable: true,
  ),
});
```

**Validation**:
- ✅ Line count: 16 lines (under 20)
- ✅ Valid Dart syntax (Gemini Schema)
- ⚠️ Requires context (what is TextFieldSchemaDto?)
- ⚠️ Technical for conceptual talk

**Decision**: ❌ CUT for 30-min version
**Reason**:
- CLAUDE.md says "concepts first, Flutter second"
- We're time-constrained (30 min not 40 min)
- Schema definition is implementation detail, not concept
- Travel demo shows this in action (better than code)
- Can mention "define capabilities in schema" without showing code

**Alternative**: Mention in speaker notes, don't show on slide

---

### Optional Example 3: Widget Tool Declaration

**Potential Location**: Act 2.4 (Travel Demo setup)
**Purpose**: Show how widgets register as tools
**Concept**: Technical implementation

**Code** (simplified):
```dart
SuperDeckApp(
  options: DeckOptions(
    widgets: {
      'travel_example': (_) => TravelExampleWidget(),
    },
  ),
)
```

**Validation**:
- ✅ Line count: 8 lines
- ✅ Valid Dart syntax
- ⚠️ Superdeck-specific (confusing)
- ⚠️ Not about ephemeral interfaces (about presentation tech)

**Decision**: ❌ CUT for 30-min version
**Reason**:
- This is presentation plumbing, not concept
- Confuses Superdeck with Ephemeral Interfaces
- No value for audience
- Demo speaks for itself

---

## EXAMPLES FROM CURRENT SLIDES.MD (Review for removal)

Reading the current slides.md, these code examples exist:

### 1. Recipe Schema
```dart
final schema = Schema.array(
  description: 'List of recipes',
  items: Schema.object(
    properties: {
      'recipeName': Schema.string(
        description: 'Name of the recipe.',
        nullable: false,
      ),
    },
    requiredProperties: ['recipeName'],
  ),
);
```

**Decision**: ❌ REMOVE - Not relevant to ephemeral interfaces

---

### 2. Model Configuration
```dart
final model = GenerativeModel(
  model: 'gemini-1.5-pro',
  apiKey: apiKey,
  generationConfig: GenerationConfig(
    responseMimeType: 'application/json',
    responseSchema: schema,
  ),
);
```

**Decision**: ❌ REMOVE - Generative UI setup, not ephemeral interfaces

---

### 3. Dropdown Schema
```dart
class DropdownSchemaDto {
  final String label;
  final String currentValue;
  final List<String> options;

  static final schema = Schema.object(properties: {
    'label': Schema.string(
      description: 'The label of the dropdown',
      nullable: false,
    ),
    // ... more fields
  });
}
```

**Decision**: ❌ REMOVE - Implementation detail, not concept

---

### 4. Color Palette Schema
```dart
final schema = Schema.object(
  properties: {
    'name': Schema.string(
      description:'Name of the color palette',
      nullable: false,
    ),
    'font': Schema.enumString(
      enumValues: ColorPaletteFontFamily.enumString,
      description: 'Font to use for color palette name',
      nullable: false,
    ),
    // ... more fields
  },
  requiredProperties: [
    'name',
    'font',
    'fontColor',
    // ...
  ],
);
```

**Decision**: ❌ REMOVE - Unrelated to ephemeral interfaces concept

---

## FINAL CODE EXAMPLES FOR PRESENTATION

### Included:
1. **Purpose-Driven vs Timer-Based** (Slide 13) ✅

### Excluded:
- Schema definitions (too technical, implementation detail)
- Widget registration (presentation plumbing)
- All "Generative UI" examples (different topic)

### Mentioned (No Code):
- "Define capabilities in schemas" (verbal only)
- "AI composes relevant ones" (verbal only)
- "Structured data from interactions" (show in demo, not code)

---

## RATIONALE FOR MINIMAL CODE

**From CLAUDE.md**:
> "Concepts first, Flutter second"
> "Show schema examples"
> "Keep 2-3 code slides maximum (currently 15+)"

**Current slides.md has**: ~15 code slides (Generative UI focus)
**30-min ephemeral presentation needs**: 1 code slide

**Why?**
1. **Conceptual talk**, not technical tutorial
2. **30 minutes** = no time for code deep-dives
3. **Demos show code in action** (better than static code)
4. **One essential code example** prevents critical misunderstanding (timer vs purpose)
5. **Everything else** can be explained verbally or shown in demo

---

## VALIDATION

**CLAUDE.md Requirement**: "2-3 code slides maximum"
**Our selection**: 1 code slide ✅

**CLAUDE.md Requirement**: "<20 lines"
**Our code**: 11 lines ✅

**CLAUDE.md Requirement**: "Demonstrates concept, not shows how to build"
**Our code**: Shows conceptual distinction (purpose vs timer) ✅

**CLAUDE.md Requirement**: "Concepts first, Flutter second"
**Our approach**: 1 essential concept code, everything else verbal/demo ✅

---

## SPEAKER NOTES FOR CODE SLIDE 13

**Setup** (before showing code):
```
Ephemeral doesn't mean timer-based.

This is critical to understand.

NOT disappearing after 60 seconds.
NOT like Snapchat messages.

Let me show you the wrong way and the right way in code.
```

**During code display**:
```
[Point to WRONG section]
This is wrong. Timer-based.
"After 5 minutes of no interaction, vanish."
That's mechanical. Unintelligent.

[Point to RIGHT section]
This is right. Purpose-driven.
"When task is completed, dissolve."
"When context changed and no longer relevant, fade."

Intelligent. Intentional. Contextual.

That's ephemeral.
```

**Transition out**:
```
With that distinction clear,
let's look at the second characteristic...
```

---

## COMPLETION STATUS

✅ All existing code examples reviewed
✅ 1 essential code example selected and validated
✅ All unnecessary code examples identified for removal
✅ Code syntax verified (valid Dart)
✅ Line count verified (<20)
✅ Speaker notes for code slide created

**Phase 3.3 COMPLETE - Ready for Phase 4: Slides Reconstruction**

---

## SUMMARY FOR PHASE 4

**When building slides.md**:

1. **REMOVE** all current code examples (Generative UI content)
2. **ADD** only Slide 13 code (purpose vs timer)
3. **REPLACE** current technical slides with conceptual slides from master outline
4. **USE** @travel_example widget for demo (no code shown)
5. **MENTION** schemas verbally, don't show code

**Result**: Conceptual presentation with 1 essential technical clarification
