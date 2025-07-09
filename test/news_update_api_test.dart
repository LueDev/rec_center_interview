/// 14 – updateNews should modify state & call RemoteApi.updateNews

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec_center_interview/home_feed_notifier.dart';
import 'package:rec_center_interview/models/news.dart';
import 'package:rec_center_interview/data/remote_api.dart';

class FakeApi extends UnimplementedRemoteApi {
  int updateNewsCalls = 0;
  @override
  Future<void> updateNews(News news) async => updateNewsCalls++;
}

void main() {
  test('updateNews updates state and hits API', () async {
    final api = FakeApi();
    final container = ProviderContainer(
      overrides: [remoteApiProvider.overrideWithValue(api)],
    );
    addTearDown(container.dispose);

    final notifier = container.read(homeFeedProvider.notifier);
    await notifier.loadImmediate();

    final eventId = notifier.state.events.first.id;
    final news = News(
      id: 'nEdit',
      title: 'Old',
      description: '',
      date: DateTime.now(),
      category: '',
      imageUrl: '',
      eventId: eventId,
    );
    await notifier.addNews(news);

    final updated = news.copyWith(title: 'New');
    await notifier.updateNews(updated);

    expect(
      notifier.state.news.firstWhere((n) => n.id == 'nEdit').title,
      'New',
      reason: 'Title should update in state',
    );
    expect(
      api.updateNewsCalls,
      greaterThan(0),
      reason: 'Notifier should call RemoteApi.updateNews',
    );
  });
}
