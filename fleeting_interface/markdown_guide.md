# Markdown Authoring Guide

Superdeck turns Markdown into Flutter slide decks by translating block syntax into well-defined schema structures. Use this guide to author slides that render correctly, validate payloads, and keep the presentation narrative sharp.

## Slide Metadata (Front Matter)
- Slides start with YAML front matter that maps directly to `SlideOptions`.
- Supported keys: `title`, `style`, plus any custom arguments your deck reads at runtime.
- Speaker notes live in the generated JSON (`comments` array); they are not authored in front matter.

```markdown
---
title: Product Vision
style: overview
---
```

## Core Blocks and Their Schema Counterparts
All block directives resolve to typed block objects:

| Markdown Block | Schema `type` | Key Payload Fields |
| -------------- | ------------- | ------------------ |
| `@section`     | `section`     | `flex`, `scrollable`, `align`, `blocks[]` |
| `@column`      | `column`      | `flex`, `scrollable`, `align`, `content` (Markdown AST) |
| `@image`       | `image`       | `asset`, `fit`, `width`, `height` |
| `@dartpad`     | `dartpad`     | `id`, `theme`, `embed`, `run` |
| `@widget`      | `widget`      | `name`, custom args captured by your widget factory |

> **Validation Tip:** When generating or linting Markdown, assert that only the fields listed above are present so the builder passes validation.

## Layout Building Blocks

### `@section`
- Horizontal container that groups subsequent blocks; each `@section` becomes a `SectionBlock` with its own `flex`, `scrollable`, and optional `align` setting.
- Default `flex` is `1`. Increase the number to give a section more horizontal space relative to siblings.
- Keep one major section per slide unless you need asymmetrical bands.

```markdown
@section {
  align: center
  flex: 2
}
```

### `@column`
- Renders Markdown content inside a section and surfaces a parsed AST at `column.content` in the schema.
- Shared properties: `flex`, `align`, `scrollable` (defaults: `1`, `topLeft`, `false`).
- Use `flex` to weight columns (e.g., `flex: 3` main narrative vs. `flex: 1` supporting visuals).

```markdown
@column {
  flex: 2
  align: top_left
}

# Promise, Problem, Proof
- Lead with the outcome
- Contrast with the current state
- Finish with supporting data
```

### Alignment & Flex Reference
Valid `align` values are `topLeft`, `topCenter`, `topRight`, `centerLeft`, `center`, `centerRight`, `bottomLeft`, `bottomCenter`, `bottomRight`. The Markdown parser accepts both camelCase and snake_case; the project convention is the snake-case variants: `top_left`, `top_center`, `top_right`, `center_left`, `center`, `center_right`, `bottom_left`, `bottom_center`, `bottom_right`. Reject anything outside those names when templating content. Keep flex values positive numbers; treat `0` as invalid.

## Media & Interactive Blocks

### `@image`
- Accepts `asset` (string path or URL), optional `fit`, `width`, `height`, plus the shared block properties.
- During the build, `asset` is resolved to an object containing the hashed asset file (as described in the schema’s `Image Block`).
- Prefer high-resolution images sized for projection; use `fit: contain` for diagrams, `fit: cover` for hero imagery.

```markdown
@image {
  asset: assets/value-loop.png
  fit: contain
  height: 420
  align: center
}
```

### `@dartpad`
- Properties: `id` (required), `theme` (`light` or `dark`), `embed` (bool), `run` (bool). These map 1:1 to the DartPad block in the schema.
- Validate that IDs reference accessible DartPad snippets; missing IDs fail at runtime.

```markdown
@dartpad {
  id: "d7b09149b0843f2b9d09e081e3cfd5a3"
  theme: dark
  run: true
}
```

### `@widget`
- Resolves to a `widget` block with `name` populated from the directive (`@metricCard` → `name: "metricCard"`).
- Arguments stay as strings until your registered widget parser reads them via `DeckOptions.widgets`. Use the type-safe getters (`getString`, `getInt`, etc.) to enforce required fields and throw descriptive errors.

```markdown
@metricCard {
  label: Activation
  value: "72%"
  trend: up
}
```

## Authoring Markdown Content
- Headings follow standard Markdown; the schema captures them as AST nodes with tags (`h1`–`h6`). Stick to one `#` heading per slide so the title remains clear.
- Lists and tables render inside column blocks; they are represented as list/table nodes in the AST. Limit bullet lists to 3–5 concise items for pacing.
- GitHub alert syntax (`> [!TIP]`, `> [!WARNING]`, etc.) is parsed as blockquotes with custom classes. Ensure the keyword matches the supported set so styling resolves.
- Apply hero transitions or custom styling classes with the `{.class-name}` syntax. Pair identical class names across slides to animate elements smoothly.

```markdown
> [!WARNING]
> Keep the API quota slide in the appendix until numbers are final.
```

```markdown
# Roadmap {.hero-title}
![Diagram](assets/roadmap.png){.hero-visual}
```

## Mermaid Diagrams in Columns
- Author Mermaid code inside fenced blocks (` ```mermaid`). The build pipeline renders diagrams to PNG and rewrites the Markdown to an `img` element; in the full schema you will see an image asset reference (e.g., `.superdeck/assets/mermaid_*.png`).
- Re-run `melos run build_runner:build` after editing diagrams to regenerate cached assets.
- Use `classDef` to control colors and line weights; match the deck theme for consistency.

```markdown
```mermaid
graph TD
  classDef highlight fill:#6C5CE7,stroke:#2D1B69,color:#fff;
  Start --> Plan --> Build --> Ship
  Plan:::highlight --> Review
```
```

## Styling with `SlideStyle`
- Global typography, spacing, and block decorations come from `DeckOptions.baseStyle` and optional named variants (`styles` map). This mirrors the schema’s distinction between slide structure and presentation styling.
- Adjust headings (`h1`–`h6`), paragraphs, code blocks, and table styles via `TextStyler`, `MarkdownCodeblockStyle`, and `BoxStyler` to keep slides legible on large displays.
- Apply custom variants per slide through front matter: `style: recap` selects the corresponding entry in `DeckOptions.styles`.

## Validation Workflow
1. **Lint payloads** – Check each block for allowed keys and enumerate values (`align`, `fit`, booleans) before committing.
2. **Run builders** – `melos run build_runner:build` to refresh Mermaid assets and generated JSON.
3. **Analyze** – `melos run analyze` and `melos run custom_lint_analyze` catch schema mismatches and missing assets early.
4. **Visual review** – Open the deck in the FVM-pinned Flutter SDK to confirm flex sizing, alignment, and typography match expectations.

Use this guide alongside the project documentation to keep your Markdown accurate, validated, and presentation-ready.
