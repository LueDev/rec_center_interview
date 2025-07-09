/// 04 – Attendee counter logic
///
/// Ensures changeAttendeeCount respects capacity and never drops below zero.

import 'package:flutter_test/flutter_test.dart';
import 'package:rec_center_interview/home_feed_notifier.dart';

void main() {
  group('Event attendee count', () {
    late HomeFeedNotifier notifier;

    setUp(() async {
      notifier = HomeFeedNotifier();
      await notifier.loadImmediate();
    });

    test('Adding and removing attendees respects capacity', () async {
      final event = notifier.state.events.first;
      final id = event.id;
      final capacity = event.capacity;

      // Fill to capacity
      for (var i = 0; i < capacity; i++) {
        await notifier.changeAttendeeCount(id, 1);
      }
      expect(
        notifier.state.events.firstWhere((e) => e.id == id).attendees.length,
        capacity,
      );

      // Extra add should have no effect
      await notifier.changeAttendeeCount(id, 1);
      expect(
        notifier.state.events.firstWhere((e) => e.id == id).attendees.length,
        capacity,
      );

      // Remove one
      await notifier.changeAttendeeCount(id, -1);
      expect(
        notifier.state.events.firstWhere((e) => e.id == id).attendees.length,
        capacity - 1,
      );
    });
  });
}
