import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class WidgetResponseProvider extends InheritedWidget {
  final bool isRunning;

  const WidgetResponseProvider({
    super.key,
    required this.isRunning,
    required super.child,
  });

  static WidgetResponseProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<WidgetResponseProvider>()!;

  @override
  bool updateShouldNotify(WidgetResponseProvider oldWidget) =>
      oldWidget.isRunning != isRunning;
}

WidgetResponseProvider useRunnableUiResponseProvider() {
  final context = useContext();
  return WidgetResponseProvider.of(context);
}

bool isActiveWidget() {
  final provider = useRunnableUiResponseProvider();
  return provider.isRunning;
}
