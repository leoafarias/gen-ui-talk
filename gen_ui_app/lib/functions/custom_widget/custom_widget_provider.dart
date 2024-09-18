import 'package:google_generative_ai/google_generative_ai.dart';

import '../../ai/providers/gemini_provider.dart';
import '../../main.dart';

final customWidgetProvider = GeminiProvider(
  model: GeminiModel.flash15Latest.model,
  apiKey: kGeminiApiKey,
  config: GenerationConfig(
    responseMimeType: 'application/json',
    // responseSchema: ColorPaletteDto.schema,
  ),
);
