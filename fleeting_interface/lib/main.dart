import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:superdeck/superdeck.dart';

import 'examples/travel_example_widget.dart';
import 'firebase_options.dart';
import 'parts/background.dart';
import 'parts/footer.dart';
import 'parts/header.dart';
import 'style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable semantics for testing
  WidgetsBinding.instance.ensureSemantics();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    providerApple: const AppleDebugProvider(),
    providerAndroid: const AndroidDebugProvider(),
    providerWeb: ReCaptchaV3Provider('debug'),
  );
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
              widgets: {
                'travel_example': (_) => const TravelExampleWidget(),
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
