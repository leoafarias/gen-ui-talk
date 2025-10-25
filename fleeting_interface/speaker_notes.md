# Speaker Notes: Ephemeral Interfaces Presentation
**Duration**: 30 minutes
**Format**: 4 Acts, 49 Slides
**Delivery**: Conversational, confident, concrete

---

## DELIVERY GUIDELINES

### Pacing:
- Act 1 (5 min): Energetic, problem-focused
- Act 2 (12 min): Explanatory, concrete, demo-heavy
- Act 3 (8 min): Thoughtful, implications-focused
- Act 4 (5 min): Actionable, inspiring

### Key Techniques:
- **Use pauses**: Let big ideas land
- **Concrete before abstract**: Show examples first, name concepts second
- **Confident about what's real**: "This works today" vs "This is emerging"
- **Conversational tone**: "You" not "one", "we" not "the industry"

### Memorable Phrases (emphasize these):
1. "Your intent is the layout"
2. "Everyone pays rent on everyone else's features"
3. "Conversation history becomes the state machine"
4. "Don't navigate to features - features materialize around you"
5. "Dissolution isn't erasure. It's integration."

---

# ACT 1: THE INTERRUPTION (5 minutes)

## Slide 1: Title Slide (15 sec)

**[Display title]**

Good [morning/afternoon].

I'm Leo Farias. Flutter & Dart GDE.

Today we're talking about something that just became possible.

---

## Slide 2: The Paradigm Statement (45 sec)

IBM Research, 2024, called this:
"Intent-based outcome specification...
the first new UI interaction paradigm in 60 years"

**[PAUSE]**

60 years.

That's the entire history of computing interfaces.
From command-line to graphical UI to touch screens.
Every digital interaction you've ever had followed the same model:

You click. You navigate. You learn where features hide.
The interface is fixed. You adapt to it.

**[PAUSE - let this land]**

That paradigm...just ended.

---

## Slide 3: The Reframe (20 sec)

For 60 years, we fought for screen real estate.

More pixels. Bigger monitors. Multiple displays.

Now we fight for cognitive real estate.

Not what fits on the screen.
But what fits in your mind.

The problem isn't screen size.
It's mental capacity.

---

## Slide 4: Photoshop Interface (15 sec)

**[SHOW: Photoshop interface screenshot - all buttons visible]**

Photoshop.
500 menu items and buttons.

How many do you use?

**[PAUSE - let audience think]**

---

## Slide 5: Everyone Tax Visual (30 sec)

**[SHOW: Same screenshot - 20 buttons highlighted, 480 grayed]**

About 20.

You use 20.
But you navigate past all 500.
Every. Single. Time.

480 buttons you'll never click.
480 menu items you'll never explore.

You pay attention to all of them.
Because they're there.
Because the interface is static.
Because it was built for everyone.

**[PAUSE]**

This is the Everyone Tax.

---

## Slide 6: Everyone Tax Equation (20 sec)

**[SHOW: Equation slide]**
500 - 20 = 480 (Everyone Tax)

In complex apps, everyone pays rent on everyone else's features.

One-size-fits-all means:
- Complex apps burden everyone
- Simple apps serve no one
- You pay for features built for others

---

## Slide 7: Application Boundaries (45 sec)

Second problem: Application Boundaries.

Your thought doesn't stop at app edges.
But your tools do.

You're researching in your browser.
You need to analyze - switch to spreadsheet.
Context dissipates.

You need to write synthesis - switch to doc.
Another restart.

Three apps. Three cognitive restarts.

Your thinking breaks at application boundaries.

Static interfaces interrupt cognitive movement.

---

## Slide 8: Static AI Outputs (15 sec)

Third problem: AI produces static outputs.

You ask a question.
You get a comprehensive report.

Mass, but no momentum.
Static answers don't support dynamic asking.

---

## Slide 9: Three Transformations (30 sec)

What if interfaces moved with your thinking instead of interrupting it?

Three transformations:

**From Static to Breathing**
Not fixed artifacts — surfaces that materialize and dissolve

**From Application-Centric to Intent-Centric**
Not "which app?" — "what am I trying to understand?"

**From Interruption to Flow**
Your thought doesn't break at boundaries

**[PAUSE]**

This is what I'm calling Ephemeral Interfaces.

---

# ACT 2: THE PARADIGM (12 minutes)

## Slide 10: Your Intent is the Layout (10 sec)

**[LARGE, centered]**

Your intent is the layout.

**[Let this sit]**

---

## Slide 11: Ephemeral Interfaces Definition (30 sec)

Ephemeral Interfaces are:

Transient cognitive surfaces—
materializing around intent,
adapting as understanding deepens,
dissolving once their purpose is fulfilled.

Not disappearing after 60 seconds.
Dissolving when done.

Purpose-driven lifecycle.

---

## Slide 12: Characteristic 1 - Purpose-Driven (45 sec)

First characteristic: Purpose-Driven Lifecycle.

Traditional:
- You pay a bill
- Form stays open
- You close it manually

Ephemeral:
- You pay a bill
- Payment form appears (pre-filled)
- You confirm
- Payment processes
- **Interface dissolves**

Not because 60 seconds passed.
Because the purpose was fulfilled.

---

## Slide 13: Code - Purpose vs Timer (30 sec)

This is critical:

**[SHOW CODE]**

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

Ephemeral doesn't mean timer-based.
It means purpose-driven.

---

## Slide 14: Characteristic 2 - Context (30 sec)

Second characteristic: Contextual Awareness.

Multi-dimensional understanding:
- **Who** you are (skills, goals, expertise)
- **Where** you are (environment, device)
- **What** you're doing (task, progress)
- **When** it's happening (time, urgency)

Same capability.
Different context.
Different interface.

Context fusion: Multiple signals → Single understanding.

---

## Slide 15: Characteristic 3 - Persistence (30 sec)

Third characteristic: Persistent Underpinnings.

The interface dissolves.
The understanding persists.

**What persists:**
- Trails of inquiry (paths explored)
- Webs of connection (ideas linked)
- Latent understanding (context built)

Light enough to move.
Strong enough to leave a trail.

---

## Slide 16: Generative Leap (30 sec)

Why now?

Generative AI evolution makes this possible.

**First Wave:** Content Generation
- AI generates text, code, images
- Output: Static artifacts

**The Problem:**
- Comprehensive reports
- We receive mass but lose momentum
- Static answers don't support dynamic asking

**The Leap:**
What if AI generated the structures of interaction themselves?

---

## Slide 17: Static vs Dynamic (20 sec)

From static answers to dynamic asking.

Not: "Here's a 10-page report on ocean temperatures"

But: "Here's an explorable environment for understanding ocean temperatures"

---

## Slide 18: Apple Quote (20 sec)

**[SHOW QUOTE]**

Apple Research, 2024:
"Ephemeral UIs—UI elements that are dynamically generated by LLMs and contextually integrated."

This isn't science fiction.
This is active research at Apple, Microsoft, Google.

---

## Slide 19: Traditional Navigation (20 sec)

Traditional mental model:
- "I'm on the home screen"
- "Now I'm in settings"
- "Let me go back"

Spatial navigation through predetermined rooms.

---

## Slide 20: Ephemeral Evolution (30 sec)

Ephemeral mental model:
- "Show ocean temperatures" → map appears
- "How does this connect to storms?" → storm overlay added
- "Focus on 2020" → map zooms to 2020

No navigation.
Just continuous refinement.

The conversation history becomes the state machine.

---

## Slide 21: Ocean Temps Example (20 sec)

**[SHOW: Progressive refinement example]**

Each interaction builds on previous.
State emerges from dialogue.
Not from predefined navigation paths.

---

## Slide 22: Context Fusion (20 sec)

Context-driven adaptation.

Multiple signals:
- Time of day
- Device type
- Location
- Task history
- User expertise

→ Single understanding → Right interface

---

## Slides 23-25: Schedule Context Demo (90 sec total)

Let me show you concrete examples.

Same request: "Show my schedule"

**[SLIDE 23: Morning]**
Morning, commute:
- Next 3 events only
- Large text
- Transit times
- Minimal layout
You're scanning quickly. Interface knows this.

**[SLIDE 24: Midday]**
Midday, at desk:
- Full day visible
- Detailed information
- Documents linked
- Dense, efficient
You have time and attention. Interface provides depth.

**[SLIDE 25: Evening]**
Evening, at home:
- Tomorrow preview
- Relaxed layout
- Social context
- Preparation mode
You're planning. Interface shifts to tomorrow.

Same capability. Different contexts. Different interfaces.

---

## Slide 26: What Adapts (20 sec)

What adapts?

- Content selection — which information matters
- Layout composition — how elements arrange
- Feature prioritization — which 3-5 capabilities appear
- Information density — detailed vs summary
- Visual styling — colors, typography for environment

All driven by context.
All composed on-demand.

---

## Slide 27: Demo Setup (30 sec)

Now let's see this working.

Live demo: Travel Planner
Built with Flutter + Gemini

**Watch for:**
- Intent-driven composition
- Context awareness
- Conversation as state
- Ephemeral lifecycle

---

## Slide 28: Live Demo (2 min)

**[RUN TRAVEL DEMO]**

**[During demo, narrate briefly]:**
- "Notice how it composes based on 'beach vacation'"
- "Budget and dates shape what appears"
- "Each interaction refines the options"

**[If demo fails, have backup plan ready]**

---

## Slide 29: Demo Debrief (30 sec)

What you just saw:

✓ **Intent-driven composition**
"Beach vacation" shaped what appeared

✓ **Context awareness**
Budget, dates, preferences determined options

✓ **Conversation as state**
Each interaction built on previous

✓ **Ephemeral**
Temporary manifestation of booking capability

**This is working today.**
Flutter + Gemini + Schema-driven architecture.

---

# ACT 3: THE SHIFT (8 minutes)

## Slide 30: The Shift (10 sec)

This is more than a feature.
It's a paradigm shift.

---

## Slide 31: Application-Centric vs Intent-Centric (45 sec)

For 60 years: Application-Centric computing.

Choose app first.
Then work within its constraints.

"Which app do I need?"
becomes its own cognitive task.

**[SHOW: User surrounded by app icons, confused]**

Now: Intent-Centric computing.

Express intent.
Environment materializes.

---

## Slide 32: Don't Navigate (20 sec)

Don't navigate to features.

Features materialize around you.

**[SHOW: User at center, features radiating in]**

---

## Slide 33: Workflow Comparison (60 sec)

**Traditional (Application-Centric):**
1. Open browser → search
2. Switch to spreadsheet → analyze
3. Switch to charts → visualize
4. Switch to presentation → create
5. Switch to doc → write

5 apps. 5 context switches. 5 cognitive restarts.

**Intent-Centric (Ephemeral):**

"Explore ocean temperature and storm intensity relationships"

→ Research environment materializes
→ As inquiry shifts: Environment reconfigures
→ Question answered: Surface dissolves

0 context switches. Continuous cognitive flow.

---

## Slide 34: The Anxiety (15 sec)

I know what you're thinking:

"If the interface dissolves, what's left?"

Fair question.

---

## Slide 35: What Dissolves vs Persists (30 sec)

**What Dissolves:**
- The UI arrangement
- The temporary surface
- The scaffolding

**What Persists:**
- Trails of inquiry
- Webs of connection
- Latent understanding
- Cognitive trails you blazed

---

## Slide 36: Dissolution = Integration (20 sec)

Dissolution isn't erasure.

It's integration.

**[SHOW: Interface fading into knowledge graph]**

---

## Slide 37: Climate Research Example (45 sec)

Example: Climate research session.

You explore climate data for 30 minutes.
Interface shows maps, graphs, annotations.
Session ends → Surface dissolves.

**What remains:**
- Insights discovered (in your notes, in system memory)
- Connections made (in knowledge graph)
- Questions identified (in next-actions)
- Cognitive trail blazed (in session history)

**Next time:**
System knows what you've explored.
Materializes new surface informed by that history.

---

## Slide 38: Design Principles (45 sec)

How do we build these responsibly?

Transparency is imperative.

Fluidity without transparency = disorienting black box.

**Three Key Principles:**

1. **Make reasoning visible**
   "Showing simplified view because you're scanning quickly"

2. **Provide override mechanisms**
   "Show me everything" always available

3. **Explainability on demand**
   "Why am I seeing this?" button

Users must understand and control
what the system understands and controls.

---

## Slide 39: Cultural Shift (30 sec)

Design for movement, not monuments.

**Current aesthetic:**
Pixel-perfect precision. Static consistency.
Designers trained to create monuments.

**Required shift:**
From designing artifacts → to designing grammars
From pixel-perfect screens → to fluid compositions

We're designing conversations, not publications.

---

# ACT 4: THE PATH FORWARD (5 minutes)

## Slide 40: What Exists Today (45 sec)

What exists today?

**Mature Capabilities:**
- Generative UI code (LLMs write React/Flutter)
- Composable component architectures
- Secure execution environments
- Tool calling and structured data
- Context APIs (time, location, device state)

We have the building blocks.

You just saw it:
Flutter + Gemini + Schemas = Working demo

---

## Slide 41: Proof Point (15 sec)

This isn't vaporware.

Apple Research: "Ephemeral UIs"
You saw the travel demo.

It works today.

---

## Slide 42: Timeline (45 sec)

**TODAY:**
Simple context-aware interfaces

**1-2 YEARS:**
Sophisticated adaptation

**3-5 YEARS:**
Full paradigm maturity

**Honest assessment:**
We can build simple ephemeral interfaces today.
Full "breathing surfaces" paradigm — still evolving.

But the primitives exist.
The path is clear.

---

## Slide 43: Why Act Now (30 sec)

**[SHOW QUOTE]**

Dr. Michael Voit, Fraunhofer IOSB, 2024:
"Users will soon expect this individual support. Predefined and non-individualized menus will feel old-fashioned."

**[SHOW: Smart oven vs static app comparison]**

The smart oven already adapts to what you're cooking.
Your software doesn't.

---

## Slide 44: Two Paths (30 sec)

You have two paths:

**Lead Now:**
- Learn in practice
- Shape user expectations
- Define the category

**OR**

**Play Catch-Up:**
- Competitors define patterns
- Users expect it from them
- Harder to differentiate

---

## Slide 45: One Screen, One Context, Two States (15 sec)

The first step is simple:

**One screen.**
**One context signal.**
**Two states.**

**[Let this land]**

---

## Slide 46: Morning vs Evening Dashboard (30 sec)

**[SHOW: Split screen]**

Same dashboard.

**Morning:**
7-11 AM
- Minimal layout
- Next 3 actions
- High contrast
- "What's urgent?"

**Evening:**
6-10 PM
- Rich detail
- Tomorrow preview
- Relaxed colors
- "What to plan?"

One screen. Time as context. Two states.

---

## Slide 47: First Sprint (45 sec)

The first sprint:

1. Choose one high-traffic screen
2. Implement time-of-day adaptation
3. A/B test with 50% of users
4. Measure task completion, satisfaction
5. **Duration: 2 weeks**

Then expand:
- Add location awareness
- Apply to more screens
- Increase sophistication

**Start simple. Prove value. Build momentum.**

---

## Slide 48: 60 Years Arc (20 sec)

For 60 years:

Static interfaces.
Designed, shipped, unchanging.
Users forced to adapt.
Thinking interrupted.

---

## Slide 49: Now (20 sec)

Now:

Breathing surfaces.
Generated, adaptive, contextual.
Interfaces that understand.
Thinking flows continuously.

The future of computing doesn't interrupt thinking.

It breathes with it.

---

## Slide 50: Are You Ready? (30 sec)

**[LARGE, centered]**

Are you ready to build it?

**[Hold the question]**

Thank you.

**[Contact info visible]**

Leo Farias
@leoafarias (GitHub, Twitter/X)

Slides + Code:
https://github.com/leoafarias/gen-ui-talk

---

# Q&A PREPARATION

## Likely Questions & Responses:

**Q: "Isn't this just responsive design?"**
A: No. Responsive design adapts to screen size. This adapts to intent, context, and conversational state. The composition itself changes, not just the layout.

**Q: "What about users who want consistency?"**
A: Consistency in capability, not in surface. The underlying actions remain consistent. The presentation adapts. Plus, transparency + override mechanisms let users control this.

**Q: "Performance concerns with real-time generation?"**
A: Schema-driven architecture means you're composing pre-built components, not generating arbitrary UI code. It's fast. The travel demo you just saw runs in real-time.

**Q: "How do you test ephemeral interfaces?"**
A: Test the schema, test the context signals, test the composition logic. Same testing principles, different surface. Plus, you can snapshot-test generated configurations.

**Q: "Accessibility implications?"**
A: Huge opportunity. Screen readers get semantic structure from schemas. Adaptation can optimize for assistive tech. But yes, requires careful design.

**Q: "What about user control?"**
A: Critical. That's why transparency, override, and explainability are core principles. Users must be able to say "show me everything" or "lock this layout."

---

**END OF SPEAKER NOTES**

**Total: 30 minutes**
**Rehearsal Target: 28 minutes** (to allow buffer for audience engagement)
