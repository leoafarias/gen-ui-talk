import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../models/message.dart';
import '../providers/llm_provider_interface.dart';

class ChatController extends ChangeNotifier {
  final LlmProvider provider;
  final List<Message> _transcript = List.empty(growable: true);
  _LlmResponseListener? _currentResponse;
  UserMessage? _initialMessage;
  Timer? _updateTimer;

  List<Message> get transcript => List.unmodifiable(_transcript);
  bool isProcessing = false;

  ChatController({required this.provider});

  static ChatController of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<ChatControllerProvider>()!
      .notifier!;

  UserMessage? get initialMessage => _initialMessage;

  set initialMessage(UserMessage? message) {
    _initialMessage = message;
    notifyListeners();
  }

  Future<LlmMessage> sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) {
    return sendMessage(prompt, attachments: attachments, stream: true);
  }

  Future<LlmMessage> sendMessage(
    String prompt, {
    Iterable<Attachment> attachments = const [],
    bool stream = false,
  }) async {
    try {
      _initialMessage = null;
      isProcessing = true;
      final userMessage = UserMessage(prompt: prompt, attachments: attachments);

      final llmStreamableMessage = LlmStreamableMessage();
      _transcript.add(userMessage);

      if (stream) {
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
      } else {
        final result = await provider.sendMessage(
          userMessage.prompt,
          attachments: userMessage.attachments,
        );
        _transcript.add(result);

        return result;
      }
    } finally {
      isProcessing = false;
      _currentResponse = null;
      notifyListeners();
    }
  }

  void addSystemMessage(String prompt) {
    _transcript.add(SystemMesssage(prompt: prompt));
    notifyListeners();
  }

  void cancelMessage() {
    _currentResponse?.cancel();
    notifyListeners();
  }

  void editMessage(Message message) {
    assert(_currentResponse == null);

    // remove the last llm message
    assert(_transcript.last.origin.isLlm);
    _transcript.removeLast();

    // remove the last user message
    assert(_transcript.last.origin.isUser);
    final userMessage = _transcript.removeLast() as UserMessage?;

    // set the text of the controller to the last userMessage
    _initialMessage = userMessage;
    notifyListeners();
  }
}

class _LlmResponseListener {
  final LlmStreamableMessage message;
  final void Function(LlmStreamableMessage)? onDone;
  StreamSubscription<LlmMessagePart>? _subscription;
  final void Function(LlmStreamableMessage)? onUpdate;
  final Completer<LlmStreamableMessage> _completer =
      Completer<LlmStreamableMessage>();

  _LlmResponseListener({
    required Stream<LlmMessagePart> stream,
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

  Future<LlmMessage> wait() async {
    final result = await _completer.future;
    return result.finalize();
  }

  void cancel() => _handleClose(LlmMessageStatus.canceled);

  void _handleOnError(dynamic err) {
    message.append(LlmTextPart(text: 'ERROR: $err'));
    _handleClose(LlmMessageStatus.error);
    _completer.completeError(err);
  }

  void _handleOnDone() {
    onDone?.call(message);
    _completer.complete(message);
  }

  void _handleOnData(LlmMessagePart part) {
    message.append(part);
    onUpdate?.call(message);
  }

  void _handleClose(LlmMessageStatus status) {
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
  LlmProvider provider,
) {
  return use(_ChatControllerHook(provider));
}

class _ChatControllerHook extends Hook<ChatController> {
  final LlmProvider provider;

  const _ChatControllerHook(this.provider);

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
