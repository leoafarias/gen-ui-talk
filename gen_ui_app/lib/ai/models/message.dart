import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

import '../helpers.dart';
import '../providers/llm_provider_interface.dart';
import 'llm_function.dart';

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

sealed class ILlmMessage extends Message {
  List<LlmMessagePart> get parts;

  ILlmMessage({
    super.id,
  }) : super(origin: MessageOrigin.llm);

  @override
  String toClipboardText() => parts.map((e) => e.toClipboardText()).join();
}

class LlmMessage extends ILlmMessage {
  @override
  final List<LlmMessagePart> parts;

  LlmMessage({
    super.id,
    required this.parts,
  });

  factory LlmMessage.text(String text) {
    return LlmMessage(parts: [LlmTextPart(text: text)]);
  }

  List<LlmFunctionResponsePart> get functionResponses =>
      parts.whereType<LlmFunctionResponsePart>().toList();

  List<LlmTextPart> get textParts => parts.whereType<LlmTextPart>().toList();

  String get text => textParts.map((e) => e.text).join();
}

class LlmStreamMessage extends ILlmMessage {
  @override
  final List<LlmMessagePart> parts = List.empty(growable: true);

  LlmMessage finalize() {
    return LlmMessage(
      id: id,
      parts: parts,
    );
  }

  LlmStreamMessage({
    super.id,
  });

  void append(LlmMessagePart part) {
    // If last message part is LlmTextPartMessage, append to it
    if (parts.isNotEmpty && parts.last is LlmTextPart && part is LlmTextPart) {
      (parts.last as LlmTextPart).text += part.text;
      return;
    }
    parts.add(part);
  }
}

sealed class LlmMessagePart {
  const LlmMessagePart();

  String toClipboardText();
}

class LlmTextPart extends LlmMessagePart {
  String text;
  LlmTextPart({
    required this.text,
  });

  @override
  String toClipboardText() => text;
}

class LlmFunctionResponsePart extends LlmMessagePart {
  final LlmFunction function;
  final JSON result;

  LlmFunctionResponsePart({
    required this.function,
    required this.result,
  });

  Widget? getRunnableUi() => function.render(result);

  @override
  String toClipboardText() => '${function.name}(${result.toString()})';
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
