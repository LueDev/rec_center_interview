/// 13 – Delete cascade + RemoteApi
///
/// Deleting an event should cascade to news AND hit RemoteApi.deleteEvent.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec_center_interview/home_feed_notifier.dart';
import 'package:rec_center_interview/models/news.dart';
import 'package:rec_center_interview/data/remote_api.dart';

class FakeApi extends UnimplementedRemoteApi {
  int deleteCalls = 0;
  @override
  Future<void> deleteEvent(String eventId) async => deleteCalls++;
}

void main() {
  test('deleteEvent cascades & calls API', () async {
    final api = FakeApi();
    final container = ProviderContainer(
      overrides: [remoteApiProvider.overrideWithValue(api)],
    );
    addTearDown(container.dispose);

    final notifier = container.read(homeFeedProvider.notifier);
    await notifier.loadImmediate();

    final event = notifier.state.events.first;
    // Attach news to ensure cascade
    final news = News(
      id: 'nCascade',
      title: 'Linked',
      description: '',
      date: DateTime.now(),
      category: '',
      imageUrl: '',
      eventId: event.id,
    );
    await notifier.addNews(news);

    await notifier.deleteEvent(event.id);

    expect(
      notifier.state.news.any((n) => n.id == 'nCascade'),
      isFalse,
      reason: 'Deleting event should also remove linked news',
    );
    expect(
      api.deleteCalls,
      greaterThan(0),
      reason: 'Notifier should call RemoteApi.deleteEvent',
    );
  });
}
