import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'ai/controllers/chat_controller.dart';
import 'ai/views/llm_chat_view.dart';
import 'functions/poster_designer/poster_designer.dart';

final kGeminiApiKey = dotenv.env['GEMINI_API_KEY'] as String;

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
        home: const PosterDesignPage(),
      );
}

class ChatPage extends HookWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useChatController(posterDesignerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(App.title)),
      body: LlmChatView(controller: controller),
    );
  }
}

class PosterDesignPage extends StatelessWidget {
  const PosterDesignPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(App.title)),
      body: const PosterDesignerWidget(),
    );
  }
}
