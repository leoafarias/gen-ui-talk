import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'ai/models/message.dart';
import 'ai/providers/gemini_provider.dart';
import 'ai/views/llm_chat_view.dart';
import 'functions/set_light_values.dart';

void main(List<String> args) async {
  await dotenv.load(fileName: ".env");
  return runApp(const App());
}

class App extends StatelessWidget {
  static const title = 'Example: Google Gemini AI';

  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData.dark(),
        title: title,
        home: const ChatPage(),
      );
}

final safetySettings = [
  SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
  SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
  SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
  SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
  SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
];

Widget functionResponseBuilder(LlmFunctionResponse response) {
  return const Text('Function response');
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        body: LlmChatView(
          provider: GeminiProvider(
            safetySettings: safetySettings,
            functions: [setLightValuesFunction],
            model: GeminiModel.flash15Latest.model,
            toolConfig: ToolConfig(
              functionCallingConfig: FunctionCallingConfig(
                mode: FunctionCallingMode.auto,
                // allowedFunctionNames: functions.toAllowedFunctionNames(),
              ),
            ),
            systemInstruction: 'You are a friendly assistant.',
            config: GenerationConfig(),
            apiKey: dotenv.env['GEMINI_API_KEY'] as String,
          ),
        ),
      );
}

enum GeminiModel {
  flash15('gemini-1.5-flash'),
  pro1('gemini-1.0-pro'),
  pro1001('gemini-1.0-pro-001'),
  pro15('gemini-1.5-pro'),
  flash15Latest('gemini-1.5-flash-latest'),
  pro15Latest('gemini-1.5-pro-latest');

  const GeminiModel(this.model);

  final String model;
}
