import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../models/content.dart';
import '../../models/llm_response.dart';
import '../../views/builder_types.dart';
import 'base_content_view.dart';
import 'llm_element_view.dart';

class LlmContentView<T extends LlmContentBase> extends ContentView<T> {
  const LlmContentView(
    super.content, {
    super.key,
    super.onSelected,
    required this.active,
    this.functionBuilders,
    this.textBuilder,
  });

  final WidgetElementViewBuilder<LlmFunctionElement>? functionBuilders;
  final WidgetElementViewBuilder<LlmTextElement>? textBuilder;

  // Message is the active one in the chat.
  final bool active;
  Iterable<Widget> _buildResponseElements(List<LlmElement> parts) {
    return parts.mapIndexed((index, part) {
      return switch (part) {
        (LlmTextElement p) => LlmTextElementView(p, builder: textBuilder),
        (LlmFunctionElement p) => LlmFunctionElementView(
            p,
            builder: functionBuilders,
          ),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget paddingBuilder(Widget child) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: child,
      );
    }

    return Row(
      children: [
        Expanded(
          child: LlmContentViewProvider(
            active: active,
            child: Column(
              children: _buildResponseElements(content.parts)
                  .map(paddingBuilder)
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class LlmContentViewProvider extends InheritedWidget {
  final bool active;
  const LlmContentViewProvider({
    required super.child,
    required this.active,
    super.key,
  });

  static LlmContentViewProvider of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<LlmContentViewProvider>();

    if (provider == null) {
      throw FlutterError('AiContentViewProvider not found in context');
    }
    return provider;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}
