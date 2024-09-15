// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

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
    _functionHandlers = _llmFunctionsToHandlers(functions);

    final llm = GenerativeModel(
      model: model,
      apiKey: apiKey,
      tools: _llmFunctionsToTools(functions),
      toolConfig: toolConfig,
      generationConfig: config,
      safetySettings: safetySettings,
      systemInstruction:
          systemInstruction != null ? Content.system(systemInstruction) : null,
    );

    chat = llm.startChat(safetySettings: safetySettings);
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

  /// Generates a stream of text based on the given prompt and attachments.
  ///
  /// [prompt] is the input text to generate a response for. [attachments] is an
  /// optional iterable of [Attachment] objects to include with the prompt.
  ///
  /// Returns a [Stream] of [String] containing the generated text chunks.
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
      final text = chunk.text;

      if (text != null) yield LlmTextPart(text: text);
    }

    if (functionResponses.isNotEmpty) {
      final response =
          chat.sendMessageStream(Content.functionResponses(functionResponses));
      await for (final chunk in response) {
        final text = chunk.text;
        if (text != null) yield LlmTextPart(text: text);
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
    final functionCalls = response.functionCalls.toList();
    final functionParts = <FunctionResponse>[];
    if (functionCalls.isNotEmpty) {
      for (final call in functionCalls) {
        functionParts.add(await _dispatchFunctionCall(call));
      }
    }

    final textPart = response.text;

    final parts = [
      ...functionParts.map(_buildFunctionResponse),
      if (textPart != null) LlmTextPart(text: textPart)
    ];

    return LlmMessage(parts: parts);
  }

  Part _partFrom(Attachment attachment) => switch (attachment) {
        (FileAttachment a) => DataPart(a.mimeType, a.bytes),
        (ImageAttachment a) => DataPart(a.mimeType, a.bytes),
        (LinkAttachment a) => FilePart(a.url),
      };
}

List<Tool> _llmFunctionsToTools(List<LlmFunction> functions) {
  return functions
      .map((e) => Tool(functionDeclarations: [
            FunctionDeclaration(
              e.function.name,
              e.function.description,
              e.function.parameters,
            )
          ]))
      .toList();
}

Map<String, LlmFunction> _llmFunctionsToHandlers(List<LlmFunction> functions) {
  return {for (final function in functions) function.function.name: function};
}


// Content _buildContent(Message message) {
//   return switch (message) {
//     (UserMessage message) => Content('user', [
//         TextPart(message.prompt),
//         ...message.attachments.map(_partFrom),
//       ]),
//     (LlmMessage message) => Content.model(_llmPartsFrom(message.parts)),
    
//   };
// }

// Part _partFrom(Attachment attachment) => switch (attachment) {
//       (FileAttachment a) => DataPart(a.mimeType, a.bytes),
//       (ImageAttachment a) => DataPart(a.mimeType, a.bytes),
//       (LinkAttachment a) => FilePart(a.url),
//     };

// List<Part> _llmPartsFrom(Iterable<LlmMessagePart> parts) {
//   return switch (parts) {
//     (LlmTextPart part) => [TextPart(part.text)],
//     (LlmFunctionResponsePart part) => [
//         TextPart(part.function.name),
//         TextPart(part.result.toString()),
//       ],
//     _ => throw UnimplementedError(),
//   };
// }
