import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../models/content.dart';
import '../models/llm_response.dart';
import '../providers/ai_provider_interface.dart';

class ChatController extends ChangeNotifier {
  final LlmProvider provider;
  final TextEditingController editingController = TextEditingController();
  final bool streamResponse;

  final List<ContentBase> _transcript = List.empty(growable: true);
  _LlmResponseListener? _currentResponse;

  Timer? _updateTimer;

  List<ContentBase> get transcript => List.unmodifiable(_transcript);
  bool isProcessing = false;

  ChatController({
    required this.provider,
    this.streamResponse = true,
  });

  static ChatController of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<ChatControllerProvider>()!
      .notifier!;

  Future<LlmContent> send(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async {
    if (streamResponse) {
      return await _sendMessageStream(prompt, attachments: attachments);
    }
    return await _sendMessage(prompt, attachments: attachments);
  }

  Future<LlmContent> _sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async {
    try {
      isProcessing = true;

      final userMessage = UserContent(prompt: prompt, attachments: attachments);
      final llmStreamableMessage = LlmStreamableContent();
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

      print(isProcessing);

      return result;
    } finally {
      isProcessing = false;
      _currentResponse = null;
      print(isProcessing);
      notifyListeners();
    }
  }

  Future<LlmContent> _sendMessage(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async {
    try {
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

  void cancel() {
    _currentResponse?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _transcript.clear();
    editingController.dispose();

    _currentResponse?.cancel();
    _currentResponse = null;
    _updateTimer?.cancel();
    _updateTimer = null;
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

    notifyListeners();
  }
}

class _LlmResponseListener {
  final LlmStreamableContent message;
  final void Function(LlmStreamableContent)? onDone;
  StreamSubscription<LlmElement>? _subscription;
  final void Function(LlmStreamableContent)? onUpdate;
  final Completer<LlmStreamableContent> _completer =
      Completer<LlmStreamableContent>();

  _LlmResponseListener({
    required Stream<LlmElement> stream,
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

  Future<LlmContent> wait() async {
    final result = await _completer.future;
    return result.finalize();
  }

  void cancel() => _handleClose();

  void _handleOnError(dynamic err) {
    message.append(LlmTextElement(text: 'ERROR: $err'));
    _handleClose();
    _completer.completeError(err);
  }

  void _handleOnDone() {
    onDone?.call(message);
    _completer.complete(message);
  }

  void _handleOnData(LlmElement part) {
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

ChatController useChatController(
  LlmProvider provider, {
  bool streamResponse = false,
}) {
  return use(_ChatControllerHook(
    provider,
    streamResponse: streamResponse,
  ));
}

class _ChatControllerHook extends Hook<ChatController> {
  final LlmProvider provider;
  final bool streamResponse;

  const _ChatControllerHook(
    this.provider, {
    required this.streamResponse,
  });

  @override
  _ChatControllerHookState createState() {
    return _ChatControllerHookState();
  }
}

class _ChatControllerHookState
    extends HookState<ChatController, _ChatControllerHook> {
  late final _controller = ChatController(
    provider: hook.provider,
    streamResponse: hook.streamResponse,
  );

  @override
  ChatController build(BuildContext context) => _controller;
  @override
  void dispose() => _controller.dispose();
  @override
  String get debugLabel => 'useChatController';
}
