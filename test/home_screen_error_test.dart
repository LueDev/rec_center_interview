/// 07 – Error banner behaviour
///
/// When HomeFeed state.error is non-null, the UI should display the message
/// and a ‘Retry’ button wired to notifier.load().

@Timeout(Duration(seconds: 4))
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec_center_interview/home_feed_notifier.dart';
import 'package:rec_center_interview/home_screen_assignment.dart';

class _ErrorNotifier extends HomeFeedNotifier {
  _ErrorNotifier() {
    state = const HomeFeed(
      isLoading: false,
      events: [],
      news: [],
      error: 'boom',
    );
  }

  @override
  Future<void> load() async {}
}

void main() {
  testWidgets('HomeScreen shows error banner when error present', (
    tester,
  ) async {
    final notifier = _ErrorNotifier();
    notifier.state = const HomeFeed(
      isLoading: false,
      events: [],
      news: [],
      error: 'boom',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [homeFeedProvider.overrideWith((ref) => notifier)],
        child: const MaterialApp(home: HomeScreenAssignment()),
      ),
    );

    await tester.pump();

    expect(find.textContaining('boom'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
