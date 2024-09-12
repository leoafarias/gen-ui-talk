// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:google_generative_ai/google_generative_ai.dart';

import 'llm_provider_interface.dart';

typedef FunctionCallHandler = Map<String, Object?> Function(
    Map<String, Object?> args);

class GeminiProvider extends LlmProvider {
  GeminiProvider({
    required String model,
    required String apiKey,
    String? systemInstruction,
    GenerationConfig? config,
    Map<String, FunctionCallHandler> functionHandlers = const {},
    List<SafetySetting> safetySettings = const [],
    List<Tool> tools = const [],
    ToolConfig? toolConfig,
  }) {
    _functionHandlers = functionHandlers;
    final llm = GenerativeModel(
      model: model,
      apiKey: apiKey,
      tools: tools,
      toolConfig: toolConfig,
      generationConfig: config,
      safetySettings: safetySettings,
      systemInstruction:
          systemInstruction != null ? Content.system(systemInstruction) : null,
    );

    _chat = llm.startChat(safetySettings: safetySettings);
  }

  late final ChatSession _chat;
  late final Map<String, FunctionCallHandler> _functionHandlers;

  FunctionResponse dispatchFunctionCall(FunctionCall call) {
    final function = _functionHandlers[call.name]!;
    final result = function(call.args);
    return FunctionResponse(call.name, result);
  }

  @override

  /// Generates a stream of text based on the given prompt and attachments.
  ///
  /// [prompt] is the input text to generate a response for. [attachments] is an
  /// optional iterable of [Attachment] objects to include with the prompt.
  ///
  /// Returns a [Stream] of [String] containing the generated text chunks.
  Stream<LlmProviderResponse> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    final content = Content('user', [
      TextPart(prompt),
      ...attachments.map(_partFrom),
    ]);
    final response = _chat.sendMessageStream(content);
    await for (final chunk in response) {
      final functionCalls = chunk.functionCalls.toList();
      if (functionCalls.isNotEmpty) {
        for (final call in chunk.functionCalls) {
          final response = dispatchFunctionCall(call);

          yield LlmFunctionResponse(response.name, response.response);
        }
      }
      final text = chunk.text;

      if (text != null) yield LlmTextResponse(text);
    }
  }

  Part _partFrom(Attachment attachment) => switch (attachment) {
        (FileAttachment a) => DataPart(a.mimeType, a.bytes),
        (ImageAttachment a) => DataPart(a.mimeType, a.bytes),
        (LinkAttachment a) => FilePart(a.url),
      };
}
