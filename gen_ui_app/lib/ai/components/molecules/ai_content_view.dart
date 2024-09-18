import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../models/ai_response.dart';
import '../../models/content.dart';
import '../../views/builder_types.dart';
import 'ai_element_view.dart';
import 'base_content_view.dart';

class AiContentView<T extends AiContentBase> extends ContentView<T> {
  const AiContentView(
    super.content, {
    super.key,
    super.onSelected,
    required this.active,
    this.widgetBuilder,
    this.functionBuilder,
    this.textBuilder,
  });

  final WidgetElementViewBuilder<AiWidgetElement>? widgetBuilder;
  final WidgetElementViewBuilder<AiTextElement>? textBuilder;
  final WidgetElementViewBuilder<AiFunctionElement>? functionBuilder;

  // Message is the active one in the chat.
  final bool active;
  Iterable<Widget> _buildResponseElements(List<AiElement> parts) {
    return parts.mapIndexed((index, part) {
      return switch (part) {
        (AiTextElement p) => AiTextElementView(p, builder: textBuilder),
        (AiWidgetElement p) => p.render(),
        (AiFunctionElement p) =>
          AiFunctionElementView(p, builder: functionBuilder),
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
          child: AiContentViewProvider(
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

class AiContentViewProvider extends InheritedWidget {
  final bool active;
  const AiContentViewProvider({
    required super.child,
    required this.active,
    super.key,
  });

  static AiContentViewProvider of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AiContentViewProvider>();

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
