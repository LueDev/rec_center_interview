/// ─────────────────────────────
/// 01 – Event model basics
///
/// This test asserts pure data model behaviour – no provider or UI involved.
/// Requirements:
///   • `isFull` returns true ONLY when `attendees.length == capacity`.
///   • `copyWith()` preserves untouched fields.
///   • JSON round-trips correctly (fromJson ⭢ toJson).
/// If this fails, fix `lib/models/event.dart` before moving on – later tests
/// assume a correct model.
/// ─────────────────────────────

import 'package:flutter_test/flutter_test.dart';
import 'package:rec_center_interview/models/event.dart';

void main() {
  group('Event model', () {
    test('isFull returns false when capacity not reached', () {
      final event = Event(
        id: '1',
        title: 'Test',
        date: DateTime.now(),
        location: 'Park',
        imageUrl: '',
        level: 'Beginner',
        capacity: 5,
        attendees: ['a', 'b'],
      );
      expect(event.isFull, isFalse);
    });

    test('isFull returns true when capacity reached', () {
      final event = Event(
        id: '2',
        title: 'Full',
        date: DateTime.now(),
        location: 'Gym',
        imageUrl: '',
        level: 'Pro',
        capacity: 2,
        attendees: ['x', 'y'],
      );
      expect(event.isFull, isTrue);
    });
  });
}
