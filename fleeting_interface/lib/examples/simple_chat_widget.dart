import 'package:flutter/material.dart';
import 'package:flutter_genui/flutter_genui.dart';
import 'package:logging/logging.dart';

import 'simple_chat/main.dart' as simple_chat;

class SimpleChatWidget extends StatefulWidget {
  const SimpleChatWidget({super.key});

  @override
  State<SimpleChatWidget> createState() => _SimpleChatWidgetState();
}

class _SimpleChatWidgetState extends State<SimpleChatWidget> {
  static bool _loggingConfigured = false;
  late final Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _initialize();
  }

  Future<void> _initialize() async {
    if (!_loggingConfigured) {
      configureGenUiLogging(level: Level.OFF);
      _loggingConfigured = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        return const simple_chat.ChatScreen();
      },
    );
  }
}
