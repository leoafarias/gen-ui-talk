---
style: cover
---

@section {
  flex: 2
}
@block {
  align: center
}

# The Fleeting Interface
## Gen + Ephemeral UI

---
style: fullscreen
---

@webview {
  url: "https://mix-docs-git-redesign-remix-landing-page-fluttertools.vercel.app/"
}

---
---

@block {
  align: center
}

#### Leo Farias {.heading}
#### @leoafarias {.subheading}
https://github.com/btwld

@block {
  align: centerLeft
}
- Bitwild @ Concepta
- Open Source Contributor
- Flutter & Dart GDE
- Passionate about UI/UX/DX

---
---

@block

@block {
  align: centerLeft
  flex: 2
}
> [!WARNING]
> This presentation contains live AI-generated content. Unexpected things may occur during the demonstration.

@block

---
---

@block {
  align: center
}

## Every interface you use today was designed the same way {.heading}

@block {
  align: centerLeft
}

- Fixed. Static. One-size-fits-all.
- You adapt to it. It doesn't adapt to you.
- This has been true for 50 years.

---
---
@block
@block {
  align: centerLeft
  flex: 2
}

## The Shift {.heading}

- Your intent shapes what appears
- Compose around tasks, dissolve when done
- Define all capabilities, show only relevant ones

---
---

@block {
  align: center
  flex: 2
}

## The Everyone Tax {.heading}

@block {
  align: centerLeft
}

Every feature built for someone else is cognitive load you carry.

---
---

@block {
  align: center
}

## Cognitive Load {.heading}
Not all mental effort is equal:

@block


- **Intrinsic:** The inherent difficulty of your task
- **Germane:** Productive learning that makes you better
- **Extraneous:** Wasted effort from poor design

---
---

@section
@block {
  align: bottomCenter
}
## The Toolbar Problem {.heading}

@section

@toolbar_demo {
  all: true
  align: topCenter
  chat: false
}

---
---

### Everyone Tax is pure Extraneous Load


---
---

@block {
  align: center
}

## The Impossible Trade-off {.heading}

@block

- Show everything. Everyone drowns.
- Hide everything. Everyone hits walls.
- One size fits all. Nobody gets what they need.

---
style: quote
---

@block {
  flex: 3
}

> # "Intent-based outcome specification...the first new UI interaction paradigm since the invention of GUIs"
>
> — IBM Research AI

@block

---
---

@toolbar_demo {
  all: true
  align: topCenter
  chat: true
}

---
---

@block {
  align: center
}

## What Changed? {.heading}

@block

- LLMs can now understand intent.
- LLMs can respond in a structured format.
- LLMs can now adapt based on context.

---
---

@block {
  align: center
}

## Understanding Intent {.heading}
#### LLMs translate natural language into function calls. {.subheading}

@block

![LLM Interaction](assets/llm_interaction.png)


---
---

@block {
  align: center
}

## Structured Output {.heading}
#### LLMs transform unstructured intent into structured UI. {.subheading}

@block {
  align: center
  flex: 1
}

![Structured Output](assets/structured_output.png)


---
---

@block {
  align: center
}
## Generative + Ephemeral UI {.heading}
The new paradigm is now possible.

@block

- **Generative UI:** Composes from intent
- **Ephemeral UI:** Appears while relevant
- **Together:** Appears when needed, dissolves when done

---
---

@block {
  align: center
}
## Define Capabilities {.heading}

You're not defining screens.
You're defining what the system can do.

@block

```dart
final schema = Schema.object(properties: {
  'label': Schema.string(
    description: 'The label of the dropdown',
  ),
  'currentValue': Schema.string(
    description: 'The current value',
  ),
  'options': Schema.array(
    description: 'Available options',
    items: Schema.string(),
  ),
});
```
---
---

@block {
  align: center
}
## Tool Calling Workflow {.heading}

@block {
  align: center
  flex: 2
}

![LLM Tools Selection](assets/llm_tools.png)

---
---

@block {
  align: center
}

### Schema → UI Flow {.heading}
Define schemas. AI selects. Flutter builds.

@block {
  align: center
  flex: 2
}

![Widget Schema Flow](assets/widget_schema.png)


---
---

@block {
  align: center
}

### Context-Driven Adaptation {.heading}
Same capability, different contexts = different interfaces.

@block


- **Who:** User preferences and history
- **What:** Current task and intent
- **When:** Time of day, urgency
- **Where:** Location, device

---
---

#### Context fusion
### Multiple signals → Single understanding.

---
style: fullscreen
---

@smart_oven {
  chat: true
}

---
---

@block {
  align: center
}

### Conversation Loop {.heading}
Shared state evolves through conversation.

@block {
  align: center
  flex: 2
}

![Widget Response Flow](assets/widget_response.png)


---
style: quote
---

@block {
  flex: 2
}
> # "Simple is hard. Easy is harder. Invisible is hardest."
> — Jean-Louis Gassée

@block

---
---

## What Changes {.heading}


- Action → Intent-centric
- Navigation → Composition
- Persistent UI → Ephemeral UI
- Static → Generative & Adaptive
- Manual learning → Automatic understanding


---
---

@block {
  align: center
}
## Flutter + AI {.heading}
https://github.com/flutter/genui

@block

- Schema-based capability definition
- Context-aware composition
- LLM-driven intent understanding
- Flutter's declarative architecture


---
---

@block {
  align: center
}

## Thank You {.heading}
https://github.com/leoafarias/gen-ui-talk
