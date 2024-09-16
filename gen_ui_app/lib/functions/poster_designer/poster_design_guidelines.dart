import 'package:google_generative_ai/google_generative_ai.dart';

import '../../ai/providers/providers.dart';
import '../../main.dart';

final _model = GenerativeModel(
  model: GeminiModel.flash15Latest.model,
  apiKey: kGeminiApiKey,
  generationConfig: GenerationConfig(
    temperature: 1,
    topK: 64,
    topP: 0.95,
    maxOutputTokens: 1024,
  ),
  systemInstruction: Content.system(
      'You are a professional poster designer. Your job is to ensure that all design elements are cohesive, visually appealing, and adhere to best design practices.\n\nA poster can have the following attributes:\n\n- **posterText**: Central message on the poster.\n- **posterFont**: Font style for the text, defining the tone.\n- **posterTextColor**: Hex color for the text, ensuring readability.\n- **topLeftColor**: Hex color for the top-left corner, part of a mesh gradient.\n- **topRightColor**: Hex color for the top-right corner, blending into the gradient.\n- **bottomLeftColor**: Hex color for the bottom-left corner, contributing to the gradient.\n- **bottomRightColor**: Hex color for the bottom-right corner, completing the gradient.\n\nThe four corner colors form a smooth mesh gradient to enhance the visual appeal.'),
);

final _chatHistory = [
  Content.multi([
    TextPart('An inspirational poster\n'),
  ]),
  Content.model([
    TextPart(
        'Poster Text:\n\nClear, simple, and universally inspirational message.\n"Believe in Yourself"\nFont:\n\nHighly readable, modern, and impactful sans-serif font.\nMontserrat Bold\nText Color:\n\nHigh contrast against the background, symbolizing clarity and positivity.\nWhite (#FFFFFF)\nTop-Left Color:\n\nRepresents trust and serenity, setting a calm and inviting tone.\nSoft Blue (#6EC1E4)\nTop-Right Color:\n\nBlends smoothly with soft blue, adding a creative and imaginative touch.\nLight Purple (#A37AC7)\nBottom-Left Color:\n\nIntroduces warmth and optimism, balancing the cooler tones above.\nPeach (#FFB07C)\nBottom-Right Color:\n\nComplements peach, enhancing the vibrant and energetic feel of the design.\nCoral Pink (#FF758F)'),
  ]),
  Content.multi([
    TextPart('A futuristic poster\n'),
  ]),
  Content.model([
    TextPart(
        'Poster Text:\n\nClear, concise, and evocative of innovation, progress, and optimism about the future.\n"Embrace Tomorrow"\nFont:\n\nModern, sleek, and technological, with geometric shapes and sharp lines.\nOrbitron Bold\nText Color:\n\nHigh contrast, vibrant, and associated with digital interfaces and technology.\nCyan (#00FFFF)\nTop-Left Color:\n\nRepresents intelligence, trust, and stability, setting a solid foundation for the gradient.\nDeep Blue (#0D47A1)\nTop-Right Color:\n\nBlends smoothly with deep blue, adding depth and a dynamic quality to the background.\nVivid Indigo (#4527A0)\nBottom-Left Color:\n\nComplements the cooler tones above while adding luminosity and energy.\nBright Cyan (#00BCD4)\nBottom-Right Color:\n\nBlends seamlessly with bright cyan, enhancing the modern and innovative feel.\nTurquoise (#1DE9B6)'),
  ]),
  Content.multi([
    TextPart('Minimalist Poster'),
  ]),
  Content.model([
    TextPart(
        'Poster Text:\n\nStraightforward, uncluttered, and conveys a strong message about simplicity and restraint.\n"Less is More"\nFont:\n\nClean, modern, and elegant, without unnecessary embellishments.\nHelvetica Neue Light\nText Color:\n\nAligns with minimalistic themes, offers strong contrast, and maintains understated elegance.\nBlack (#000000)\nTop-Left Color:\n\nProvides a clean and uncluttered backdrop, essential for minimalistic designs.\nWhite (#FFFFFF)\nTop-Right Color:\n\nIntroduces a slight variation to add depth without compromising minimalism.\nLight Gray (#F0F0F0)\nBottom-Left Color:\n\nContinues the neutral theme, blends smoothly with white and light gray, and maintains simplicity.\nSoft Gray (#E0E0E0)'),
  ]),
  Content.multi([
    TextPart('vintage poster'),
  ]),
  Content.model([
    TextPart(
        'Poster Text:\n\nEvokes a sense of the past, suggests a journey, and complements the retro aesthetic.\n"Explore the Classics"\nFont:\n\nReflects vintage typography, has elegant and ornate features, and ensures readability.\nPlayfair Display Bold\nText Color:\n\nOffers a rich, earthy hue that complements vintage aesthetics and provides sufficient contrast.\nSaddle Brown (#8B4513)\nTop-Left Color:\n\nA soft, muted color that evokes a sense of the past and provides a warm foundation for the gradient.\nWheat (#F5DEB3)\nTop-Right Color:\n\nBlends smoothly with wheat, adds depth and richness, and enhances the vintage feel.\nTan (#D2B48C)\nBottom-Left Color:\n\nOffers a deep, earthy tone that complements the warm palette and conveys a sense of enduring tradition.\nPeru (#CD853F)'),
  ]),
  Content.multi([
    TextPart('a pink girly poster'),
  ]),
  Content.model([
    TextPart(
        'Poster Text:\n\nSweet, playful, and speaks to a feminine audience.\n"Dream Big, Sparkle Bright" \nFont:\n\nElegant, playful, and feminine, with a touch of whimsy.\nPacifico\nText Color:\n\nProvides a strong contrast against the pink background, representing a sense of fun and energy.\nWhite (#FFFFFF)\nTop-Left Color:\n\nRepresents femininity, sweetness, and playfulness, setting the tone for the design.\nLight Pink (#FFB6C1)\nTop-Right Color:\n\nBlends smoothly with light pink, adds a touch of vibrancy, and further enhances the girly aesthetic.\nRose Pink (#F08080)\nBottom-Left Color:\n\nProvides a deeper, richer shade of pink, adding depth and visual interest to the gradient.\nHot Pink (#FF69B4)\nBottom-Right Color:\n\nComplements hot pink, creating a vibrant and energetic feel, perfect for a girly poster.\nMagenta (#FF00FF) \n'),
  ]),
];

Future<String> generateDesignGuideline(String prompt) async {
  final chat = _model.startChat(history: _chatHistory);

  final content = Content.text(prompt);

  final response = await chat.sendMessage(content);

  return response.text ?? '';
}
