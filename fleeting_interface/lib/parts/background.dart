import 'package:flutter/material.dart';
import 'package:mesh/mesh.dart';
import 'package:superdeck/superdeck.dart';

 OMeshRect _meshBuilder(List<Color> colors) {
  return OMeshRect(
    width: 4,
    height: 4,
    fallbackColor: const Color(0xff0e0e0e),
    backgroundColor: const Color(0x00d6d6d6),
    vertices: [
      (0.0, 0.0).v, (1 / 3, 0.0).v, (2 / 3, 0.0).v, (1.0, 0.0).v, // Row 1

      (0.0, 1 / 3).v,
      (1 / 3, 1 / 3).v,
      (2 / 3, 1 / 3).v,
      (1.0, 1 / 3).v, // Row 2

      (0.0, 2 / 3).v,
      (1 / 3, 2 / 3).v,
      (2 / 3, 2 / 3).v,
      (1.0, 2 / 3).v, // Row 3

      (0.0, 1.0).v, (1 / 3, 1.0).v, (2 / 3, 1.0).v, (1.0, 1.0).v, // Row 4
    ],
    colors: colors,
  );
}

class BackgroundPart extends StatelessWidget {
  const BackgroundPart({super.key});

  @override
  Widget build(BuildContext context) {
    final configuration = SlideConfiguration.of(context);

    return Stack(
      children: [
        _AnimatedSwitcherOMesh(slide: configuration),
      ],
    );
  }
}

// animate bwett colors and previous colors in duration
class _AnimatedSwitcherOMesh extends StatefulWidget {
  final SlideConfiguration slide;

  const _AnimatedSwitcherOMesh({required this.slide});

  @override
  _AnimatedSwitcherOMeshState createState() => _AnimatedSwitcherOMeshState();
}

class _AnimatedSwitcherOMeshState extends State<_AnimatedSwitcherOMesh>
    with SingleTickerProviderStateMixin {
  late List<Color> _colors;

  final _duration = const Duration(milliseconds: 1000);

  @override
  void initState() {
    super.initState();
    _colors = _determiniscOrderBasedOnIndex(widget.slide.slideIndex);
  }

  @override
  void didUpdateWidget(covariant _AnimatedSwitcherOMesh oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.slide.slideIndex != oldWidget.slide.slideIndex) {
      setState(() {
        _colors = _determiniscOrderBasedOnIndex(widget.slide.slideIndex);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOMeshGradient(
      mesh: _meshBuilder(_colors),
      duration: _duration,
    );
  }
}

// Color palette for radial gradient (purple/magenta to orange/yellow)
const _yellow = Color(0xffFFB347); // Orange-yellow
const _orange = Color(0xffFF6B6B); // Red-orange
const _magenta = Color(0xffE91E63); // Magenta
const _purple = Color(0xff9C27B0); // Purple
const _deepPurple = Color(0xff673AB7); // Deep purple

// Calculate Manhattan distance between two positions in 4x4 grid
int _manhattanDistance(int pos1, int pos2) {
  final x1 = pos1 % 4;
  final y1 = pos1 ~/ 4;
  final x2 = pos2 % 4;
  final y2 = pos2 ~/ 4;
  return (x1 - x2).abs() + (y1 - y2).abs();
}

List<Color> _determiniscOrderBasedOnIndex(int index) {
  // Rotate yellow position clockwise around outer edges (avoid inner 2x2 center)
  // 4x4 grid: top-left → top-center-left → top-center-right → top-right →
  //           right-center-top → right-center-bottom → bottom-right →
  //           bottom-center-right → bottom-center-left → bottom-left →
  //           left-center-bottom → left-center-top
  final outerPositions = [0, 1, 2, 3, 7, 11, 15, 14, 13, 12, 8, 4];
  final yellowPos = outerPositions[index % outerPositions.length];

  // Build consistent radial gradient from yellow position
  final meshColors = <Color>[];

  for (int i = 0; i < 16; i++) {
    final distance = _manhattanDistance(i, yellowPos);

    // Assign color based on distance from yellow (radial gradient)
    final color = switch (distance) {
      0 => _yellow, // Yellow/orange origin
      1 => _orange, // Adjacent positions
      2 => _magenta, // 2 steps away
      3 => _purple, // 3 steps away
      _ => _deepPurple, // 4+ steps away (farthest/extreme)
    };

    meshColors.add(color);
  }

  return meshColors;
}
