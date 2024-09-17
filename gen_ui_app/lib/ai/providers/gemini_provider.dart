// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../models/llm_function.dart';
import '../models/message.dart';
import 'llm_provider_interface.dart';

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

class GeminiProvider extends LlmProvider {
  GeminiProvider({
    required String model,
    required String apiKey,
    String? systemInstruction,
    GenerationConfig? config,
    List<LlmFunction> functions = const [],
    List<Tool> tools = const [],
    List<SafetySetting>? safetySettings,
    ToolConfig? toolConfig,
    List<Content>? history,
  }) {
    _functionHandlers = _llmFunctionsToHandlers(functions);

    final llm = GenerativeModel(
      model: model,
      apiKey: apiKey,
      tools: _llmFunctionsToTools(functions),
      toolConfig: toolConfig,
      generationConfig: config,
      safetySettings: safetySettings ?? _safetySettings,
      systemInstruction:
          systemInstruction != null ? Content.system(systemInstruction) : null,
    );

    chat = llm.startChat(
      safetySettings: safetySettings,
      history: history,
    );
  }

  late final ChatSession chat;
  late final Map<String, LlmFunction> _functionHandlers;

  FutureOr<FunctionResponse> _dispatchFunctionCall(FunctionCall call) async {
    final llmFunction = _functionHandlers[call.name]!;
    final result = await llmFunction.handler(call.args);

    return FunctionResponse(
      call.name,
      result,
    );
  }

  LlmFunctionResponsePart _buildFunctionResponse(
      FunctionResponse functionResponse) {
    final result = functionResponse.response;
    final llmFunction = _functionHandlers[functionResponse.name]!;

    return LlmFunctionResponsePart(
      function: llmFunction,
      result: result ?? {},
    );
  }

  Content _buildUserMessage(String prompt, Iterable<Attachment> attachments) {
    return Content('user', [
      TextPart(prompt),
      ...attachments.map(_partFrom),
    ]);
  }

  @override
  Stream<LlmMessagePart> sendMessageStream(
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
          final response = await _dispatchFunctionCall(call);
          functionResponses.add(response);
          yield _buildFunctionResponse(response);
        }
      }
      final text = chunk.text ?? '';

      if (text.isNotEmpty) yield LlmTextPart(text: text);
    }

    if (functionResponses.isNotEmpty) {
      final response =
          chat.sendMessageStream(Content.functionResponses(functionResponses));
      await for (final chunk in response) {
        final text = chunk.text ?? '';
        if (text.isNotEmpty) yield LlmTextPart(text: text);
      }
    }
  }

  @override
  Future<LlmMessage> sendMessage(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async {
    final content = _buildUserMessage(prompt, attachments);
    final response = await chat.sendMessage(content);
    final parts = await _getPartsFromResponse(response);
    return LlmMessage(parts: parts);
  }

  Future<List<LlmMessagePart>> _getPartsFromResponse(
    GenerateContentResponse response,
  ) async {
    final functionCalls = response.functionCalls.toList();
    final functionResponses = <FunctionResponse>[];

    final textPart = response.text ?? '';

    for (final call in functionCalls) {
      functionResponses.add(await _dispatchFunctionCall(call));
    }

    final parts = [
      ...functionResponses.map(_buildFunctionResponse),
      if (textPart.isNotEmpty) LlmTextPart(text: textPart),
    ];

    if (functionResponses.isNotEmpty) {
      final functionCallback = await chat.sendMessage(
        Content.functionResponses(functionResponses),
      );

      parts.addAll(await _getPartsFromResponse(functionCallback));
    }

    return parts;
  }

  Part _partFrom(Attachment attachment) => switch (attachment) {
        (FileAttachment a) => DataPart(a.mimeType, a.bytes),
        (ImageAttachment a) => DataPart(a.mimeType, a.bytes),
        (LinkAttachment a) => FilePart(a.url),
      };
}

List<Tool> _llmFunctionsToTools(List<LlmFunction> functions) {
  return [
    Tool(functionDeclarations: functions.map((e) => e.declaration).toList())
  ];
}

Map<String, LlmFunction> _llmFunctionsToHandlers(List<LlmFunction> functions) {
  return {for (final function in functions) function.function.name: function};
}
