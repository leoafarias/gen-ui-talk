import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../models/llm_function.dart';
import '../providers/gemini_provider.dart';

String get _kGeminiApiKey => dotenv.env['GEMINI_API_KEY'] as String;

enum GeminiModel {
  flash15('gemini-1.5-flash'),
  pro1('gemini-1.0-pro'),
  pro1001('gemini-1.0-pro-001'),
  pro15('gemini-1.5-pro'),
  flash15Latest('gemini-1.5-flash-latest'),
  flash158b('gemini-1.5-flash-8b'),
  pro15Latest('gemini-1.5-pro-latest');

  const GeminiModel(this.model);

  final String model;
}

final _baseSafetySettings = [
  SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
  SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
  SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
  SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
  SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
];

GeminiProvider buildGenerativeModel({
  List<Content>? history,
  List<LlmFunctionDeclaration> functions = const [],
  String systemInstruction = '',
  GenerationConfig? config,
}) {
  FunctionCallingConfig? functionConfig = FunctionCallingConfig(
    mode: FunctionCallingMode.none,
  );

  if (functions.isNotEmpty) {
    functionConfig = FunctionCallingConfig(
      mode: FunctionCallingMode.auto,
      // allowedFunctionNames: functions.map((e) => e.name).toSet(),
    );
  }

  return GeminiProvider(
    functionDeclarations: functions,
    history: history,
    model: GenerativeModel(
      model: GeminiModel.flash15Latest.model,
      apiKey: _kGeminiApiKey,
      safetySettings: _baseSafetySettings,
      tools: [
        Tool(
          functionDeclarations: functions
              .map(
                (e) => FunctionDeclaration(e.name, e.description, e.parameters),
              )
              .toList(),
        )
      ],
      toolConfig: ToolConfig(functionCallingConfig: functionConfig),
      generationConfig: config,
      systemInstruction: Content.system(systemInstruction),
    ),
  );
}
