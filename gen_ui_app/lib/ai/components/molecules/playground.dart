import 'package:flutter/material.dart';

class PlaygroundPage extends StatelessWidget {
  const PlaygroundPage({
    super.key,
    required this.leftWidget,
    required this.rightWidget,
    this.leftFlex = 1,
    this.rightFlex = 1,
  });

  final Widget leftWidget;
  final Widget rightWidget;

  final int leftFlex;
  final int rightFlex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: leftFlex,
            child: leftWidget,
          ),
          Expanded(
            flex: rightFlex,
            child: rightWidget,
          )
        ],
      ),
    );
  }
}
