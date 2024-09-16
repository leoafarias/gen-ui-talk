part of 'poster_designer.dart';

final _history = [
  Content.multi([
    TextPart('An inspirational poster\n'),
  ]),
  Content.model([
    TextPart(
        '```json\n{"bottomLeftColor": "#FFB07C", "posterColor": "#FFFFFF", "posterFont": "montserrat", "posterText": "Believe in Yourself", "topLeftColor": "#6EC1E4", "topRightColor": "#A37AC7", "bottomRightColor": "#FF758F"} \n```'),
  ]),
  Content.multi([
    TextPart('A futuristic poster\n'),
  ]),
  Content.model([
    TextPart(
        '```json\n{"bottomLeftColor": "#00BCD4", "posterColor": "#FFFFFF", "posterFont": "orbitron", "posterText": "Embrace Tomorrow", "topLeftColor": "#0D47A1", "topRightColor": "#4527A0", "bottomRightColor": "#1DE9B6"} \n```'),
  ]),
  Content.multi([
    TextPart('Minimalist Poster'),
  ]),
  Content.model([
    TextPart(
        '```json\n{"bottomLeftColor": "#E0E0E0", "posterColor": "#FFFFFF", "posterFont": "montserrat", "posterText": "Less is More", "topLeftColor": "#FFFFFF", "topRightColor": "#F0F0F0", "bottomRightColor": "#E0E0E0"} \n```'),
  ]),
  Content.multi([
    TextPart('vintage poster'),
  ]),
  Content.model([
    TextPart(
        '```json\n{"bottomLeftColor": "#CD853F", "posterColor": "#FFFFFF", "posterFont": "poppins", "posterText": "Explore the Classics", "topLeftColor": "#F5DEB3", "topRightColor": "#D2B48C", "bottomRightColor": "#CD853F"} \n```'),
    TextPart(
        '```json\n{"bottomLeftColor": "#CD853F", "posterColor": "#FFFFFF", "posterFont": "montserrat", "posterText": "Explore the Classics", "topLeftColor": "#F5DEB3", "topRightColor": "#D2B48C", "bottomRightColor": "#CD853F"} \n```'),
    TextPart(
        '```json\n{"bottomLeftColor": "#CD853F", "posterColor": "#FFFFFF", "posterFont": "poppins", "posterText": "Explore the Classics", "topLeftColor": "#F5DEB3", "topRightColor": "#D2B48C", "bottomRightColor": "#CD853F"} \n```'),
  ]),
  Content.multi([
    TextPart('Pink girly poster\n'),
  ]),
  Content.model([
    TextPart(
        '```json\n{"bottomLeftColor": "#FFB6C1", "posterColor": "#FFFFFF", "posterFont": "pacifico", "posterText": "Dream Big", "topLeftColor": "#FF69B4", "topRightColor": "#FFC0CB", "bottomRightColor": "#FFB6C1"} \n```'),
  ]),
];

final _posterDesignerToolConfig = ToolConfig(
  functionCallingConfig: FunctionCallingConfig(
    mode: FunctionCallingMode.none,
  ),
);

final posterDesignerProvider = GeminiProvider(
  model: GeminiModel.flash15Latest.model,
  apiKey: kGeminiApiKey,
  config: GenerationConfig(
    temperature: 0.5,
    topK: 64,
    topP: 0.95,
    maxOutputTokens: 8192,
    responseMimeType: 'application/json',
    responseSchema: _PosterDesignerDto.schema,
  ),
  systemInstruction: '''

You are a professional poster designer. Your job is to ensure that all design elements are cohesive, visually appealing, and adhere to best design practices.

A poster can have the following elements:

- **posterText**: Central message on the poster.
- **posterFont**: Font style for the text, defining the tone.
- **posterTextColor**: Hex color for the text, ensuring readability.
- **topLeftColor**: Hex color for the top-left corner, part of a mesh gradient.
- **topRightColor**: Hex color for the top-right corner, blending into the gradient.
- **bottomLeftColor**: Hex color for the bottom-left corner, contributing to the gradient.
- **bottomRightColor**: Hex color for the bottom-right corner, completing the gradient.

The four corner colors form a smooth mesh gradient to enhance the visual appeal.

''',
  history: _history,
);
