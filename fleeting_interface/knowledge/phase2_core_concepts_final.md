# Phase 2.2: Core Concepts Consolidation
**Authoritative Definitions Following CLAUDE.md Principles**

---

## METHODOLOGY

**For each of the 5 Core Concepts:**
1. Extract ALL explanations from all knowledge files
2. Judge each using Language Audit (✅ vs ❌)
3. Apply "Show, Then Name" principle (example BEFORE terminology)
4. Select best concrete example
5. Create final authoritative version
6. Specify where/how to present in 30-min structure

**CLAUDE.md Principles Applied:**
- Concrete Over Abstract
- Show, Then Name
- Memorable phrases usage
- ✅ Language patterns only

---

## CORE CONCEPT #1: INTENT-DRIVEN (PRIMARY CONCEPT)

### From CLAUDE.md:
> Your intent shapes the interface

**Marked as PRIMARY CONCEPT in CLAUDE.md**

### All Extracted Explanations:

**presentation_outline.md:**
- "Your intent is the layout" ✅
- "Traditional: 'Which app?' → 'Where's the feature?' → 'How do I use it?'"
- "Intent-driven: 'What am I trying to do?' → Interface appears"
- "Define all capabilities, show only relevant ones for current intent"

**the_fleeting_interface.md:**
- "Behaviors over States - define capabilities, AI shows relevant ones" ✅
- "Intent-based outcome specification" ⚠️ (jargony)

**presentation_flow_and_notes.md:**
- "Tell the computer what you want, not how to do it" ✅
- "Intent-Based Outcome Specification" (technical term)

**Language Audit Ratings:**
- ✅ "Your intent is the layout" - EXCELLENT
- ✅ "Define all capabilities, show only relevant ones" - CONCRETE
- ✅ "Tell computer what you want" - SIMPLE
- ⚠️ "Intent-based outcome specification" - TECHNICAL

### Best Example (Judged):

**From presentation_outline.md** - Application-centric vs Intent-driven comparison ✅
```
Traditional (Application-Centric):
1. Open email app
2. Click compose
3. Find recipient field
4. Type message
5. Find send button

Intent-Driven:
"Send update to team"
→ Compose interface appears with team pre-selected
→ Done → Interface dissolves
```

**Why this example:**
- Concrete workflow comparison
- Shows vs tells
- Relatable task (everyone sends emails)
- Demonstrates composition + ephemeral in one example

### AUTHORITATIVE VERSION:

#### Concept Name:
**Intent-Driven Composition**

#### Key Phrase (Memorable):
**"Your intent is the layout"**
(From CLAUDE.md Memorable Phrases)

#### Show, Then Name Presentation:

**1. FIRST: Show the problem** (Don't name intent-driven yet)
```
You want to send an update to your team.

Traditional interface:
- Open email app (cognitive step 1: which app?)
- Click compose (cognitive step 2: where's the feature?)
- Find recipient field (cognitive step 3: how do I use it?)
- Select team members (cognitive step 4: who do I need?)
- Type message
- Find send button

Five cognitive steps before you even start your real task.
```

**2. THEN: Show the alternative** (Still don't name it)
```
What if you could just express your intent?

"Send update to team"

Interface appears:
- Compose field already open
- Team members pre-selected (it knows)
- Send button prominent
- Task complete → Interface dissolves

Zero navigation. Zero searching. Pure intent.
```

**3. NOW: Name the concept**
```
This is intent-driven composition.

Your intent shapes what appears.

Not: "Which app do I need?"
But: "What am I trying to do?"

Environment materializes around the answer.
```

**4. Explain the mechanism** (How it works)
```
How it works:
- Define all possible capabilities (schema)
- AI reads your intent
- Composes only relevant capabilities
- Shows you exactly what you need

Schema describes what's possible.
Context determines what appears.
```

#### Usage in 30-Min Structure:

**Where**: Act 2.1 (Defining Ephemeral Interfaces) + Act 2.2 (Why Now)

**Allocation:**
- Problem example: 30 sec (Act 1.2)
- Solution example: 45 sec (Act 2.1)
- Name and explain: 45 sec (Act 2.1)

**Total: 2 min across presentation**

#### Code Example (Optional, for technical audience):

**If including code** (Act 2.4 or 4.3):
```dart
// Define all possible capabilities
final schema = Schema.object(properties: {
  'composeEmail': EmailTool.schema,
  'scheduleMessage': ScheduleTool.schema,
  'createTask': TaskTool.schema,
});

// AI reads intent: "Send update to team"
// Selects relevant tool: composeEmail
// Generates interface with team pre-selected
```

**Keep to <15 lines, annotate clearly**

---

## CORE CONCEPT #2: EVERYONE TAX

### From CLAUDE.md:
> You pay for features built for others

### All Extracted Explanations:

**presentation_outline.md:**
- "Everyone Tax - you pay for features built for others" ✅
- "Complex apps: Everyone pays rent on everyone else's features" ✅
- "Photoshop's 500 menu items (you use 20)" ✅
- "Enterprise software (built for power users, everyone pays cognitive load)" ✅
- "Simple apps: Nobody gets what they need when they need it" ✅
- "Both fail because they're static snapshots" ✅

**the_fleeting_interface.md:**
- "Traditional 'one-size-fits-all' interfaces impose 'Everyone Tax'" ✅
- "Cluttered features, menus, and options" ✅
- "Eliminates 'Everyone Tax'" ✅

**presentation_flow_and_notes.md:**
- "Everyone Tax / Interface Debt" (we standardized to "Everyone Tax")
- "Every feature for someone else is cognitive load you carry" ✅

**Language Audit Ratings:**
ALL ✅ EXCELLENT - This concept has the cleanest language across all files

### Best Example (Judged):

**Photoshop toolbar** (from presentation_outline.md)
```
Photoshop: 500 menu items
You use: 20
You pay cognitive load for: 480

= Everyone Tax
```

**Why this example:**
- Instantly recognizable (most people know Photoshop complexity)
- Quantifiable (500 vs 20)
- Visual (can show actual Photoshop interface)
- Memorable calculation

**Alternative example** (for different audience):
```
Enterprise software dashboard:
- Built for power users (5% of company)
- Everyone else (95%) navigates same complex interface
- Everyone pays for features they'll never use

= Everyone Tax
```

### AUTHORITATIVE VERSION:

#### Concept Name:
**The Everyone Tax**

#### Key Phrase (Memorable):
**"You pay for features built for others"**
(From CLAUDE.md Memorable Phrases)

#### Show, Then Name Presentation:

**1. FIRST: Show the experience** (Visual)
```
[Show Photoshop interface with hundreds of buttons]

500 menu items and buttons.

How many do you use?

[Highlight the ~20 commonly used ones]

You use about 20.

But you navigate past all 500.
Every. Single. Time.
```

**2. THEN: Quantify the cost**
```
480 buttons you'll never click.
480 menu items you'll never explore.
480 pieces of cognitive load.

You pay attention to all of them.
Because they're there.
Because the interface is static.
Because it was built for everyone.

Which means it's optimal for no one.
```

**3. NOW: Name the problem**
```
This is the Everyone Tax.

One-size-fits-all means:
- Complex apps burden everyone
- Simple apps serve no one
- You pay for features built for others

Static interfaces create this tax.
Ephemeral interfaces eliminate it.
```

**4. Show the solution** (Connect to intent-driven)
```
Ephemeral approach:

Define 500 possible capabilities (schema).
Show only the 20 relevant to your current task.

Different user, different task = different 20.

No tax.
No burden.
Just what you need.
```

#### Usage in 30-Min Structure:

**Where**: Act 1.2 (The Problem) - PRIMARY problem to establish

**Allocation:**
- Show Photoshop example: 45 sec
- Quantify the cost: 30 sec
- Name the problem: 30 sec
- Show solution principle: 15 sec (transition to Act 2)

**Total: 2 min in Act 1.2**

#### Visual Recommendations:

**Slide 1**: Photoshop interface screenshot (all buttons visible)
**Slide 2**: Same screenshot with 20 buttons highlighted, 480 grayed out
**Slide 3**: Simple equation: "500 - 20 = 480 (Everyone Tax)"
**Slide 4**: Ephemeral solution - show only relevant 20

---

## CORE CONCEPT #3: EPHEMERAL (Purpose-Driven Lifecycle)

### From CLAUDE.md:
> Appears when needed, dissolves when done

**Subtitle: Purpose-Driven, Not Timer-Based**

### All Extracted Explanations:

**presentation_outline.md:**
- "Appears when needed, dissolves when done" ✅ (EXACT CLAUDE.md phrasing)
- "Purpose-driven lifecycle, not timer-based" ✅ (EXACT CLAUDE.md phrasing)
- "Lifecycle tied to cognitive task, not clock" ✅
- "Payment interface vanishes after confirmation (task complete)" ✅
- "Research environment fades when you've found what you need (question answered)" ✅

**the_fleeting_interface.md:**
- "Temporal but not timer-based" ✅
- Code example showing WRONG vs RIGHT ✅

```dart
// WRONG: Too literal with time
if (minutesSinceInteraction > 5) vanish();

// RIGHT: Driven by purpose and relevance
if (taskCompleted) vanish();
if (contextChanged && !relevantAnymore) fade();
```

**presentation_flow_and_notes.md:**
- "Temporary existence - appears when needed, gone when not" ✅
- "Purpose-driven lifecycle - exists while serving its purpose" ✅

**Language Audit Ratings:**
ALL ✅ EXCELLENT - This is one of the clearest concepts across all files

### Best Example (Judged):

**Payment interface lifecycle** (from presentation_outline.md)
```
You need to pay a bill.

Interface appears:
- Payment form
- Amount pre-filled (it knows)
- Saved payment method selected

You confirm.

Payment processes.

Interface dissolves.

Not because 60 seconds passed.
Because the purpose is fulfilled.
```

**Why this example:**
- Familiar task (everyone pays bills)
- Clear lifecycle (appears → serves → dissolves)
- Emphasizes purpose over time
- Contrasts with traditional (form stays open, you close it manually)

**Code example** (CRITICAL clarification):
The WRONG vs RIGHT code from the_fleeting_interface.md is ESSENTIAL for preventing misunderstanding.

### AUTHORITATIVE VERSION:

#### Concept Name:
**Ephemeral Interfaces**
**Subtitle: Purpose-Driven Lifecycle**

#### Key Phrase (Memorable):
**"Appears when needed, dissolves when done"**
(From CLAUDE.md - exact phrasing)

#### Critical Clarification Phrase:
**"Purpose-driven, not timer-based"**
(From CLAUDE.md - essential distinction)

#### Show, Then Name Presentation:

**1. FIRST: Show traditional interface behavior**
```
You need to pay a bill.

You open the payment app.
You fill in the form.
You submit.
You wait for confirmation.

The form is still there.
You close it manually.
(Or it stays open until you quit the app.)

The interface exists until YOU dismiss it.
```

**2. THEN: Show ephemeral behavior** (Don't name "ephemeral" yet)
```
You need to pay a bill.

Payment interface appears.
- Amount pre-filled
- Payment method selected
- Ready to confirm

You confirm.

Payment processes.

Interface dissolves.

You didn't close it.
It knew it was done.
```

**3. CRITICAL: Prevent timer misunderstanding**
```
NOT because 60 seconds passed.
NOT because of a countdown.

Because the purpose was fulfilled.
The task was complete.
The interface was no longer needed.

Purpose-driven, not timer-based.
```

**4. NOW: Name and define**
```
This is an ephemeral interface.

Ephemeral = temporary
But temporary tied to PURPOSE, not TIME.

Appears when you need it.
Adapts as your need evolves.
Dissolves when purpose is fulfilled.

Transient in form.
Intelligent in lifecycle.
```

**5. Show the code** (Emphasizes the distinction)
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

**Why show code:**
- Makes the distinction crystal clear
- Prevents "Snapchat filter" misunderstanding
- Shows this is intelligent, not mechanical
- Technical audience appreciates precision

#### Usage in 30-Min Structure:

**Where**: Act 2.1 (Defining Ephemeral Interfaces) - First characteristic

**Allocation:**
- Traditional behavior: 20 sec
- Ephemeral behavior: 30 sec
- Prevent timer misunderstanding: 30 sec
- Name and define: 30 sec
- Code example: 20 sec

**Total: 2:10 min in Act 2.1**

#### Visual Recommendations:

**Slide 1**: Traditional app (static form stays open)
**Slide 2**: Ephemeral flow (appears → serves → dissolves) with animation
**Slide 3**: Large text: "Purpose-driven, NOT timer-based"
**Slide 4**: Code comparison (wrong vs right)

---

## CORE CONCEPT #4: CONTEXT-DRIVEN ADAPTATION

### From CLAUDE.md:
> Same capability, different contexts = different interfaces

### All Extracted Explanations:

**presentation_outline.md:**
- "Multi-dimensional context signals: Who/Where/What/When/Why" ✅
- "Context fusion: Multiple signals → Single understanding" ✅
- Schedule example (Morning/Midday/Evening) ✅

**the_fleeting_interface.md:**
- "Context Fusion: who/where/what/when/why" ⚠️ (needs explanation before naming)
- "AI analyzes your intent within rich, multi-dimensional context" ✅
- "Fuses together who you are, where you are, what you're doing, when it's happening" ✅

**presentation_flow_and_notes.md:**
- "Same interface becomes different based on situation" ✅
- Oven demo (Cookies/Turkey/Pizza) ✅
- Schedule demo (Morning/Midday/Evening) ✅

**Language Audit Ratings:**
- ✅ Examples excellent (schedule, oven)
- ⚠️ "Context Fusion" needs explanation before naming
- ✅ Multi-dimensional signals concrete

### Best Example (Judged):

**Schedule adaptation** (from presentation_outline.md + flow notes)

Winner: MORE RELATABLE than oven

```
"Show my schedule"

Same intent. Different contexts. Different interfaces.

Morning (commute):
→ Next 3 events only
→ Large text (glance-able)
→ Transit times emphasized
→ Minimal layout

Midday (at desk):
→ Full day visible
→ Detailed information
→ Related documents linked
→ Dense, efficient

Evening (home):
→ Tomorrow preview
→ Relaxed layout
→ Social context
→ Integration with home routines

Same capability.
Three different interfaces.
Because context shapes what you need.
```

**Why this example:**
- Everyone checks schedules (relatable)
- Three clearly different contexts
- Shows multi-dimensional signals (time, location, device, posture)
- Can be visualized side-by-side
- Demonstrates value clearly (not just different, better for each context)

#### Usage in 30-Min Structure:

**Where**: Act 2.3 (Context-Driven Adaptation) with LIVE DEMO

**Allocation:**
- Explain multi-dimensional signals: 45 sec
- DEMO schedule adaptation: 1:30 min
- What adapts (content, layout, features): 45 sec

**Total: 3 min in Act 2.3**

#### DEMO Integration:

**This MUST be shown, not just told**

**Demo flow:**
1. Open schedule on phone (morning mode)
   - Narrate: "Morning commute - I need quick glance"
   - Show: Next 3 events, large text, transit

2. Open schedule on desktop (midday mode)
   - Narrate: "At my desk - I want full context"
   - Show: Full day, dense, documents linked

3. Open schedule on tablet (evening mode)
   - Narrate: "Home - I want to prepare for tomorrow"
   - Show: Tomorrow preview, relaxed

**Key narration points:**
- "Same data, same capability"
- "Different interface because context changed"
- "Who I am (same person) + Where I am + What I'm doing + When = What I need"

**High-bandwidth loop integration:**
If including high-bandwidth concept, show during demo:
- User adjusts time slider
- Interface updates immediately
- Structured data sent to AI (not verbose text)
- "Interact, don't describe"

---

## CORE CONCEPT #5: CONVERSATION AS STATE

### From CLAUDE.md:
> The conversation history IS the state machine

### All Extracted Explanations:

**presentation_outline.md:**
- "Conversation history IS the state machine" ✅ (EXACT CLAUDE.md)
- Traditional: Navigate predefined rooms ⚠️ (needs example)
- Ephemeral: Conversational refinement ✅
- Ocean temps example ✅

**the_fleeting_interface.md:**
- No direct coverage (architectural detail not in concept doc)

**presentation_flow_and_notes.md:**
- "Conversation as state" mentioned
- Not deeply explained

**Language Audit Ratings:**
- ✅ Core phrase excellent
- ⚠️ Needs strong contrast example (navigation vs conversation)
- ✅ Ocean temps example good

### Best Example (Judged):

**Ocean temperature exploration** (from presentation_outline.md)

```
Traditional app (navigation model):
- Open research app
- Click "Climate" section
- Navigate to "Ocean Data"
- Select temperature view
- Go back
- Navigate to "Weather" section
- Find storms
- Try to compare (apps don't connect)

8 navigation steps.
Lost context at each transition.

Ephemeral interface (conversation model):
User: "Show ocean temperatures"
→ Temperature map appears

User: "How does this connect to storms?"
→ Storm overlay added to SAME map

User: "Focus on 2020"
→ Map zooms to 2020 data

No navigation.
No "back" button.
Just continuous refinement.

The conversation history IS the interface state.
```

**Why this example:**
- Shows contrast clearly (navigation vs conversation)
- Demonstrates refinement (each step builds on previous)
- No explicit state transitions (emerges from conversation)
- Relatable research flow

### AUTHORITATIVE VERSION:

#### Concept Name:
**Conversation as State**

#### Key Phrase (Memorable):
**"The conversation history IS the state machine"**
(From CLAUDE.md Glossary)

#### Show, Then Name Presentation:

**1. FIRST: Show traditional mental model**
```
When you use an app today, you think in locations:

"I'm on the home screen"
"Now I'm in the settings menu"
"Let me go back to the product page"

Your mental model is spatial navigation.
The app has fixed rooms.
You move between them.
The path is predetermined.
```

**2. THEN: Show ephemeral mental model** (Don't name yet)
```
What if there were no rooms to navigate?

You start with a question:
"Show ocean temperatures"
→ Temperature map appears

That leads to another question:
"How does this connect to storms?"
→ Storm data overlays on the same map

Which leads to:
"What happened in 2020?"
→ Map focuses on 2020

Your mental model is conversational evolution.
Not "where am I?" but "what am I understanding?"
```

**3. NOW: Name the paradigm**
```
This is Conversation as State.

Traditional apps: State is coded (Screen A → Screen B → Screen C)
Ephemeral: State emerges from interaction (Question → Refinement → Understanding)

The conversation history IS the state machine.

No "back" button needed.
Just continuous refinement.
```

**4. Why this works** (Connect to AI)
```
Think about how conversations naturally flow:

"I'm interested in ocean temperatures"
→ [Someone shows you maps]

"How does this connect to storms?"
→ [They add storm data to the same view]

"What happened in 2020?"
→ [They zoom into 2020]

Each response is deterministic given the conversation so far.

Same with interfaces:
Given your full interaction history →
The next interface state is logically derivable.
```

#### Usage in 30-Min Structure:

**Where**: Act 2.2 (Why Now: From Content to Conversation-Driven) - Part B

**Allocation:**
- Traditional mental model: 30 sec
- Ephemeral mental model (example): 45 sec
- Name the paradigm: 30 sec
- Why it works: 30 sec

**Total: 2:15 min in Act 2.2**

#### Visual Recommendations:

**Slide 1**: Traditional app (flowchart with boxes and arrows)
**Slide 2**: Conversation flow (linear conversation bubbles that evolve)
**Slide 3**: Side-by-side comparison (navigation vs conversation)
**Slide 4**: Ocean temps example progression (3 states shown as conversation)

---

## CROSS-CONCEPT CONNECTIONS

### How the 5 Concepts Relate:

```
Intent-Driven (PRIMARY)
    ↓ enables
Ephemeral
    ↓ requires
Context-Driven Adaptation
    ↓ powered by
Conversation as State
    ↓ solves
Everyone Tax
```

**Narrative flow:**
1. **Problem**: Everyone Tax (one-size-fits-all is broken)
2. **Solution paradigm**: Intent-Driven (your intent shapes interface)
3. **Implementation**: Ephemeral (temporary, purpose-driven)
4. **How it adapts**: Context-Driven (multi-dimensional signals)
5. **Architecture**: Conversation as State (history is the state machine)

### Concept Dependencies:

- **Ephemeral REQUIRES Intent-Driven** (can't compose without understanding intent)
- **Context-Driven ENHANCES Ephemeral** (adapts the composition)
- **Conversation as State ENABLES Intent-Driven** (state emerges from intent expression)
- **All 4 SOLVE Everyone Tax** (by eliminating one-size-fits-all)

### Presentation Strategy:

**Act 1**: Establish Everyone Tax (the problem)
**Act 2**: Present solutions in order of logical dependency:
  1. Intent-Driven (paradigm)
  2. Ephemeral (temporary manifestation)
  3. Context-Driven (intelligent adaptation)
  4. Conversation as State (architectural response)

**Each concept references previous concepts to build understanding**

---

## COMPLETION STATUS

✅ All 5 Core Concepts extracted from all files
✅ Each judged using Language Audit
✅ Best examples selected
✅ "Show, Then Name" structure created
✅ Authoritative versions documented
✅ Usage in 30-min structure specified
✅ Cross-concept connections mapped

**Ready for Phase 2.3: Memorable Phrases Selection & Placement**

---

## USAGE NOTES FOR SLIDE CREATION

**When creating slides in Phase 4:**

1. **Use ONLY these authoritative versions**
   - Do not create new explanations
   - Do not mix phrasing from different versions
   - Use exact examples specified

2. **Follow "Show, Then Name" structure exactly**
   - Example FIRST
   - Name concept SECOND
   - Explain mechanism THIRD

3. **Use specified allocation times**
   - Don't expand beyond time budget
   - If cutting needed, cut explanation not example

4. **Include specified visuals**
   - Code examples where noted
   - Side-by-side comparisons
   - Demo flows

**This document is now the SINGLE SOURCE OF TRUTH for Core Concepts.**
