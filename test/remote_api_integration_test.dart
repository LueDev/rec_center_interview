/// 12 – Remote API not wired
///
/// The app should call the RemoteApi when creating Events & News. This test
/// fails until that logic is implemented in HomeFeedNotifier.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rec_center_interview/home_feed_notifier.dart';
import 'package:rec_center_interview/models/event.dart';
import 'package:rec_center_interview/models/news.dart';
import 'package:rec_center_interview/data/remote_api.dart';

class FakeRemoteApi extends RemoteApi {
  int createEventCalls = 0;
  int createNewsCalls = 0;
  @override
  Future<void> createEvent(Event event) async => createEventCalls++;
  @override
  Future<void> createNews(News news) async => createNewsCalls++;
  @override
  Future<void> deleteEvent(String eventId) async {}
  @override
  Future<void> deleteNews(String newsId) async {}
  @override
  Future<void> updateEvent(Event event) async {}
  @override
  Future<void> updateNews(News news) async {}
}

void main() {
  test('addEvent / addNews should invoke RemoteApi', () async {
    final fakeApi = FakeRemoteApi();

    final container = ProviderContainer(overrides: [
      remoteApiProvider.overrideWithValue(fakeApi),
    ]);
    addTearDown(container.dispose);

    final notifier = container.read(homeFeedProvider.notifier);
    await notifier.loadImmediate();

    final newEvent = Event(
      id: 'eXYZ',
      title: 'Test event',
      date: DateTime.now(),
      location: 'Here',
      imageUrl: '',
      level: 'All',
      capacity: 5,
    );
    await notifier.addEvent(newEvent);

    final newNews = News(
      id: 'nXYZ',
      title: 'Linked',
      description: '',
      date: DateTime.now(),
      category: 'Cat',
      imageUrl: '',
      eventId: newEvent.id,
    );
    await notifier.addNews(newNews);

    expect(fakeApi.createEventCalls, greaterThan(0),
        reason: 'HomeFeedNotifier.addEvent should call RemoteApi.createEvent');
    expect(fakeApi.createNewsCalls, greaterThan(0),
        reason: 'HomeFeedNotifier.addNews should call RemoteApi.createNews');
  });
} 