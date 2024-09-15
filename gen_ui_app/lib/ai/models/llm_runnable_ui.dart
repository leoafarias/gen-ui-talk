import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RunnableUiDataProvider extends InheritedWidget {
  final bool isRunning;

  const RunnableUiDataProvider({
    super.key,
    required this.isRunning,
    required super.child,
  });

  static RunnableUiDataProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RunnableUiDataProvider>()!;

  @override
  bool updateShouldNotify(RunnableUiDataProvider oldWidget) =>
      oldWidget.isRunning != isRunning;
}

RunnableUiDataProvider useRunnableUiResponseProvider() {
  final context = useContext();
  return RunnableUiDataProvider.of(context);
}

bool useIsRunning() {
  final provider = useRunnableUiResponseProvider();
  return provider.isRunning;
}
