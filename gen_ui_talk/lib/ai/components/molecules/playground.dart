import 'package:flutter/material.dart';

class PlaygroundPage extends StatelessWidget {
  const PlaygroundPage({
    super.key,
    required this.leftWidget,
    required this.rightWidget,
    this.leftFlex = 1,
    this.rightFlex = 1,
    required this.sampleInputs,
    required this.onSampleSelected,
  });

  final void Function(String) onSampleSelected;
  final Widget leftWidget;
  final Widget rightWidget;
  final List<String> sampleInputs;

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
      bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: true,
          iconSize: 0,
          showUnselectedLabels: true,
          onTap: (value) {
            onSampleSelected(sampleInputs[value]);
          },
          items: sampleInputs.map((e) {
            return BottomNavigationBarItem(
              backgroundColor: Colors.white,
              label: e,
              icon: const Icon(Icons.code),
            );
          }).toList()),
    );
  }
}
