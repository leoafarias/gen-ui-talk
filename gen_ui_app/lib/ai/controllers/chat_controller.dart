import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../models/message.dart';
import '../providers/gemini_provider.dart';
import '../providers/llm_provider_interface.dart';

class ChatController extends ChangeNotifier {
  final LlmProvider provider;
  final List<Message> _transcript = [];
  _LlmResponseListener? _currentResponse;
  UserMessage? _initialMessage;
  Timer? _updateTimer;

  List<Message> get transcript => List.unmodifiable(_transcript);
  bool get isProcessing => _currentResponse != null;

  ChatController({required this.provider});

  static ChatController of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<ChatControllerProvider>()!
      .notifier!;

  UserMessage? get initialMessage => _initialMessage;

  set initialMessage(UserMessage? message) {
    _initialMessage = message;
    notifyListeners();
  }

  GeminiProvider get geminiProvider => provider as GeminiProvider;

  Future<void> submitMessage(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async {
    _initialMessage = null;

    final userMessage = UserMessage(prompt: prompt, attachments: attachments);
    final llmMessage = LlmStreamMessage();

    _transcript.addAll([userMessage, llmMessage]);
    notifyListeners();

    _currentResponse = _LlmResponseListener(
      stream: provider.sendMessageStream(prompt, attachments: attachments),
      message: llmMessage,
      onDone: _onDone,
      onUpdate: _onUpdate,
    );
  }

  void _onUpdate() {
    if (_updateTimer?.isActive ?? false) return;
    _updateTimer = Timer(const Duration(milliseconds: 150), () {
      notifyListeners();
    });
  }

  void _onDone(LlmStreamMessage message) {
    _currentResponse = null;

    final llmMessage = message.finalize();

    // finalize in place the last item int he list
    _transcript[_transcript.length - 1] = llmMessage;

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
  final LlmStreamMessage message;
  final void Function(LlmStreamMessage)? onDone;
  StreamSubscription<LlmMessagePart>? _subscription;
  final void Function()? onUpdate;

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

  void cancel() => _handleClose(LlmMessageStatus.canceled);
  void _handleOnError(dynamic err) {
    message.append(LlmTextPart(text: 'ERROR: $err'));
    _handleClose(LlmMessageStatus.error);
  }

  void _handleOnDone() {
    onDone?.call(message);
  }

  void _handleOnData(LlmMessagePart part) {
    message.append(part);
    onUpdate?.call();
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

ChatController useChatController() {
  final context = useContext();
  return ChatController.of(context);
}
