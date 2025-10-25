import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:superdeck/superdeck.dart';

import 'examples/flutter_genui_chat_demo.dart';
import 'examples/smart_oven_widget.dart';
import 'examples/tool_bar_example_widget.dart';
import 'examples/toolbar_demo.dart';
import 'firebase_options.dart';
import 'parts/background.dart';
import 'parts/footer.dart';
import 'parts/header.dart';
import 'style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable semantics for testing
  WidgetsBinding.instance.ensureSemantics();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
                'fullscreen': fullscreenStyle(),
              },
              widgets: {
                'smart_oven': (params) => SmartOven(
                  chat: params['chat'] == true,
                  suggestedPrompts: params['prompts'] != null
                      ? List<String>.from(params['prompts'] as List)
                      : const [
                          'Crispy thin crust pizza',
                          'Soft chocolate chip cookies',
                          'Well-done chicken wings',
                        ],
                ),
                'tool_bar_example': (_) => const ToolBarExampleWidget(),
                'toolbar_demo': (params) => ToolbarDemo(
                  all: params['all'] == true,
                  chat: params['chat'] != false,
                ),
                'flutter_gen_ui_chat': (_) => const FlutterGenUiChatDemo(),
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
