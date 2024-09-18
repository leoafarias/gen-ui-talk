import 'dart:async';

import 'package:flutter/widgets.dart';

import '../helpers.dart';
import 'ai_function.dart';
import 'content.dart';

class AiContent extends AiContentBase {
  @override
  final List<AiElement> parts;

  AiContent({
    super.id,
    required this.parts,
  });

  factory AiContent.text(String text) {
    return AiContent(parts: [AiTextElement(text: text)]);
  }
}

class AiStreamableContent extends AiContentBase {
  @override
  final List<AiElement> parts = List.empty(growable: true);

  AiContent finalize() {
    return AiContent(
      id: id,
      parts: parts,
    );
  }

  AiStreamableContent({
    super.id,
  });

  void append(AiElement part) {
    // If last message part is LlmTextPartMessage, append to it
    if (parts.isNotEmpty &&
        parts.last is AiTextElement &&
        part is AiTextElement) {
      (parts.last as AiTextElement).text += part.text;
      return;
    }
    parts.add(part);
  }
}

sealed class AiElement {
  const AiElement();
}

sealed class AiStatefulElement extends AiElement with ChangeNotifier {}

class AiTextElement extends AiElement {
  String text;
  AiTextElement({
    required this.text,
  });

  @override
  String toString() => 'LlmTextPart(text: $text)';
}

enum AiFunctionStatus {
  idle,
  running,
  done,
  error,
}

class AiWidgetElement extends AiFunctionElement<AiWidgetDeclaration> {
  AiWidgetElement(super.function);

  Widget build(BuildContext context) =>
      function.build(context, _response ?? {});
}

class AiFunctionElement<T extends AiFunctionDeclaration>
    extends AiStatefulElement {
  final T function;
  JSON? _arguments;
  JSON? _response;
  Object? _error;
  AiFunctionStatus _status = AiFunctionStatus.idle;

  AiFunctionElement(this.function);

  Future<void> exec(JSON args) async {
    try {
      _error = null;
      _arguments = args;
      _status = AiFunctionStatus.running;
      notifyListeners();
      _response = await function.handler(args);
      _status = AiFunctionStatus.done;
    } catch (e) {
      _status = AiFunctionStatus.error;
      _error = e;
    } finally {
      notifyListeners();
    }
  }

  AiFunctionStatus get status => _status;

  Object? get error => _error;

  bool get isRunning => _response == null;

  JSON get arguments => _arguments ?? {};

  bool get isComplete => _response != null;

  JSON get response => _response ?? {};

  String get name => function.name;
  String get description => function.description;

  @override
  String toString() =>
      'AiFunctionElement(name: $name, arguments: $arguments) => $_response';
}
