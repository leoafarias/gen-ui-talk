import 'dart:async';

import 'package:flutter/foundation.dart'; // For ChangeNotifier

import '../models/message.dart';
import '../providers/llm_provider_interface.dart';

class ChatController extends ChangeNotifier {
  final LlmProvider provider;
  final List<Message> _transcript = [];
  _LlmResponse? _currentResponse;
  UserMessage? _initialMessage;
  Timer? _updateTimer;

  List<Message> get transcript => List.unmodifiable(_transcript);
  bool get isProcessing => _currentResponse != null;

  ChatController({required this.provider});

  UserMessage? get initialMessage => _initialMessage;

  set initialMessage(UserMessage? message) {
    _initialMessage = message;
    notifyListeners();
  }

  Future<void> submitMessage(
      String prompt, Iterable<Attachment> attachments) async {
    _initialMessage = null;

    final userMessage = UserMessage(prompt: prompt, attachments: attachments);
    final llmMessage = LlmMessage();

    _transcript.addAll([userMessage, llmMessage]);
    notifyListeners();

    _currentResponse = _LlmResponse(
      stream: provider.generateStream(prompt, attachments: attachments),
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

  void _onDone() {
    _currentResponse = null;
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

class _LlmResponse {
  final LlmMessage message;
  final void Function()? onDone;
  StreamSubscription<LlmResponse>? _subscription;
  final void Function()? onUpdate;

  _LlmResponse({
    required Stream<LlmResponse> stream,
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
    message.append(LlmTextResponse(text: 'ERROR: $err'));
    _handleClose(LlmMessageStatus.error);
  }

  void _handleOnDone() {
    message.updateStatus(LlmMessageStatus.success);
    onDone?.call();
  }

  void _handleOnData(LlmResponse part) {
    message.append(part);
    onDone?.call();
  }

  void _handleClose(LlmMessageStatus status) {
    assert(_subscription != null);
    _subscription!.cancel();
    _subscription = null;
    message.updateStatus(status);
    onDone?.call();
  }
}
