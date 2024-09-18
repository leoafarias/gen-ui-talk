import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'functions/light_control/light_control_page.dart';

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
            debugShowCheckedModeBanner: false,
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
