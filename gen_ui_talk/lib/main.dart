import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:superdeck/superdeck.dart';

import 'functions/color_palette/color_palette_page.dart';
import 'functions/color_palette_updatable/color_palette_updatable_page.dart';
import 'functions/light_control/light_control_page.dart';
import 'parts/background.dart';
import 'style.dart';

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
              options: DeckOptions(
                baseStyle: BaseStyle(),
                styles: {
                  'cover': CoverStyle(),
                  'demo': DemoStyle(),
                  'announcement': AnnouncementStyle(),
                  'quote': QuoteStyle(),
                },
                parts: const SlideParts(
                  background: BackgroundPart(),
                ),
                widgets: {
                  'lightControl': LightControlPage.new,
                  'colorPalette': ColorPalettePage.new,
                  'widgetSchema': ColorPaletteUpdatablePage.new,
                },
              ),
            ),
          );
        }),
  );
}
