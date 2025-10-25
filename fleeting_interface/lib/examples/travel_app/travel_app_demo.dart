import 'package:flutter/material.dart';

import 'travel_planner_page.dart';

/// A demo wrapper for the Travel App example in the presentation.
class TravelAppDemo extends StatefulWidget {
  const TravelAppDemo({super.key});

  @override
  State<TravelAppDemo> createState() => _TravelAppDemoState();
}

class _TravelAppDemoState extends State<TravelAppDemo> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await loadImagesJson();
    if (mounted) {
      setState(() {
        _initialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return const TravelPlannerPage();
  }
}
