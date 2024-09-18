// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../models/ai_function.dart';
import '../models/ai_response.dart';
import 'ai_provider_interface.dart';

enum GeminiModel {
  flash15('gemini-1.5-flash'),
  pro1('gemini-1.0-pro'),
  pro1001('gemini-1.0-pro-001'),
  pro15('gemini-1.5-pro'),
  flash15Latest('gemini-1.5-flash-latest'),
  pro15Latest('gemini-1.5-pro-latest');

  const GeminiModel(this.model);

  final String model;
}

final _safetySettings = [
  SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
  SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
  SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
  SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
  SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
];

class GeminiProvider extends AiProvider<GenerativeModel> {
  @override
  late final GenerativeModel model;
  final GenerationConfig? config;
  GeminiProvider({
    required String model,
    required String apiKey,
    String? systemInstruction,
    this.config,
    List<AiFunctionDeclaration> functions = const [],
    List<Tool> tools = const [],
    List<SafetySetting>? safetySettings,
    ToolConfig? toolConfig,
    List<Content>? history,
  }) {
    _functionHandlers = _llmFunctionsToHandlers(functions);

    this.model = GenerativeModel(
      model: model,
      apiKey: apiKey,
      tools: _llmFunctionsToTools(functions),
      toolConfig: toolConfig,
      generationConfig: config,
      safetySettings: safetySettings ?? _safetySettings,
      systemInstruction:
          systemInstruction != null ? Content.system(systemInstruction) : null,
    );

    chat = this.model.startChat(
          safetySettings: safetySettings,
          history: history,
        );
  }

  late final ChatSession chat;
  late final Map<String, AiFunctionDeclaration> _functionHandlers;

  AiFunctionElement _getFunctionCall(FunctionCall call) {
    return AiFunctionElement(_functionHandlers[call.name]!);
  }

  Content _buildUserMessage(String prompt, Iterable<Attachment> attachments) {
    return Content('user', [
      TextPart(prompt),
      ...attachments.map(_partFrom),
    ]);
  }

  @override
  Stream<AiElement> sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    final content = _buildUserMessage(prompt, attachments);
    final response = chat.sendMessageStream(content);

    final functionResponses = <FunctionResponse>[];
    await for (final chunk in response) {
      final functionCalls = chunk.functionCalls.toList();
      if (functionCalls.isNotEmpty) {
        for (final call in chunk.functionCalls) {
          final functionPart = _getFunctionCall(call);
          yield functionPart;

          await functionPart.exec(call.args);
        }
      }
      final text = chunk.text ?? '';
      if (text.isNotEmpty) yield AiTextElement(text: text);
    }

    if (functionResponses.isNotEmpty) {
      final response =
          chat.sendMessageStream(Content.functionResponses(functionResponses));
      await for (final chunk in response) {
        final text = chunk.text ?? '';
        if (text.isNotEmpty) yield AiTextElement(text: text);
      }
    }
  }

  @override
  Future<AiContent> sendMessage(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async {
    final content = _buildUserMessage(prompt, attachments);
    final response = await chat.sendMessage(content);
    final parts = await _getPartsFromResponse(response);
    return AiContent(parts: parts);
  }

  Future<List<AiElement>> _getPartsFromResponse(
    GenerateContentResponse response,
  ) async {
    final content = response.candidates.first.content;

    final functionCalls = content.parts.whereType<FunctionCall>().toList();

    final functionParts = <AiFunctionElement>[];

    for (final call in functionCalls) {
      final functionPart = _getFunctionCall(call);
      await functionPart.exec(call.args);
      functionParts.add(functionPart);
    }

    final parts = [
      ...functionParts,
      ...content.parts
          .whereType<TextPart>()
          .map((e) => AiTextElement(text: e.text)),
    ];

    if (functionParts.isNotEmpty) {
      final textResponse = await chat.sendMessage(
        Content.functionResponses(
            functionParts.map((e) => FunctionResponse(e.name, e.response))),
      );

      final textPart = textResponse.text ?? '';
      if (textPart.isNotEmpty) {
        parts.add(AiTextElement(text: textPart));
      }
    }

    return parts;
  }

  Part _partFrom(Attachment attachment) => switch (attachment) {
        (FileAttachment a) => DataPart(a.mimeType, a.bytes),
        (ImageAttachment a) => DataPart(a.mimeType, a.bytes),
        (LinkAttachment a) => FilePart(a.url),
      };
}

List<Tool> _llmFunctionsToTools(List<AiFunctionDeclaration> functions) {
  return [
    Tool(
        functionDeclarations: functions
            .map((e) => FunctionDeclaration(
                  e.name,
                  e.description,
                  e.parameters,
                ))
            .toList())
  ];
}

Map<String, AiFunctionDeclaration> _llmFunctionsToHandlers(
    List<AiFunctionDeclaration> functions) {
  return {for (final function in functions) function.name: function};
}
