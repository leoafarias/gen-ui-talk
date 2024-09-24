// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../models/llm_function.dart';
import '../models/llm_response.dart';
import 'ai_provider_interface.dart';

class GeminiProvider extends LlmProvider {
  GeminiProvider({
    required GenerativeModel model,
    List<Content>? history,
    List<LlmFunctionDeclaration> functionDeclarations = const [],
  }) {
    chat = model.startChat(
      history: history,
    );

    _functionHandlers = {
      for (final response in functionDeclarations) response.name: response,
    };
  }

  late final ChatSession chat;

  late final Map<String, LlmFunctionDeclaration> _functionHandlers;

  LlmFunctionDeclaration _getFunctionDeclaration(FunctionCall call) {
    final declaration = _functionHandlers[call.name];

    if (declaration == null) {
      throw Exception('No function declaration found for ${call.name}');
    }

    return declaration;
  }

  Content _buildUserMessage(String prompt, Iterable<Attachment> attachments) {
    return Content('user', [
      TextPart(prompt),
      ...attachments.map(_partFrom),
    ]);
  }

  @override
  Stream<LlmElement> sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    final content = _buildUserMessage(prompt, attachments);
    final response = chat.sendMessageStream(content);

    final functionParts = <LlmFunctionElement>[];
    await for (final chunk in response) {
      final functionCalls = chunk.functionCalls.toList();
      if (functionCalls.isNotEmpty) {
        for (final call in chunk.functionCalls) {
          final widgetEl = _getFunctionDeclaration(call).toElement();
          yield widgetEl;

          await widgetEl.exec(call.args);
          functionParts.add(widgetEl);
        }
      }
      final text = chunk.text ?? '';
      if (text.isNotEmpty) yield LlmTextElement(text: text);
    }

    if (functionParts.isNotEmpty) {
      final response = chat.sendMessageStream(
        Content.functionResponses(
          functionParts.map((e) => FunctionResponse(e.name, e.response)),
        ),
      );
      await for (final chunk in response) {
        final functionCalls = chunk.functionCalls.toList();

        if (functionCalls.isNotEmpty) {
          for (final call in chunk.functionCalls) {
            final widgetEl = _getFunctionDeclaration(call).toElement();
            yield widgetEl;
            await widgetEl.exec(call.args);
          }
        }

        final text = chunk.text ?? '';
        if (text.isNotEmpty) yield LlmTextElement(text: text);
      }
    }
  }

  @override
  Future<LlmContent> sendMessage(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async {
    final content = _buildUserMessage(prompt, attachments);
    final response = await chat.sendMessage(content);
    final parts = await _getPartsFromResponse(response);
    return LlmContent(parts: parts);
  }

  Future<List<LlmElement>> _getPartsFromResponse(
    GenerateContentResponse response,
  ) async {
    final content = response.candidates.first.content;

    final functionCalls = content.parts.whereType<FunctionCall>().toList();

    final functionParts = <LlmFunctionElement>[];

    for (final call in functionCalls) {
      final widgetEl = _getFunctionDeclaration(call).toElement();
      await widgetEl.exec(call.args);
      functionParts.add(widgetEl);
    }

    final parts = [
      ...functionParts,
      ...content.parts
          .whereType<TextPart>()
          .map((e) => LlmTextElement(text: e.text)),
    ];

    if (functionParts.isNotEmpty) {
      final textResponse = await chat.sendMessage(
        Content.functionResponses(
            functionParts.map((e) => FunctionResponse(e.name, e.response))),
      );

      final textPart = textResponse.text ?? '';
      if (textPart.isNotEmpty) {
        parts.add(LlmTextElement(text: textPart));
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
