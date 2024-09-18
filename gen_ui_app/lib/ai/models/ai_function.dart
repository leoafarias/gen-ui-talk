import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../helpers.dart';
import 'ai_response.dart';

typedef AiFunctionHandler<T> = Future<T> Function(JSON args);

typedef AiWidgetBuilder<T> = Widget Function(T);

class AiFunctionDeclaration {
  final String name;
  final String description;
  final Schema? parameters;

  final AiFunctionHandler<JSON> handler;

  const AiFunctionDeclaration({
    required this.name,
    required this.description,
    this.parameters,
    required this.handler,
  });
}

class AiWidgetDeclaration<T> extends AiFunctionDeclaration {
  final AiWidgetBuilder<AiWidgetElement<T>> _builder;
  final T Function(JSON args) parser;
  const AiWidgetDeclaration({
    required AiWidgetBuilder<AiWidgetElement<T>> builder,
    required super.name,
    required super.description,
    super.parameters,
    required super.handler,
    required this.parser,
  }) : _builder = builder;

  Widget build(AiWidgetElement<T> element) => _builder(element);
}
