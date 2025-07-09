/// 03 – Notifier CRUD & cascade
///
/// This file verifies that HomeFeedNotifier implements create, update, delete
/// for both Events and News, and that deleting an Event removes its linked
/// News. Later widget tests depend on these mutations working.

import 'package:flutter_test/flutter_test.dart';
import 'package:rec_center_interview/home_feed_notifier.dart';
import 'package:rec_center_interview/models/event.dart';
import 'package:rec_center_interview/models/news.dart';

void main() {
  group('HomeFeedNotifier CRUD', () {
    late HomeFeedNotifier notifier;

    setUp(() async {
      notifier = HomeFeedNotifier();
      await notifier.loadImmediate();
    });

    test('add / update / delete Event', () async {
      final e = Event(
        id: 'eX',
        title: 'Chess',
        date: DateTime.now(),
        location: 'Room',
        imageUrl: '',
        level: 'All',
        capacity: 4,
      );

      await notifier.addEvent(e);
      expect(notifier.state.events.any((ev) => ev.id == 'eX'), isTrue);

      final updated = e.copyWith(title: 'Chess Club');
      await notifier.updateEvent(updated);
      expect(
        notifier.state.events.firstWhere((ev) => ev.id == 'eX').title,
        'Chess Club',
      );

      await notifier.deleteEvent('eX');
      expect(notifier.state.events.any((ev) => ev.id == 'eX'), isFalse);
    });

    test('add / update / delete News', () async {
      final eventId = notifier.state.events.first.id;
      final n = News(
        id: 'nX',
        title: 'Announcement',
        description: 'Details',
        date: DateTime.now(),
        category: 'General',
        imageUrl: '',
        eventId: eventId,
      );

      await notifier.addNews(n);
      expect(notifier.state.news.any((nw) => nw.id == 'nX'), isTrue);

      final updated = n.copyWith(title: 'Updated');
      await notifier.updateNews(updated);
      expect(
        notifier.state.news.firstWhere((nw) => nw.id == 'nX').title,
        'Updated',
      );

      await notifier.deleteNews('nX');
      expect(notifier.state.news.any((nw) => nw.id == 'nX'), isFalse);
    });

    test('Cascade delete event removes linked news', () async {
      final event = notifier.state.events.first;
      final news = News(
        id: 'nCascade',
        title: 'Linked',
        description: 'desc',
        date: DateTime.now(),
        category: 'Gen',
        imageUrl: '',
        eventId: event.id,
      );
      await notifier.addNews(news);
      expect(notifier.state.news.any((n) => n.id == 'nCascade'), isTrue);

      await notifier.deleteEvent(event.id);
      expect(notifier.state.news.any((n) => n.id == 'nCascade'), isFalse);
    });
  });
}
