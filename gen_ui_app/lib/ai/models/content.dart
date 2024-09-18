import 'package:uuid/uuid.dart';

import '../providers/ai_provider_interface.dart';
import 'ai_response.dart';

sealed class ContentBase {
  late final String id;
  final ContentOrigin origin;

  ContentBase({
    String? id,
    required this.origin,
  }) {
    this.id = id ?? const Uuid().v4();
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ContentBase && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class UserContent extends ContentBase {
  final String prompt;
  final Iterable<Attachment> attachments;
  UserContent({
    super.id,
    required this.prompt,
    required this.attachments,
  }) : super(origin: ContentOrigin.user);

  @override
  String toString() =>
      'UserContent(prompt: $prompt, attachments: $attachments)';
}

class SystemContent extends ContentBase {
  final String prompt;
  SystemContent({
    super.id,
    required this.prompt,
  }) : super(origin: ContentOrigin.system);

  @override
  String toString() => 'SystemContent(prompt: $prompt)';
}

enum ContentOrigin {
  user,
  system,

  ai;

  bool get isUser => this == ContentOrigin.user;
  bool get isSystem => this == ContentOrigin.system;

  bool get isLlm => this == ContentOrigin.ai;
}

abstract class AiContentBase extends ContentBase {
  List<AiElement> get parts;

  AiContentBase({
    super.id,
  }) : super(origin: ContentOrigin.ai);

  List<AiFunctionElement> get functions =>
      parts.whereType<AiFunctionElement>().toList();

  List<AiTextElement> get _textParts =>
      parts.whereType<AiTextElement>().toList();

  String get text => _textParts.map((e) => e.text).join();

  @override
  String toString() =>
      'AiContent(parts: ${parts.map((e) => e.toString()).join(', ')})';
}
