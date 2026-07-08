import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:superdeck/superdeck.dart';
import 'package:superdeck_core/superdeck_core.dart';

Widget buildSuperDeckApp(DeckOptions options) {
  final workspace = DeckWorkspace();

  // Flutter run starts in the project directory, where SuperDeck's file loader
  // supports live rebuilds. Direct .app launches start elsewhere and need the
  // bundled deck asset instead.
  if (workspace.deckJson.existsSync()) return SuperDeckApp(options: options);

  return SuperDeckApp(
    options: options,
    deckLoader: BundledAssetDeckLoader(workspace: workspace),
    workspace: workspace,
  );
}

class BundledAssetDeckLoader extends DeckLoader {
  BundledAssetDeckLoader({DeckWorkspace? workspace})
    : workspace = workspace ?? DeckWorkspace();

  final DeckWorkspace workspace;
  final _controller = StreamController<SlidesEvent>();

  Future<void>? _loadTask;
  Future<void>? _disposeTask;
  var _started = false;
  var _disposed = false;

  @override
  Stream<SlidesEvent> load() {
    if (!_started && !_disposed) {
      _started = true;
      _loadTask = _emitLoad();
    }
    return _controller.stream;
  }

  @override
  Future<void> reload() async {
    if (_disposed) return;
    await (_loadTask ?? Future<void>.value());
    if (_disposed) return;
    _loadTask = _emitLoad();
    await _loadTask;
  }

  @override
  Future<void> dispose() {
    return _disposeTask ??= _dispose();
  }

  Future<void> _emitLoad() async {
    if (_disposed || _controller.isClosed) return;

    _controller.add(SlidesLoadingEvent('Loading bundled slides...'));
    try {
      final content = await rootBundle.loadString(
        workspace.bundledDeckJsonPath,
      );
      if (_disposed || _controller.isClosed) return;
      _controller.add(_decodeSlides(content));
    } on Object catch (error) {
      if (_disposed || _controller.isClosed) return;
      _controller.add(
        SlidesErrorEvent(
          'SuperDeck reference error',
          error: error is Exception ? error : Exception(error.toString()),
        ),
      );
    }
  }

  SlidesLoadedEvent _decodeSlides(String content) {
    final decoded = jsonDecode(content);
    if (decoded is! List) {
      throw FormatException(
        'Expected JSON array in ${workspace.bundledDeckJsonPath}, '
        'got ${decoded.runtimeType}',
      );
    }
    return SlidesLoadedEvent(parseSlidesContract(decoded));
  }

  Future<void> _dispose() async {
    if (_disposed) return;
    _disposed = true;
    await (_loadTask ?? Future<void>.value());
    await _controller.close();
  }
}
