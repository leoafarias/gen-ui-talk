import 'package:flutter/material.dart';
import 'package:flutter_genui/flutter_genui.dart';
import 'package:logging/logging.dart';

import 'catalog.dart';
import 'travel_planner_page.dart';

const _title = 'Agentic Travel Inc';

class TravelAppDemo extends StatefulWidget {
  const TravelAppDemo({super.key});

  @override
  State<TravelAppDemo> createState() => _TravelAppDemoState();
}

class _TravelAppDemoState extends State<TravelAppDemo> {
  late final Future<void> _loadFuture;

  @override
  void initState() {
    super.initState();
    _loadFuture = _initialize();
  }

  Future<void> _initialize() async {
    configureGenUiLogging(level: Level.INFO);
    await loadImagesJson();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Failed to load travel assets: ${snapshot.error}'),
          );
        }
        return const TravelApp();
      },
    );
  }
}

class TravelApp extends StatelessWidget {
  const TravelApp({super.key, this.contentGenerator});

  final ContentGenerator? contentGenerator;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: _TravelAppBody(contentGenerator),
    );
  }
}

class _TravelAppBody extends StatelessWidget {
  const _TravelAppBody(this.contentGenerator);

  final ContentGenerator? contentGenerator;

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'Travel': TravelPlannerPage(contentGenerator: contentGenerator),
      'Widget Catalog': const CatalogTab(),
    };
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          leading: const Icon(Icons.menu),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.local_airport),
              SizedBox(width: 16.0),
              Text(_title),
            ],
          ),
          actions: const [Icon(Icons.person_outline), SizedBox(width: 8.0)],
          bottom: TabBar(
            tabs: tabs.entries.map((entry) => Tab(text: entry.key)).toList(),
          ),
        ),
        body: TabBarView(
          children: tabs.entries.map((entry) => entry.value).toList(),
        ),
      ),
    );
  }
}

class CatalogTab extends StatefulWidget {
  const CatalogTab({super.key});

  @override
  State<CatalogTab> createState() => _CatalogTabState();
}

class _CatalogTabState extends State<CatalogTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DebugCatalogView(catalog: travelAppCatalog);
  }

  @override
  bool get wantKeepAlive => true;
}
