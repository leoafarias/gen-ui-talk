// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../models/llm_function.dart';
import '../models/message.dart';
import 'llm_provider_interface.dart';

class GeminiProvider extends LlmProvider {
  GeminiProvider({
    required String model,
    required String apiKey,
    String? systemInstruction,
    GenerationConfig? config,
    List<LlmFunction> functions = const [],
    List<SafetySetting> safetySettings = const [],
    ToolConfig? toolConfig,
  }) {
    _functionCallHandlers = functions.toFunctionHandlers();
    _functionUiHandlers = functions.toUiHandlers();
    final llm = GenerativeModel(
      model: model,
      apiKey: apiKey,
      tools: functions.toTools(),
      toolConfig: toolConfig,
      generationConfig: config,
      safetySettings: safetySettings,
      systemInstruction:
          systemInstruction != null ? Content.system(systemInstruction) : null,
    );

    _chat = llm.startChat(safetySettings: safetySettings);
  }

  late final ChatSession _chat;
  late final Map<String, FunctionCallHandler> _functionCallHandlers;
  late final Map<String, FunctionUiHandler> _functionUiHandlers;

  FunctionResponse dispatchFunctionCall(FunctionCall call) {
    final function = _functionCallHandlers[call.name]!;
    final result = function(call.args);
    return FunctionResponse(call.name, result);
  }

  Widget? renderFunctionUi(FunctionResponse response) {
    final render = _functionUiHandlers[response.name];
    if (render == null) return null;

    return render(response.response ?? {});
  }

  @override

  /// Generates a stream of text based on the given prompt and attachments.
  ///
  /// [prompt] is the input text to generate a response for. [attachments] is an
  /// optional iterable of [Attachment] objects to include with the prompt.
  ///
  /// Returns a [Stream] of [String] containing the generated text chunks.
  Stream<LlmResponse> generateStream(
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

          yield LlmFunctionResponse(
            name: response.name,
            args: response.response,
          );
        }
      }
      final text = chunk.text;

      if (text != null) yield LlmTextResponse(text: text);
    }
  }

  Part _partFrom(Attachment attachment) => switch (attachment) {
        (FileAttachment a) => DataPart(a.mimeType, a.bytes),
        (ImageAttachment a) => DataPart(a.mimeType, a.bytes),
        (LinkAttachment a) => FilePart(a.url),
      };
}
