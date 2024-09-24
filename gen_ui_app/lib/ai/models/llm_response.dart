import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../helpers.dart';
import 'content.dart';
import 'llm_function.dart';

class LlmContent extends LlmContentBase {
  @override
  final List<LlmElement> parts;

  LlmContent({
    super.id,
    required this.parts,
  });

  factory LlmContent.text(String text) {
    return LlmContent(parts: [LlmTextElement(text: text)]);
  }
}

class LlmStreamableContent extends LlmContentBase {
  @override
  final List<LlmElement> parts = List.empty(growable: true);

  LlmContent finalize() {
    return LlmContent(
      id: id,
      parts: parts,
    );
  }

  LlmStreamableContent({
    super.id,
  });

  void append(LlmElement part) {
    // If last message part is LlmTextPartMessage, append to it
    if (parts.isNotEmpty &&
        parts.last is LlmTextElement &&
        part is LlmTextElement) {
      (parts.last as LlmTextElement).text += part.text;
      return;
    }
    parts.add(part);
  }
}

sealed class LlmElement {
  const LlmElement();
}

class LlmTextElement extends LlmElement {
  String text;
  LlmTextElement({
    required this.text,
  });

  @override
  String toString() => 'LlmTextPart(text: $text)';
}

enum LlmFunctionStatus {
  idle,
  running,
  done,
  error,
}

class LlmFunctionElement extends LlmElement with ChangeNotifier {
  final LlmFunctionDeclaration declaration;

  JSON? _arguments;
  JSON? _response;
  Object? _error;
  LlmFunctionStatus _status = LlmFunctionStatus.idle;

  LlmFunctionElement(this.declaration);

  JSON get requiredData => _response!;

  Future<void> exec(JSON args) async {
    try {
      _error = null;
      _arguments = args;
      _status = LlmFunctionStatus.running;
      notifyListeners();
      _response = await declaration.handler(args);
      _status = LlmFunctionStatus.done;
    } catch (e) {
      _status = LlmFunctionStatus.error;
      _error = e;
    } finally {
      notifyListeners();
    }
  }

  LlmFunctionStatus get status => _status;

  Object? get error => _error;

  bool get isRunning => _response == null;

  JSON get arguments => _arguments ?? {};

  bool get isComplete => _response != null;

  JSON get response => _response ?? {};

  String get name => declaration.name;
  String get description => declaration.description;

  @override
  String toString() =>
      'AiFunctionElement(name: $name, arguments: $arguments) => $_response';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LlmFunctionElement &&
        other.declaration == declaration &&
        other._arguments == _arguments &&
        other._response == _response &&
        other._error == _error &&
        other._status == _status;
  }

  @override
  int get hashCode {
    return declaration.hashCode ^
        _arguments.hashCode ^
        _response.hashCode ^
        _error.hashCode ^
        _status.hashCode;
  }
}
