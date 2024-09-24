import 'package:flutter/material.dart';

import '../../helpers.dart';
import '../../models/llm_response.dart';
import '../../style.dart';
import '../atoms/message_bubble.dart';

class LlmTextElementView extends LlmElementView<LlmTextElement> {
  const LlmTextElementView(
    super.element, {
    super.key,
    super.builder,
  });

  @override
  Widget build(BuildContext context) {
    if (element.text.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          flex: 6,
          child: MessageBubble(
            text: element.text.trim(),
            style: MessageBubbleStyle(
              textStyle: kFont.copyWith(
                color: Colors.black,
              ),
              backgroundColor: kSecondaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.zero,
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              alignment: Alignment.topLeft,
            ),
          ),
        ),
        const Flexible(flex: 2, child: SizedBox()),
      ],
    );
  }
}

class LlmFunctionElementView extends LlmElementView<LlmFunctionElement> {
  const LlmFunctionElementView(
    super.element, {
    super.key,
    super.builder,
  });

  @override
  Widget build(BuildContext context) {
    final emptyArgs = element.arguments.isEmpty;

    final formattedArgs = prettyJson(element.arguments);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Function',
          style: kMonoFont.copyWith(
            color: kSecondaryColor,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kSecondaryColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: kOnSecondaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 22,
                      ),
                      child: Row(
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: element.declaration.name,
                                  style: kMonoFont.copyWith(
                                    color: kSecondaryColor,
                                  ),
                                ),
                                const TextSpan(text: ' '),
                                TextSpan(
                                  text: emptyArgs ? '' : '($formattedArgs)',
                                  style: kMonoFont.copyWith(
                                    color: kSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Text(element.function.description),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: kOnSecondaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: element.isComplete
                                    ? Text(
                                        prettyJson(element.response),
                                        style: kMonoFont.copyWith(
                                            color: kSecondaryColor),
                                      )
                                    : const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 5,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              kSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ],
    );
  }

  @override
  _LlmStatefulElementViewState createState() => _LlmStatefulElementViewState();
}

class _LlmStatefulElementViewState
    extends _LlmElementViewState<LlmFunctionElement> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: widget.element,
        builder: (context, _) {
          return Builder(
            builder: (context) {
              return widget.builder?.call(widget.element) ??
                  widget.build(context);
            },
          );
        });
  }
}

abstract class LlmElementView<T extends LlmElement> extends StatefulWidget {
  const LlmElementView(
    this.element, {
    super.key,
    required this.builder,
  });

  final Widget? Function(T)? builder;

  final T element;

  Widget build(BuildContext context);

  @override
  State<LlmElementView<T>> createState() => _LlmElementViewState<T>();
}

class _LlmElementViewState<T extends LlmElement>
    extends State<LlmElementView<T>> {
  _LlmElementViewState();
  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      final elementWidget = widget.builder!(widget.element);
      if (elementWidget != null) {
        return elementWidget;
      }
    }
    return widget.build(context);
  }
}
