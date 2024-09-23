---
---
{@section flex: 2}
{@column align: center tag: heading}
# Generative UI
# with Flutter

---
---
{@column align: center flex: 1}
#### Leo Farias
@leoafarias

{@column align: center_right}
- Founder/CEO/CTO
- Open Source Contributor
- Flutter & Dart GDE
- Passionate about UI/UX/DX


{@column}

---
---
{@column}

{@column align: center_left flex: 2}
> [!WARNING]  
> This presentation contains live AI-generated content. Unexpected things may occur during the demonstration.

{@column}

---
---
{@column flex: 2 align: center_right}
### Generative UI
{@column}
## VS
{@column flex: 2}
### AI Assisted Code Generation

---
---
### What is Generative UI?

{@column}

- LLMs are great at generating content based on context
- GUIs are great at providing structured, interactive interfaces for user input and navigation

---
---
# LLM ❤️ GUI

---
---
{@column}
{@column flex: 2 align: center}
Creates dynamic, context-aware UIs by interpreting actions and maintaining state with LLMs for fluid, interactive responses.

{@column}

---
---
### Benefits of UI over Chat

- More intuitive and user-friendly, especially for complex tasks
- Faster feedback loop between users and LLMs
- Enhances efficiency and interaction

---
---
{@column flex: 3 align: center}
### Flutter is Well-Suited for Generative UI
Built for any screen: Ideal for generating adaptive UIs across devices and platforms.
{@column}

---
---
## How can LLMs Understtand Your UI?

{@column tag: image}
![structured_output](assets/structured_output.png)

---
---
{@column}

## Structured Output
{@column}

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

final model = GenerativeModel(
  model: 'gemini-1.5-pro',
  apiKey: apiKey,
  generationConfig: GenerationConfig(
    responseMimeType: 'application/json',
    responseSchema: schema,
  ),
);

final prompt = 'List a few popular cookie recipes.';
final response = await model.generateContent([Content.text(prompt)]);

```

---
---
{@column}
### Color Palette Generator

Generate a color palette based on a given text.

- Name of the palette
- Font family
- Font color
- Color for each corner of the palette

---
---
{@column}
```dart
final schema = Schema.object(properties: {
  'name': Schema.string(
    description:'The text content to display on color palette. Format: #FF0000',
    nullable: false,
  ),
  'font': Schema.enumString(
    enumValues: ColorPaletteFontFamily.enumString,
    description: 'The font to use for the poster text.',
    nullable: false,
  ),
  'fontColor': Schema.string(
    description: 'The hex color value of the poster text. Format: #FF0000',
    nullable: false,
  ),
  'topLeftColor': Schema.string(
    description:'The hex color value top left corner of color palette. Format: #FF0000',
    nullable: false,
  ),
  'topRightColor': Schema.string(
    description:'The hex color value top right corner of color palette. Format: #FF0000',
    nullable: false,
  ),
  'bottomLeftColor': Schema.string(
    description:'The hex color value bottom left corner of color palette. Format: #FF0000',
    nullable: false,
  ),
  'bottomRightColor': Schema.string(
    description:'The hex color value bottom right corner of color palette. Format: #FF0000',
    nullable: false,
  )
}, requiredProperties: [
  'name',
  'font',
  'fontColor',
  'topLeftColor',
  'topRightColor',
  'bottomLeftColor',
  'bottomRightColor',
]);

```

---
style: 'demo'
---
{@widget name: colorPalette type: schema}

---
style: 'demo'
---
{@widget name: colorPalette type: widget}

---
---
## LLMs Orchestrate APIs

---
---
{@column align: center_right tag: heading flex: 3} 
### Gemini Function Calling
The Function Calling feature is in Beta release

{@section flex: 4 tag: image}
![llm tools](assets/llm_tools.png)

---
style: 'demo'
---
{@widget name: lightControl type: schema}

---
---
{@column align: bottom_right tag: heading}

### User Interaction
Natural Language way to interact with an LLM

{@column tag: image flex: 3}
![llm response](assets/llm_interaction.png)

---
---
{@column align: center_left tag: heading}
### Widget Response

{@column flex: 3 tag: image}
![widget_response](assets/widget_response.png)

---
style: 'demo'
---
{@widget name: lightControl type: widget}

---
---
## What if the tool to use is a widget schema?

---
---
### Experimental

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
      description: 'A list of colors pickers',
      items: ColorPickerDtoSchema.schema,
      nullable: true,
    ),
  });
```

---
style: 'demo'
---
{@widget name: widgetSchema type: widget}

---
---
## The future of UI might be orchestrating user experiences rather than creating it.

---
---
### Thank you

Leo Farias
@leoafarias
(GitHub, Twitter/X)
