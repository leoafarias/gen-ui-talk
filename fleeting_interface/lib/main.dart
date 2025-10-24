import 'package:flutter/material.dart';
import 'package:superdeck/superdeck.dart';

import 'parts/background.dart';
import 'parts/footer.dart';
import 'parts/header.dart';
import 'style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable semantics for testing
  WidgetsBinding.instance.ensureSemantics();

  await SuperDeckApp.initialize();
  runApp(
    Builder(
      builder: (context) {
        return MaterialApp(
          title: 'Generative UI Presentation',
          debugShowCheckedModeBanner: false,
          showSemanticsDebugger: false,
          home: SuperDeckApp(
            options: DeckOptions(
              baseStyle: borderedStyle(),
              styles: {
                'announcement': announcementStyle(),
                'quote': quoteStyle(),
                'cover': coverStyle(),
              },
              parts: const SlideParts(
                header: HeaderPart(),
                footer: FooterPart(),
                background: BackgroundPart(),
              ),
            ),
          ),
        );
      },
    ),
  );
}
