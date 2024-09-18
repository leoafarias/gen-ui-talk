import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../helpers.dart';

typedef AiFunctionHandler = Future<JSON> Function(JSON args);

typedef AiWidgetBuilder = Widget Function(BuildContext, JSON);

class AiFunctionDeclaration {
  final String name;
  final String description;
  final Schema? parameters;

  final AiFunctionHandler handler;

  const AiFunctionDeclaration({
    required this.name,
    required this.description,
    this.parameters,
    required this.handler,
  });
}

class AiWidgetDeclaration extends AiFunctionDeclaration {
  final AiWidgetBuilder _builder;
  const AiWidgetDeclaration({
    required AiWidgetBuilder builder,
    required super.name,
    required super.description,
    super.parameters,
    required super.handler,
  }) : _builder = builder;

  Widget build(BuildContext context, JSON value) => _builder(context, value);
}
