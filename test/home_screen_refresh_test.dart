import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec_center_interview/home_screen_assignment.dart';
import 'package:rec_center_interview/home_feed_notifier.dart';
import 'package:rec_center_interview/models/event.dart';
import 'package:rec_center_interview/models/news.dart';

/// 09 – Pull-to-refresh wiring
///
/// Verifies that a drag-down gesture calls HomeFeedNotifier.load() again.
@Timeout(Duration(seconds: 4))
class _SpyNotifier extends HomeFeedNotifier {
  int loadCalls = 0;

  @override
  Future<void> load() async {
    loadCalls++;
    state = HomeFeed(
      isLoading: false,
      events: [
        Event(
          id: 'e',
          title: 'Ping Pong',
          date: DateTime.now(),
          location: 'Hall',
          imageUrl: '',
          level: 'All',
          capacity: 4,
        ),
      ],
      news: [
        News(
          id: 'n',
          title: 'News',
          description: 'desc',
          date: DateTime.now(),
          category: 'General',
          imageUrl: '',
        ),
      ],
    );
  }
}

void main() {
  testWidgets('Pull-to-refresh triggers load again', (tester) async {
    final spy = _SpyNotifier();
    await spy.load(); // initial data

    await tester.pumpWidget(
      ProviderScope(
        overrides: [homeFeedProvider.overrideWith((ref) => spy)],
        child: const MaterialApp(home: HomeScreenAssignment()),
      ),
    );

    // settle initial frame
    await pumpUntil(tester, () => tester.any(find.text('Ping Pong')));
    expect(spy.loadCalls, 1);

    // drag down to trigger RefreshIndicator
    await tester.drag(find.byType(ListView), const Offset(0, 300));
    await tester.pump(); // start indicator

    // finish refresh (wait until load called again)
    await pumpUntil(tester, () => spy.loadCalls >= 2);

    expect(spy.loadCalls, greaterThanOrEqualTo(2));
  });
}

Future<void> pumpUntil(
  WidgetTester tester,
  bool Function() condition, {
  Duration step = const Duration(milliseconds: 50),
  Duration max = const Duration(seconds: 4),
}) async {
  var elapsed = Duration.zero;
  while (!condition() && elapsed < max) {
    await tester.pump(step);
    elapsed += step;
  }
}
