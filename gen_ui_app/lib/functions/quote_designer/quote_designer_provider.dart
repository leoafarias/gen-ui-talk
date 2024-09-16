import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../ai/providers/gemini_provider.dart';
import '../../main.dart';
import 'quote_designer_dto.dart';

final _history = [
  Content.text('inspirational'),
  Content.model([
    TextPart(QuoteDesignDto(
      quoteTextColor: Colors.white,
      bottomLeftColor: const Color(0xFFFFB07C),
      quoteTextFontWeight: QuoteTextFontWeight.bold,
      quoteTextShadowColor: const Color(0xFF8B4513),
      quoteTextFont: QuoteTextFontFamily.montserrat,
      quote: 'Believe in Yourself',
      topLeftColor: const Color(0xFF6EC1E4),
      topRightColor: const Color(0xFFA37AC7),
      bottomRightColor: const Color(0xFFFF758F),
    ).toJson()),
  ]),
  Content.text('The future'),
  Content.model([
    TextPart(QuoteDesignDto(
      quote: 'Embrace Tomorrow',
      quoteTextFont: QuoteTextFontFamily.orbitron,
      quoteTextFontWeight: QuoteTextFontWeight.bold,
      quoteTextColor: const Color.fromARGB(255, 1, 32, 189),
      quoteTextShadowColor: const Color.fromARGB(255, 23, 5, 69),
      topLeftColor: const Color.fromARGB(255, 1, 157, 234),
      topRightColor: const Color(0xFF4527A0),
      bottomRightColor: const Color.fromARGB(255, 0, 169, 143),
      bottomLeftColor: const Color.fromARGB(255, 0, 212, 134),
    ).toJson()),
  ]),
  Content.text('courage'),
  Content.model([
    TextPart(QuoteDesignDto(
      quote: 'Courage is Contagious',
      quoteTextFont: QuoteTextFontFamily.poppins,
      quoteTextFontWeight: QuoteTextFontWeight.bold,
      quoteTextColor: const Color(0xFFFFFFFF),
      quoteTextShadowColor: const Color(0xFF8B0000),
      topLeftColor: const Color(0xFFB22222),
      topRightColor: const Color(0xFFDC143C),
      bottomRightColor: const Color(0xFFCD5C5C),
      bottomLeftColor: const Color(0xFFF08080),
    ).toJson()),
  ]),
  Content.text('sweet'),
  //Use a bubble gum color palette
  Content.model([
    TextPart(QuoteDesignDto(
      quote: 'Life is Sweet',
      quoteTextFont: QuoteTextFontFamily.poppins,
      quoteTextFontWeight: QuoteTextFontWeight.bold,
      quoteTextColor: const Color(0xFFFFFFFF),
      quoteTextShadowColor: const Color(0xFF8B0000),
      topLeftColor: const Color(0xFFB22222),
      topRightColor: const Color(0xFFDC143C),
      bottomRightColor: const Color(0xFFCD5C5C),
      bottomLeftColor: const Color(0xFFF08080),
    ).toJson()),
  ]),

  //Use a bubble gum color palette
];
final quoteDesignProvider = GeminiProvider(
  model: GeminiModel.flash15Latest.model,
  apiKey: kGeminiApiKey,
  config: GenerationConfig(
    temperature: 0.5,
    topK: 64,
    topP: 0.95,
    maxOutputTokens: 8192,
    responseMimeType: 'application/json',
    responseSchema: QuoteDesignDto.schema,
  ),
  systemInstruction: '''
You are a professional poster designer. Your job is to ensure that all design elements are cohesive, visually appealing, and adhere to best design practices.

A poster can have the following elements:

- quote: The text content to display on the poster.
- quoteTextFont: The font family for the quote text.
- quoteTextFontWeight: The font weight for the quote text.
- quoteTextColor: The color for the quote text.
- quoteTextShadowColor: The color for the quote text shadow.
- topLeftColor: The color for the top-left corner of the poster.
- topRightColor: The color for the top-right corner of the poster.
- bottomLeftColor: The color for the bottom-left corner of the poster.
- bottomRightColor: The color for the bottom-right corner of the poster.

The poster should have a smooth gradient from the top-left corner to the bottom-right corner.
''',
  history: _history,
);
