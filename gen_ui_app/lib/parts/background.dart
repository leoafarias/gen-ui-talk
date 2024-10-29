import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mesh/mesh.dart';
import 'package:superdeck/superdeck.dart';

OMeshRect _meshBuilder(List<Color> colors) {
  return OMeshRect(
    width: 3,
    height: 3,
    fallbackColor: const Color(0xff0e0e0e),
    backgroundColor: const Color(0x00d6d6d6),
    vertices: [
      (0.0, 0.0).v, (0.5, 0.0).v, (1.0, 0.0).v, // Row 1

      (0.0, 0.5).v, (0.5, 0.5).v, (1.0, 0.5).v, // Row 2

      (0.0, 1.0).v, (0.5, 1.0).v, (1.0, 1.0).v, // Row 3
    ],
    colors: colors,
  );
}

class BackgroundPart extends SlidePart {
  const BackgroundPart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final configuration = Provider.of<SlideData>(context);
    return _AnimatedSwitcherOMesh(
      index: configuration.slideIndex,
      duration: const Duration(milliseconds: 1000),
    );
  }
}

// animate bwett colors and previous colors in duration
class _AnimatedSwitcherOMesh extends StatefulWidget {
  final int index;

  final Duration duration;

  const _AnimatedSwitcherOMesh({
    required this.duration,
    required this.index,
  });

  @override
  _AnimatedSwitcherOMeshState createState() => _AnimatedSwitcherOMeshState();
}

class _AnimatedSwitcherOMeshState extends State<_AnimatedSwitcherOMesh>
    with SingleTickerProviderStateMixin {
  late List<Color> _colors;
  int _step = 0;
  int _previousStep = 0;
  int _twoStepsBack = 0;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    final previousColors =
        _determiniscOrderBasedOnIndex(widget.index - 1, _buildColors);
    final nextColors =
        _determiniscOrderBasedOnIndex(widget.index, _buildColors);
    _colors = previousColors;

    Future.delayed(const Duration(milliseconds: 300), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_hasStarted && widget.index == 0) {
          _hasStarted = true;
          _randomizeColors();
        } else {
          _colors = nextColors;
        }
      });
    });
  }

  Future<void> _randomizeColors() {
    if (!mounted) return Future.value();
    final movementColors = [..._buildColors]..shuffle();

    int nextStep = _getNextIndex(_step);

    while (nextStep == _previousStep || nextStep == _twoStepsBack) {
      nextStep = _getNextIndex(_step);
    }

    movementColors[nextStep] = const Color.fromARGB(255, 6, 97, 82);

    _updateSteps(nextStep);

    setState(() {
      _colors = movementColors;
    });

    return Future.delayed(widget.duration, _randomizeColors);
  }

  void _updateSteps(int currentStep) {
    _previousStep = _step;
    _twoStepsBack = _previousStep;
    _step = currentStep;
  }

  int _getNextIndex(int currentIndex) {
    final List<int> validIndices = _getAdjacentIndices(currentIndex);
    final random = Random();
    final randomIndex = random.nextInt(validIndices.length);
    return validIndices[randomIndex];
  }

  List<int> _getAdjacentIndices(int currentIndex) {
    final List<int> adjacentIndices = [];

    // Calculate the row and column of the current index
    final row = currentIndex ~/ 3;
    final col = currentIndex % 3;

    // Define the possible movements: up, down, left, right
    final List<List<int>> movements = [
      [-1, 0], // Up
      [1, 0], // Down
      [0, -1], // Left
      [0, 1], // Right
      [-1, -1], // Up-left
      [-1, 1], // Up-right
      [1, -1], // Down-left
      [1, 1], // Down-right
    ];

    // Iterate through the movements and add valid adjacent indices
    for (final movement in movements) {
      final newRow = row + movement[0];
      final newCol = col + movement[1];

      // Check if the new row and column are within the valid range
      if (newRow >= 0 && newRow < 3 && newCol >= 0 && newCol < 3) {
        final newIndex = newRow * 3 + newCol;
        adjacentIndices.add(newIndex);
      }
    }

    return adjacentIndices;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOMeshGradient(
      mesh: _meshBuilder(_colors),
      duration: widget.duration,
    );
  }
}

final _buildColors = [
  const Color.fromARGB(255, 5, 5, 28),
  const Color.fromARGB(255, 5, 5, 5),
  const Color.fromARGB(255, 3, 19, 48),
  const Color.fromARGB(255, 41, 12, 56),
  const Color.fromARGB(255, 5, 5, 5),
  const Color.fromARGB(255, 5, 5, 5),
  const Color.fromARGB(255, 17, 0, 63),
  const Color.fromARGB(255, 0, 0, 0),
  const Color.fromARGB(255, 5, 5, 5),
];
List<Color> _determiniscOrderBasedOnIndex(int index, List<Color> colors) {
  return colors.sublist(index % colors.length)
    ..addAll(colors.sublist(0, index % colors.length));
}
