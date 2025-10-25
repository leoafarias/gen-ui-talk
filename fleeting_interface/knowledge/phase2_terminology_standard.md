# Phase 2.1: Terminology Standardization
**Establishing Single Binding Terms for All Concepts**

---

## METHODOLOGY

**Decision Framework:**
1. Check CLAUDE.md usage (highest authority)
2. Check if term appears in "Memorable Phrases" section (binding)
3. Check language audit (✅ vs ❌ rating)
4. Select most concrete, least poetic option
5. Document find/replace for all files

---

## TERMINOLOGY DECISIONS

### Decision #1: FLEETING vs EPHEMERAL (for main concept)

**Usage Analysis:**
- **CLAUDE.md**: Uses "Ephemeral Interface" primarily
- **Memorable Phrases**: "Ephemeral interfaces" appears multiple times
- **presentation_outline.md**: Uses both, but "Ephemeral Interface" in definitions
- **the_fleeting_interface.md**: Title uses "Fleeting" but content uses "Ephemeral"
- **presentation_flow_and_notes.md**: Uses both interchangeably

**Evidence:**
- CLAUDE.md Title:  "Fleeting Interface Presentation System Prompt"
- CLAUDE.md Content: "Ephemeral Interface" in Core Concepts
- CLAUDE.md Glossary: "**Ephemeral Interface**" as primary term

**CLAUDE.md defines:**
> **Ephemeral Interface**
> Transient cognitive surface materializing around intent, adapting as understanding deepens, dissolving when purpose fulfilled

**BINDING DECISION: "Ephemeral Interface"**

**Reasoning:**
- CLAUDE.md glossary uses "Ephemeral Interface" as the technical term
- "Fleeting" appears in title but "Ephemeral" is the defined concept
- "Ephemeral" is more precise (means "lasting a short time")
- "Fleeting" is more poetic, "Ephemeral" is more technical/academic

**Usage Rules:**
- **Primary term**: "Ephemeral Interface"
- **Acceptable variations**:
  - "Ephemeral UI" (in casual context)
  - "Ephemeral interfaces" (plural)
- **Do NOT use**:
  - "Fleeting Interface" (except in presentation title if already established)
  - "Temporary interface" (too vague)
  - "Transient UI" (unless in definition)

**Find/Replace:**
```
FIND: "Fleeting Interface" OR "fleeting interface"
REPLACE WITH: "Ephemeral Interface"
EXCEPTIONS: Presentation title, file names (don't change repo structure)
```

---

### Decision #2: EVERYONE TAX vs INTERFACE DEBT

**Usage Analysis:**
- **CLAUDE.md**: "Everyone Tax" appears 15+ times
- **CLAUDE.md Memorable Phrases**: "Everyone Tax - you pay for features built for others"
- **presentation_outline.md**: "Everyone Tax" consistently
- **the_fleeting_interface.md**: "Everyone Tax" primarily
- **presentation_flow_and_notes.md**: Uses BOTH "Everyone Tax" AND "Interface Debt"

**CLAUDE.md defines:**
> **Everyone Tax**
> Cognitive burden imposed by one-size-fits-all interfaces showing features built for others

**BINDING DECISION: "Everyone Tax"**

**Reasoning:**
- CLAUDE.md Memorable Phrases section (binding authority)
- More concrete and memorable
- Clearer concept (you pay for others' features)
- "Interface Debt" is too technical/jargony

**Usage Rules:**
- **Primary term**: "Everyone Tax"
- **Acceptable variations**:
  - "the Everyone Tax" (with article)
  - "pay the Everyone Tax"
- **Do NOT use**:
  - "Interface Debt"
  - "UI Debt"
  - "Cognitive debt"

**Find/Replace:**
```
FIND: "Interface Debt" OR "interface debt" OR "UI Debt" OR "UI debt"
REPLACE WITH: "Everyone Tax"
ALL FILES: No exceptions
```

---

### Decision #3: INTENT-DRIVEN vs INTENT-CENTRIC vs INTENT-BASED

**Usage Analysis:**
- **CLAUDE.md**: Uses ALL THREE in different contexts
  - "Intent-driven" for interface behavior
  - "Intent-centric" for paradigm/computing model
  - "Intent-based" occasionally
- **Memorable Phrases**: "Intent-driven composition"
- **Core Concepts**: "Intent-Driven (PRIMARY CONCEPT)"

**CLAUDE.md usage patterns:**
- "Intent-driven composition" (how interfaces work)
- "Intent-centric computing" (the paradigm)
- "Intent-based outcome specification" (the process)

**BINDING DECISION: CONTEXTUAL USE (not one-size-fits-all)**

**Standard Usage:**

1. **"Intent-Driven"** - For interface behavior and features
   - "Intent-driven composition"
   - "Intent-driven interface"
   - "Intent-driven approach"
   - Use when: Describing HOW interfaces compose

2. **"Intent-Centric"** - For paradigm and computing models
   - "Intent-centric computing"
   - "From application-centric to intent-centric"
   - "Intent-centric model"
   - Use when: Describing the PARADIGM SHIFT

3. **"Intent-Based"** - For specific processes
   - "Intent-based outcome specification"
   - Use when: Describing technical specifications

**Reasoning:**
- CLAUDE.md uses all three deliberately in different contexts
- "-driven" = active process (composition, features)
- "-centric" = paradigm, worldview (computing model)
- "-based" = foundation, specification
- Preserving distinction adds precision

**Usage Rules:**
- Check context before choosing
- Default to "intent-driven" for interfaces
- Use "intent-centric" for paradigm shift
- Use sparingly "intent-based" (technical contexts only)

**Find/Replace:**
NOT a simple find/replace - requires contextual review
```
AUDIT each usage and apply contextual rule:
- Interface/composition/features → "intent-driven"
- Paradigm/computing/model → "intent-centric"
- Specification/process → "intent-based"
```

---

### Decision #4: BREATHING SURFACES vs BREATHING INTERFACES

**Usage Analysis:**
- **CLAUDE.md**: "Breathing surfaces" appears in multiple sections
- **CLAUDE.md Glossary**: "**Breathing Surface**" as defined term
- **Memorable Phrases**: NOT in memorable phrases section
- **presentation_outline.md**: Uses "breathing surfaces" and "breathing interfaces"

**CLAUDE.md defines:**
> **Breathing Surface**
> Interface that lives and moves with cognition - appearing, adapting, dissolving naturally

**BINDING DECISION: "Breathing Surfaces"**

**Reasoning:**
- CLAUDE.md glossary term
- "Surface" is more abstract/cognitive (intentional)
- "Interface" is redundant (already talking about interfaces)
- "Surface" conveys the metaphor better (ephemeral workspace)

**USAGE RESTRICTIONS (From Language Audit):**
- ✅ Use maximum 3 times in entire presentation
- ⚠️ ALWAYS pair with concrete explanation
- Locations: Opening vision, Act 2 definition, Closing

**Usage Rules:**
- **Primary term**: "Breathing surfaces"
- **Usage**: Max 3 times, always with explanation
- **Pair with**: "Interfaces that appear, adapt, and dissolve as your needs change"
- **Do NOT**:
  - Use "breathing interfaces" (less precise)
  - Use without concrete follow-up
  - Overuse the metaphor

**Find/Replace:**
```
FIND: "breathing interfaces"
REPLACE WITH: "breathing surfaces"

THEN AUDIT: Ensure max 3 uses total
If >3 uses: Replace excess with "ephemeral interfaces" or concrete description
```

---

### Decision #5: COGNITIVE LOAD vs COGNITIVE BURDEN vs COGNITIVE REAL ESTATE

**Usage Analysis:**
- **CLAUDE.md**: Uses all three strategically
  - "Cognitive load" (technical psychology term)
  - "Cognitive burden" (impact on users)
  - "Cognitive real estate" (memorable metaphor)
- **Memorable Phrases**: "For 60 years, we fought for screen real estate. Now we fight for cognitive real estate."

**BINDING DECISION: CONTEXTUAL USE**

**Standard Usage:**

1. **"Cognitive load"** - Technical/psychological context
   - When citing research
   - Academic framing
   - Technical accuracy needed

2. **"Cognitive burden"** - User impact context
   - Everyone Tax creates cognitive burden
   - Burden of complexity
   - User-facing language

3. **"Cognitive real estate"** - Memorable metaphor
   - Use ONCE in memorable phrase (Act 1)
   - Don't repeat (loses impact)

**Usage Rules:**
- "Cognitive load" for technical credibility
- "Cognitive burden" for user empathy
- "Cognitive real estate" ONCE ONLY (opening memorable phrase)
- Do NOT mix randomly - choose based on context

**Find/Replace:**
NOT a simple find/replace - requires contextual review
```
AUDIT each usage:
- Research/technical → "cognitive load"
- User impact → "cognitive burden"
- Opening metaphor → "cognitive real estate" (ONCE)
```

---

### Decision #6: CONTEXT-DRIVEN vs CONTEXT-AWARE vs CONTEXTUAL

**Usage Analysis:**
- **CLAUDE.md**: "Context-Driven Adaptation" (Core Concept #4)
- **presentation_outline.md**: "Contextual awareness" in definition
- **the_fleeting_interface.md**: "Context-aware" and "contextual"

**BINDING DECISION: PRIMARY = "Context-Driven"**

**Standard Usage:**
- **"Context-driven"** - Primary term for the capability
  - "Context-driven adaptation"
  - "Context-driven composition"

- **"Contextual"** - Adjective form
  - "Contextual awareness"
  - "Contextual relevance"

- **AVOID**: "Context-aware" (too technical/IoT-sounding)

**Usage Rules:**
- Default to "context-driven" for features
- Use "contextual" as adjective
- Don't use "context-aware" (save for IoT/sensors)

**Find/Replace:**
```
FIND: "context-aware" OR "context aware"
REPLACE WITH: "context-driven" (for main concepts) OR "contextual" (for adjectives)
```

---

### Decision #7: CONVERSATION AS STATE vs CONVERSATIONAL STATE

**Usage Analysis:**
- **CLAUDE.md**: "Conversation as State" (section title)
- **Glossary**: "**Conversation as State** - Paradigm where interaction history and context serve as state machine"

**BINDING DECISION: "Conversation as State"**

**Reasoning:**
- CLAUDE.md glossary term (binding)
- "as" emphasizes the replacement/transformation
- "Conversational state" sounds like UI state, not paradigm

**Usage Rules:**
- **Primary term**: "Conversation as State"
- **Key phrase**: "Conversation history IS the state machine"
- **Do NOT use**: "conversational state", "conversation state", "conversational UI"

**Find/Replace:**
```
FIND: "conversational state" OR "conversation state"
REPLACE WITH: "Conversation as State"
```

---

### Decision #8: SCHEMA vs SCHEMA DEFINITION

**Usage Analysis:**
- Technical content uses both
- CLAUDE.md doesn't specify (implementation detail)

**BINDING DECISION: "Schema"** (simpler)

**Usage Rules:**
- "Schema" for the concept
- "Schema definition" when showing code
- Plural: "Schemas" (not "schemata" - too academic)

**Find/Replace:**
NOT needed - already mostly consistent
```
Verify: Plural is "schemas" not "schemata"
```

---

## COMPLETE TERMINOLOGY STANDARD

### Primary Terms (Binding):

| Concept | Standard Term | Alternatives to REPLACE | Usage Notes |
|---------|--------------|------------------------|-------------|
| Main paradigm | Ephemeral Interface | Fleeting Interface, Temporary Interface | Technical term |
| Core problem | Everyone Tax | Interface Debt, UI Debt | From Memorable Phrases |
| Metaphor | Breathing surfaces | Breathing interfaces | MAX 3 uses, pair with concrete |
| Paradigm shift | Intent-centric computing | N/A | For computing model |
| Interface behavior | Intent-driven | N/A | For composition/features |
| Process | Intent-based | N/A | Technical specs only |
| Core capability | Context-driven adaptation | Context-aware, Contextual adaptation | Primary feature term |
| Architecture | Conversation as State | Conversational state | Paradigm term |
| Cognitive impact (technical) | Cognitive load | N/A | Research/academic |
| Cognitive impact (user) | Cognitive burden | N/A | User-facing |
| Metaphor (opening) | Cognitive real estate | N/A | ONCE ONLY use |

---

## FIND/REPLACE EXECUTION PLAN

### File-by-File Changes:

#### ALL FILES:
1. "Fleeting Interface" → "Ephemeral Interface" (except titles/filenames)
2. "Interface Debt" OR "UI Debt" → "Everyone Tax"
3. "breathing interfaces" → "breathing surfaces"
4. "context-aware" → "context-driven" (for features) OR "contextual" (for adjectives)
5. "conversational state" → "Conversation as State"

#### presentation_flow_and_notes.md (specific issues):
- "Pure intention becoming reality" → "Express your intent, interface composes to match"
- "The end of manuals..." → "Interfaces that understand you - reducing need for manuals"
- Audit and limit "breathing surfaces" to max 2 uses in this file

#### the_fleeting_interface.md (needs most work):
- "Living, temporary experience" → "Temporary, intelligently composed interface"
- DELETE: "Computing becomes extension of human consciousness"
- DELETE: "Where boundary between thought and interface dissolves"
- "Context Fusion" → explain first, then name
- "Dynamic Materialization" → "AI selects relevant behaviors and generates interface"

#### imactful_quotes.md:
- REMOVE quotes about "consciousness" and "boundary dissolution"
- Keep only quotes with concrete language

---

## VALIDATION CHECKLIST

After find/replace, verify:
- [ ] "Ephemeral Interface" used consistently (not "Fleeting")
- [ ] "Everyone Tax" used consistently (not "Interface Debt")
- [ ] "Breathing surfaces" used max 3 times total
- [ ] "Intent-driven" used for interfaces, "intent-centric" for paradigm
- [ ] "Context-driven" used for adaptation capability
- [ ] "Conversation as State" used for architecture
- [ ] All poetic language paired with concrete explanations
- [ ] No remaining "consciousness" or "boundary dissolution" language

---

## NEXT PHASE DEPENDENCIES

**Phase 2.2 (Core Concepts Consolidation) will use:**
- These standardized terms exclusively
- No creation of new terminology
- All concepts referred to by standard names

**Phase 3 (Content Selection) will reference:**
- This document for correct terminology
- No deviations allowed in final slides

---

## COMPLETION STATUS

✅ All terminology conflicts identified
✅ Binding decisions made with CLAUDE.md authority
✅ Contextual usage rules established
✅ Find/replace plan documented
✅ Validation checklist created

**Ready for Phase 2.2: Core Concepts Consolidation**

---

## AUTHORITY HIERARCHY (For Future Decisions)

When terminology questions arise:
1. **CLAUDE.md Memorable Phrases** (highest authority)
2. **CLAUDE.md Glossary** (binding definitions)
3. **CLAUDE.md Core Concepts** (section names)
4. **Language Audit** (✅ vs ❌ rating)
5. **Concreteness principle** (concrete > abstract)

**This document is now the SINGLE SOURCE OF TRUTH for all terminology.**
