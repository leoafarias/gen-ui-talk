import 'package:flutter/material.dart';
import 'package:flutter_genui/flutter_genui.dart';
import 'package:logging/logging.dart';

import 'travel_example/src/travel_planner_page.dart';

class TravelExampleWidget extends StatefulWidget {
  const TravelExampleWidget({super.key});

  @override
  State<TravelExampleWidget> createState() => _TravelExampleWidgetState();
}

class _TravelExampleWidgetState extends State<TravelExampleWidget> {
  static bool _loggingConfigured = false;
  late final Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _initializeTravelExample();
  }

  Future<void> _initializeTravelExample() async {
    await loadImagesJson();
    if (!_loggingConfigured) {
      final logger = configureGenUiLogging(level: Level.INFO);
      logger.onRecord.listen((record) {
        // ignore: avoid_print
        print('[travel_example] ${record.level.name}: ${record.message}');
      });
      _loggingConfigured = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100, maxHeight: 720),
            child: Material(
              elevation: 12,
              borderRadius: BorderRadius.circular(32),
              clipBehavior: Clip.antiAlias,
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
                ),
                child: const TravelPlannerPage(),
              ),
            ),
          ),
        );
      },
    );
  }
}
