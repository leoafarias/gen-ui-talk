import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../models/ai_response.dart';
import '../models/content.dart';
import '../providers/ai_provider_interface.dart';

class ChatController extends ChangeNotifier {
  final AiProvider provider;

  final List<ContentBase> _transcript = List.empty(growable: true);
  _LlmResponseListener? _currentResponse;
  UserContent? _initialMessage;
  Timer? _updateTimer;

  List<ContentBase> get transcript => List.unmodifiable(_transcript);
  bool isProcessing = false;

  ChatController({
    required this.provider,
  });

  static ChatController of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<ChatControllerProvider>()!
      .notifier!;

  UserContent? get initialMessage => _initialMessage;

  set initialMessage(UserContent? message) {
    _initialMessage = message;
    notifyListeners();
  }

  Future<AiContent> _sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async {
    try {
      _initialMessage = null;
      isProcessing = true;
      final userMessage = UserContent(prompt: prompt, attachments: attachments);
      final llmStreamableMessage = AiStreamableContent();
      _transcript.add(llmStreamableMessage);
      notifyListeners();
      _currentResponse = _LlmResponseListener(
        stream: provider.sendMessageStream(userMessage.prompt,
            attachments: userMessage.attachments),
        message: llmStreamableMessage,
        onDone: (payload) {
          // _transcript[_transcript.length - 1] = payload.finalize();
        },
        onUpdate: (payload) {
          if (_updateTimer?.isActive ?? false) return;
          _updateTimer = Timer(const Duration(milliseconds: 10), () {
            notifyListeners();
          });
        },
      );

      final result = await _currentResponse!.wait();

      _transcript[_transcript.length - 1] = result;

      return result;
    } finally {
      isProcessing = false;
      _currentResponse = null;
      notifyListeners();
    }
  }

  Future<AiContent> sendMessage(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async {
    try {
      // return _sendMessageStream(prompt, attachments: attachments);
      _initialMessage = null;
      isProcessing = true;
      final userMessage = UserContent(prompt: prompt, attachments: attachments);

      _transcript.add(userMessage);
      notifyListeners();

      final result = await provider.sendMessage(
        userMessage.prompt,
        attachments: userMessage.attachments,
      );
      _transcript.add(result);

      return result;
    } finally {
      isProcessing = false;
      _currentResponse = null;
      notifyListeners();
    }
  }

  void addSystemMessage(String prompt) {
    _transcript.add(SystemContent(prompt: prompt));
    notifyListeners();
  }

  void cancelMessage() {
    _currentResponse?.cancel();
    notifyListeners();
  }

  void editMessage(ContentBase message) {
    assert(_currentResponse == null);

    // remove the last llm message
    assert(_transcript.last.origin.isLlm);
    _transcript.removeLast();

    // remove the last user message
    assert(_transcript.last.origin.isUser);
    final userMessage = _transcript.removeLast() as UserContent?;

    // set the text of the controller to the last userMessage
    _initialMessage = userMessage;
    notifyListeners();
  }
}

class _LlmResponseListener {
  final AiStreamableContent message;
  final void Function(AiStreamableContent)? onDone;
  StreamSubscription<AiElement>? _subscription;
  final void Function(AiStreamableContent)? onUpdate;
  final Completer<AiStreamableContent> _completer =
      Completer<AiStreamableContent>();

  _LlmResponseListener({
    required Stream<AiElement> stream,
    required this.message,
    this.onDone,
    this.onUpdate,
  }) {
    _subscription = stream.listen(
      _handleOnData,
      onDone: _handleOnDone,
      cancelOnError: true,
      onError: _handleOnError,
    );
  }

  Future<AiContent> wait() async {
    final result = await _completer.future;
    return result.finalize();
  }

  void cancel() => _handleClose();

  void _handleOnError(dynamic err) {
    message.append(AiTextElement(text: 'ERROR: $err'));
    _handleClose();
    _completer.completeError(err);
  }

  void _handleOnDone() {
    onDone?.call(message);
    _completer.complete(message);
  }

  void _handleOnData(AiElement part) {
    message.append(part);
    onUpdate?.call(message);
  }

  void _handleClose() {
    assert(_subscription != null);
    _subscription!.cancel();
    _subscription = null;

    onDone?.call(message);
  }
}

class ChatControllerProvider extends InheritedNotifier<ChatController> {
  const ChatControllerProvider({
    super.key,
    required super.notifier,
    required super.child,
  });
}

ChatController useChatController(AiProvider provider) {
  return use(_ChatControllerHook(
    provider,
  ));
}

class _ChatControllerHook extends Hook<ChatController> {
  final AiProvider provider;

  const _ChatControllerHook(
    this.provider,
  );

  @override
  _ChatControllerHookState createState() {
    return _ChatControllerHookState();
  }
}

class _ChatControllerHookState
    extends HookState<ChatController, _ChatControllerHook> {
  late final _controller = ChatController(
    provider: hook.provider,
  );

  @override
  ChatController build(BuildContext context) => _controller;
  @override
  void dispose() => _controller.dispose();
  @override
  String get debugLabel => 'useChatController';
}
