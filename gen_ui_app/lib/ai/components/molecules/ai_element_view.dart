import 'package:flutter/material.dart';

import '../../helpers.dart';
import '../../models/ai_response.dart';
import '../../style.dart';
import '../atoms/message_bubble.dart';

class AiTextElementView extends AiElementView<AiTextElement> {
  const AiTextElementView(
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

abstract class AiWidgetElementView<T>
    extends AiStatefulElementElementView<AiWidgetElement<T>>
    with AiWidgetElementMixin<T> {
  const AiWidgetElementView(
    super.element, {
    super.key,
    super.builder,
  });

  @override
  Widget build(BuildContext context);
}

mixin AiWidgetElementMixin<T>
    on AiStatefulElementElementView<AiWidgetElement<T>> {
  Future<void> exec(JSON args) async {
    await element.exec(args);
  }

  AiFunctionStatus get status => element.status;

  bool get isRunning => status == AiFunctionStatus.running;

  bool get isIdle => status == AiFunctionStatus.idle;

  bool get isError => status == AiFunctionStatus.error;

  Object? get error => element.error;

  bool get isDone => status == AiFunctionStatus.done;
}

class AiFunctionElementView
    extends AiStatefulElementElementView<AiFunctionElement> {
  const AiFunctionElementView(
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
                                  text: element.function.name,
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
}

class AiStatefulElementProvider extends InheritedNotifier {
  const AiStatefulElementProvider({
    super.key,
    required super.notifier,
    required super.child,
  });

  static AiStatefulElementProvider of<T extends AiStatefulElement>(
      BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AiStatefulElementProvider>()!;
  }
}

abstract class AiStatefulElementElementView<T extends AiStatefulElement>
    extends AiElementView<T> {
  const AiStatefulElementElementView(
    super.element, {
    super.key,
    super.builder,
  });

  @override
  Widget build(BuildContext context);

  @override
  State<AiElementView<T>> createState() => _AiStatefulElementViewState<T>();
}

class _AiStatefulElementViewState<T extends AiStatefulElement>
    extends _AiElementViewState<T> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: widget.element,
        builder: (context, _) {
          return AiStatefulElementProvider(
            notifier: widget.element,
            child: Builder(
              builder: (context) {
                return widget.build(context);
              },
            ),
          );
        });
  }
}

abstract class AiElementView<T extends AiElement> extends StatefulWidget {
  const AiElementView(
    this.element, {
    super.key,
    required this.builder,
  });

  final Widget? Function(T)? builder;

  final T element;

  Widget build(BuildContext context);

  @override
  State<AiElementView<T>> createState() => _AiElementViewState<T>();
}

class _AiElementViewState<T extends AiElement> extends State<AiElementView<T>> {
  _AiElementViewState();
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
