// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_vertexai/firebase_vertexai.dart';

import '../models/ai_function.dart';
import '../models/ai_response.dart';
import 'ai_provider_interface.dart';

/// A provider class for interacting with Firebase Vertex AI's language model.
///
/// This class extends [LlmProvider] and implements the necessary methods to
/// generate text using Firebase Vertex AI's generative model.
class FirebaseVertexProvider extends AiProvider {
  /// Creates a new instance of [FirebaseVertexProvider].
  ///
  /// [model] is the name of the Firebase Vertex AI model to use. [config] is an
  /// optional [GenerationConfig] to customize the text generation.
  FirebaseVertexProvider({
    required String model,
    String? systemInstruction,
    GenerationConfig? config,
  }) {
    final llm = FirebaseVertexAI.instance.generativeModel(
      model: model,
      generationConfig: config,
      systemInstruction:
          systemInstruction != null ? Content.system(systemInstruction) : null,
    );

    _chat = llm.startChat();
  }

  /// The chat session used for generating responses.
  late final ChatSession _chat;
  final GenerativeModel _embeddingModel;

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

  Content _buildUserMessage(String prompt, Iterable<Attachment> attachments) {
    return Content('user', [
      TextPart(prompt),
      ...attachments.map(_partFrom),
    ]);
  }

  Future<List<AiElement>> _getPartsFromResponse(
    GenerateContentResponse response,
  ) async {
    final content = response.candidates.first.content;

    final functionCalls = content.parts.whereType<FunctionCall>().toList();

    final functionParts = <AiFunctionElement>[];

    for (final call in functionCalls) {
      final functionPart = _getFunctionCall(call).toElement();
      await functionPart.exec(call.args);
      functionParts.add(functionPart);
    }

    final parts = [
      ...functionParts,
      ...content.parts
          .whereType<TextPart>()
          .map((e) => AiTextElement(text: e.text)),
    ];
  }

  LlmFunctionDeclaration _getFunctionCall(FunctionCall call) {
    return _functionHandlers[call.name]!;
  }

  @override
  Stream<AiElement> sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    final content = Content('user', [
      TextPart(prompt),
      ...attachments.map(partFrom),
    ]);
    final response = _chat.sendMessageStream(content);
    await for (final chunk in response) {
      final text = chunk.text;
      if (text != null) yield text;
    }
  }

  Part partFrom(Attachment attachment) => switch (attachment) {
        (FileAttachment a) => DataPart(a.mimeType, a.bytes),
        (_) => throw UnsupportedError(''
            'Unsupported attachment type: '
            '${attachment.runtimeType}'
            ''),
      };
}
