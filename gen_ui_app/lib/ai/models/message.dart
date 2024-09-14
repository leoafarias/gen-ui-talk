import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

import '../providers/llm_provider_interface.dart';
import 'llm_runnable_ui.dart';

sealed class Message {
  late final String id;
  final MessageOrigin origin;

  Message({
    String? id,
    required this.origin,
  }) {
    this.id = id ?? const Uuid().v4();
  }

  String toClipboardText();
}

class UserMessage extends Message {
  final String prompt;
  final Iterable<Attachment> attachments;
  UserMessage({
    super.id,
    required this.prompt,
    required this.attachments,
  }) : super(origin: MessageOrigin.user);

  @override
  String toClipboardText() => prompt;
}

class SystemMesssage extends Message {
  final String prompt;
  SystemMesssage({
    super.id,
    required this.prompt,
  }) : super(origin: MessageOrigin.system);

  @override
  String toClipboardText() => prompt;
}

class LlmMessage extends Message {
  LlmMessageStatus _status;
  final List<LlmResponse> parts = List.empty(growable: true);

  LlmMessage({
    super.id,
    LlmMessageStatus status = LlmMessageStatus.inProgress,
  })  : _status = status,
        super(origin: MessageOrigin.llm);

  void append(LlmResponse part) {
    // If last message part is LlmTextPartMessage, append to it
    if (parts.isNotEmpty &&
        parts.last is LlmTextResponse &&
        part is LlmTextResponse) {
      (parts.last as LlmTextResponse).text += part.text;
      return;
    }
    parts.add(part);
  }

  void updateStatus(LlmMessageStatus status) => _status = status;

  bool get isDone => _status != LlmMessageStatus.inProgress;

  @override
  String toClipboardText() {
    return parts.map((part) => part.toClipboardText()).join('\n');
  }
}

sealed class LlmResponse {
  const LlmResponse();

  String toClipboardText();
}

class LlmTextResponse extends LlmResponse {
  String text;
  LlmTextResponse({
    required this.text,
  });

  @override
  String toClipboardText() => text;
}

class LlmFunctionResponse extends LlmResponse {
  final String name;
  final Map<String, Object?>? args;
  LlmFunctionResponse({
    required this.name,
    required this.args,
  });

  @override
  String toClipboardText() => '$name(${args?.toString() ?? ''})';
}

class LlmRunnableUiResponse<T> extends LlmFunctionResponse {
  final LLmUiRenderer<T> _renderer;

  LlmRunnableUiResponse({
    required super.name,
    required super.args,
    required LLmUiRenderer<T> renderer,
  }) : _renderer = renderer;

  Widget render() => _renderer.build(args!);
}

enum LlmMessageStatus {
  inProgress,
  success,
  error,
  canceled;
}

enum MessageOrigin {
  user,
  system,

  llm;

  bool get isUser => this == MessageOrigin.user;
  bool get isSystem => this == MessageOrigin.system;

  bool get isLlm => this == MessageOrigin.llm;
}
