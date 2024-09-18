import 'package:flutter/material.dart';

import '../../helpers.dart';
import '../../models/ai_response.dart';
import '../../style.dart';
import '../atoms/alert_dialog.dart';
import '../atoms/message_bubble.dart';

class AiTextElementView extends AiElementView<AiTextElement> {
  const AiTextElementView(
    super.element, {
    super.key,
    super.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          flex: 6,
          child: MessageBubble(
            text: element.text.trim(),
            style: MessageBubbleStyle(
              textStyle: chatTheme.textStyle.copyWith(
                color: chatTheme.onBackGroundColor,
              ),
              backgroundColor: const Color.fromARGB(255, 26, 26, 26),
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

abstract class AiWidgetElementView
    extends AiStatefulElementElementView<AiWidgetElement>
    with AiWidgetElementMixin {
  const AiWidgetElementView(
    super.element, {
    super.key,
    super.builder,
  });

  @override
  Widget build(BuildContext context);
}

mixin AiWidgetElementMixin on AiStatefulElementElementView<AiWidgetElement> {
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
    return Expanded(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.bolt,
                color: Colors.green,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'function',
                      style: chatTheme.textStyle.copyWith(
                        color: Colors.green,
                      ),
                    ),
                    Text(element.function.description),
                    const SizedBox(height: 6),
                    Text(
                      '${element.function.name}(${prettyJson(element.arguments)})',
                      style: chatTheme.textStyle
                          .copyWith(color: chatTheme.accentColor),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.code),
                      label: Text(
                        'View response',
                        style: chatTheme.textStyle
                            .copyWith(color: chatTheme.accentColor),
                      ),
                      onPressed: () {
                        showWidgetDetails(
                          context,
                          title: 'Response',
                          contents: element.response,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: chatTheme.accentColor,
                        elevation: 0,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
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
