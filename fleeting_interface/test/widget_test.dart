import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:superdeck/superdeck.dart';
import 'package:superdeck_core/superdeck_core.dart';

void main() {
  testWidgets('SuperDeck app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      SuperDeckApp(
        options: DeckOptions(debug: false),
        deckLoader: _FakeDeckLoader(),
        workspace: DeckWorkspace(),
      ),
    );
    await tester.pump();

    expect(find.byType(SuperDeckApp), findsOneWidget);
  });
}

final class _FakeDeckLoader extends DeckLoader {
  const _FakeDeckLoader();

  @override
  Stream<SlidesEvent> load() {
    return Stream.value(
      SlidesLoadedEvent([
        Slide(
          key: 'smoke-test',
          sections: [SectionBlock.text('Smoke test slide')],
        ),
      ]),
    );
  }

  @override
  Future<void> reload() async {}

  @override
  Future<void> dispose() async {}
}
