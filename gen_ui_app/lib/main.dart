import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:superdeck/superdeck.dart';

import 'functions/color_palette/color_palette_page.dart';
import 'functions/light_control/light_control_page.dart';
import 'parts/background.dart';
import 'parts/footer.dart';
import 'parts/header.dart';
import 'style.dart';

String get kGeminiApiKey => dotenv.env['GEMINI_API_KEY'] as String;

void main() async {
  await SuperDeckApp.initialize();
  runApp(
    FutureBuilder(
        future: dotenv.load(fileName: ".env"),
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState == ConnectionState.waiting;
          if (isLoading) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }

          return MaterialApp(
            title: 'Superdeck',
            debugShowCheckedModeBanner: false,
            home: SuperDeckApp(
              baseStyle: BaseStyle(),
              styles: {
                'cover': CoverStyle(),
                'demo': DemoStyle(),
                'announcement': AnnouncementStyle(),
                'quote': QuoteStyle(),
                'show_sections': ShowSectionsStyle(),
              },
              background: const BackgroundPart(),
              header: const HeaderPart(),
              footer: const FooterPart(),
              widgets: {
                'lightControl': (context, options) => LightControlPage(options),
                'colorPalette': (context, options) => ColorPalettePage(options),
              },
            ),
          );
        }),
  );
}
