import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'functions/light_control/light_control_page.dart';
import 'functions/quote_designer/quote_designer_example.dart';

String get kGeminiApiKey => dotenv.env['GEMINI_API_KEY'] as String;

void main(List<String> args) async {
  return runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  static const title = 'Example: Google Gemini AI';

  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: dotenv.load(fileName: ".env"),
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState == ConnectionState.waiting;

          return MaterialApp(
            theme: ThemeData.dark(),
            title: title,
            home: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const LightControlPage(),
          );
        });
  }
}

class PosterDesignPage extends StatelessWidget {
  const PosterDesignPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(ExampleApp.title)),
      body: const QuoteDesignerExample(),
    );
  }
}
