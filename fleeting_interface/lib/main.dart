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
import 'web_loader_stub.dart'
    if (dart.library.js_interop) 'web_loader_web.dart';

const _webRecaptchaEnterpriseSiteKey = String.fromEnvironment(
  'FIREBASE_APP_CHECK_SITE_KEY',
  defaultValue: '6LcWJZUsAAAAADx2fvZGmbBgoz6unOVmA4teI8Co',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WidgetsBinding.instance.ensureSemantics();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _activateFirebaseAppCheck();
  await SuperDeckApp.initialize();
  runApp(
    SuperDeckApp(
      options: DeckOptions(
        baseStyle: borderedStyle(),
        styles: {
          'announcement': announcementStyle(),
          'quote': quoteStyle(),
          'cover': coverStyle(),
          'fullscreen': fullscreenStyle(),
        },
        widgets: {
          'smart_oven': _smartOvenFactory,
          'tool_bar_example': (_) => const ToolBarExampleWidget(),
          'toolbar_demo': _toolbarDemoFactory,
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
  scheduleHideWebLoader();
}

Future<void> _activateFirebaseAppCheck() {
  return FirebaseAppCheck.instance.activate(
    providerApple: const AppleDebugProvider(),
    providerAndroid: const AndroidDebugProvider(),
    providerWeb: ReCaptchaEnterpriseProvider(_webRecaptchaEnterpriseSiteKey),
  );
}

Widget _smartOvenFactory(Map<String, Object?> args) {
  return SmartOven(
    chat: args['chat'] == true,
    suggestedPrompts: args['prompts'] != null
        ? List<String>.from(args['prompts'] as List)
        : const [
            'Crispy thin crust pizza',
            'Soft chocolate chip cookies',
            'Well-done chicken wings',
          ],
  );
}

Widget _toolbarDemoFactory(Map<String, Object?> args) {
  return ToolbarDemo(all: args['all'] == true, chat: args['chat'] != false);
}
