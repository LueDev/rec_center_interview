/// 02 – Notifier initial state
///
/// Sanity-check for the HomeFeedNotifier constructor.
/// The UI shows a spinner while `isLoading == true`, so make sure the
/// default state reflects that. All CRUD tests depend on this baseline.

import 'package:flutter_test/flutter_test.dart';
import 'package:rec_center_interview/home_feed_notifier.dart';

void main() {
  test('initial state is loading', () {
    final notifier = HomeFeedNotifier();
    expect(notifier.state.isLoading, true);
  });
}
