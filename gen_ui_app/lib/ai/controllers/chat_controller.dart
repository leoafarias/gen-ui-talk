import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../models/message.dart';
import '../providers/llm_provider_interface.dart';

class ChatController extends ChangeNotifier {
  final LlmProvider provider;
  final List<Message> _transcript = [];
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

  LlmMessage? get lastLlmResponse {
    if (_transcript.isEmpty) {
      return null;
    }

    // get the last message from the transcript
    // that is an LlmMessage
    final lastMessage = _transcript.reversed.firstWhereOrNull(
      (element) => element is LlmMessage,
    ) as LlmMessage?;

    return lastMessage;
  }

  Future<LlmMessage> submitMessage(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async {
    try {
      _initialMessage = null;
      isProcessing = true;
      final userMessage = UserMessage(prompt: prompt, attachments: attachments);

      _transcript.add(userMessage);
      notifyListeners();

      final llmMessage = await provider.sendMessage(userMessage.prompt,
          attachments: userMessage.attachments);

      _transcript.add(llmMessage);
      return llmMessage;
    } finally {
      isProcessing = false;
      notifyListeners();
    }

    // _currentResponse = _LlmResponseListener(
    //   stream: provider.sendMessageStream(prompt, attachments: attachments),
    //   message: llmMessage,
    //   onDone: _onDone,
    //   onUpdate: _onUpdate,
    // );
  }

  void addSystemMessage(String prompt) {
    _transcript.add(SystemMesssage(prompt: prompt));
    notifyListeners();
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

// class _TextEditingControllerHookCreator {
//   const _TextEditingControllerHookCreator();

//   /// Creates a [TextEditingController] that will be disposed automatically.
//   ///
//   /// The [text] parameter can be used to set the initial value of the
//   /// controller.
//   TextEditingController call({String? text, List<Object?>? keys}) {
//     return use(_TextEditingControllerHook(text, keys));
//   }

//   /// Creates a [TextEditingController] from the initial [value] that will
//   /// be disposed automatically.
//   TextEditingController fromValue(
//     TextEditingValue value, [
//     List<Object?>? keys,
//   ]) {
//     return use(_TextEditingControllerHook.fromValue(value, keys));
//   }
// }

// /// Creates a [TextEditingController], either via an initial text or an initial
// /// [TextEditingValue].
// ///
// /// To use a [TextEditingController] with an optional initial text, use:
// /// ```dart
// /// final controller = useTextEditingController(text: 'initial text');
// /// ```
// ///
// /// To use a [TextEditingController] with an optional initial value, use:
// /// ```dart
// /// final controller = useTextEditingController
// ///   .fromValue(TextEditingValue.empty);
// /// ```
// ///
// /// Changing the text or initial value after the widget has been built has no
// /// effect whatsoever. To update the value in a callback, for instance after a
// /// button was pressed, use the [TextEditingController.text] or
// /// [TextEditingController.value] setters. To have the [TextEditingController]
// /// reflect changing values, you can use [useEffect]. This example will update
// /// the [TextEditingController.text] whenever a provided [ValueListenable]
// /// changes:
// /// ```dart
// /// final controller = useTextEditingController();
// /// final update = useValueListenable(myTextControllerUpdates);
// ///
// /// useEffect(() {
// ///   controller.text = update;
// /// }, [update]);
// /// ```
// ///
// /// See also:
// /// - [TextEditingController], which this hook creates.
// const useTextEditingController = _TextEditingControllerHookCreator();

// class _TextEditingControllerHook extends Hook<TextEditingController> {
//   const _TextEditingControllerHook(
//     this.initialText, [
//     List<Object?>? keys,
//   ])  : initialValue = null,
//         super(keys: keys);

//   const _TextEditingControllerHook.fromValue(
//     TextEditingValue this.initialValue, [
//     List<Object?>? keys,
//   ])  : initialText = null,
//         super(keys: keys);

//   final String? initialText;
//   final TextEditingValue? initialValue;

//   @override
//   _TextEditingControllerHookState createState() {
//     return _TextEditingControllerHookState();
//   }
// }

// class _TextEditingControllerHookState
//     extends HookState<TextEditingController, _TextEditingControllerHook> {
//   late final _controller = hook.initialValue != null
//       ? TextEditingController.fromValue(hook.initialValue)
//       : TextEditingController(text: hook.initialText);

//   @override
//   TextEditingController build(BuildContext context) => _controller;

//   @override
//   void dispose() => _controller.dispose();

//   @override
//   String get debugLabel => 'useTextEditingController';
// }

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
