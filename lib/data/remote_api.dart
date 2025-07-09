// Simple abstraction for remote server interactions.
// Only POST requests are relevant for the interview starter – candidates must
// call these methods from the appropriate notifiers.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event.dart';
import '../models/news.dart';

abstract class RemoteApi {
  Future<void> createEvent(Event event);
  Future<void> createNews(News news);
  Future<void> updateEvent(Event event);
  Future<void> updateNews(News news);
  Future<void> deleteEvent(String eventId);
  Future<void> deleteNews(String newsId);
}

/// Default placeholder implementation – immediately throws to signal that
/// network logic is *not* yet wired. Candidates should replace or extend this
/// with real HTTP calls.
class UnimplementedRemoteApi implements RemoteApi {
  Never _err(String m) => throw UnimplementedError(m);
  @override
  Future<void> createEvent(Event event) async => _err('createEvent');
  @override
  Future<void> createNews(News news) async => _err('createNews');
  @override
  Future<void> updateEvent(Event event) async => _err('updateEvent');
  @override
  Future<void> updateNews(News news) async => _err('updateNews');
  @override
  Future<void> deleteEvent(String eventId) async => _err('deleteEvent');
  @override
  Future<void> deleteNews(String newsId) async => _err('deleteNews');
}

final remoteApiProvider = Provider<RemoteApi>((_) => UnimplementedRemoteApi());
