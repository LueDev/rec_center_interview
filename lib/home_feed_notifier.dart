import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/event.dart';
import 'models/news.dart';
import 'data/local_db.dart';

class HomeFeed {
  const HomeFeed({
    this.events = const [],
    this.news = const [],
    this.isLoading = true,
    this.error,
  });

  final List<Event> events;
  final List<News> news;
  final bool isLoading;
  final String? error;

  HomeFeed copyWith({
    List<Event>? events,
    List<News>? news,
    bool? isLoading,
    String? error,
  }) {
    return HomeFeed(
      events: events ?? this.events,
      news: news ?? this.news,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class HomeFeedNotifier extends StateNotifier<HomeFeed> {
  HomeFeedNotifier() : super(const HomeFeed());

  // Loads data – here we mock a small list after a short delay.
  Future<void> load() async {
    // ignore: avoid_print
    print('HomeFeedNotifier.load()');
    // Emit loading state
    state = state.copyWith(isLoading: true, error: null);

    try {
      final data = await LocalDb.read().timeout(
        const Duration(milliseconds: 100),
        onTimeout: () {
          // ignore: avoid_print
          print('LocalDb.read() timed out – returning empty');
          return (events: <Event>[], news: <News>[]);
        },
      );
      await Future.delayed(const Duration(milliseconds: 300));

      if (data.events.isEmpty && data.news.isEmpty) {
        // ignore: avoid_print
        print('load() data empty, emit mock');
        _emitMockData();
        await LocalDb.write(state.events, state.news);
      } else {
        // Remove orphan news (those without a matching event)
        final filteredNews =
            data.news
                .where(
                  (n) =>
                      n.eventId != null &&
                      data.events.any((e) => e.id == n.eventId),
                )
                .toList();

        state = state.copyWith(
          events: data.events,
          news: filteredNews,
          isLoading: false,
          error: null,
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print('load() error fallback $e');
      _emitMockData();
    }
  }

  // Immediately emits data without artificial delay – handy for initial UI build
  Future<void> loadImmediate() async {
    // ignore: avoid_print
    print('HomeFeedNotifier.loadImmediate()');

    state = state.copyWith(isLoading: true, error: null);

    try {
      final data = await LocalDb.read().timeout(
        const Duration(milliseconds: 100),
        onTimeout: () {
          // ignore: avoid_print
          print('LocalDb.read() timed out – returning empty (immediate)');
          return (events: <Event>[], news: <News>[]);
        },
      );

      if (data.events.isNotEmpty || data.news.isNotEmpty) {
        // ignore: avoid_print
        print('loadImmediate got data events=${data.events.length}');
        // Remove orphan news (those without a matching event)
        final filteredNews =
            data.news
                .where(
                  (n) =>
                      n.eventId != null &&
                      data.events.any((e) => e.id == n.eventId),
                )
                .toList();

        state = state.copyWith(
          events: data.events,
          news: filteredNews,
          isLoading: false,
          error: null,
        );
      } else {
        // ignore: avoid_print
        print('loadImmediate _emitMockData');
        _emitMockData();
        await LocalDb.write(state.events, state.news);
      }
    } catch (e) {
      // If any error occurs (e.g. file system not accessible in tests), emit
      // mock data instead of propagating an error so the UI can still render.
      // ignore: avoid_print
      print('loadImmediate fallback due to error: $e');
      _emitMockData();
    }
  }

  // Generates mock Events & News and sets loaded state
  void _emitMockData() {
    final events = [
      Event(
        id: 'e1',
        title: 'Morning Yoga',
        date: DateTime.now().add(const Duration(days: 1)),
        location: 'Studio A',
        imageUrl: '',
        level: 'Beginner',
        capacity: 10,
      ),
      Event(
        id: 'e2',
        title: 'Basketball Pickup',
        date: DateTime.now().add(const Duration(days: 2)),
        location: 'Court 1',
        imageUrl: '',
        level: 'All',
        capacity: 8,
      ),
    ];

    final news = [
      News(
        id: 'n1',
        title: 'Gym Renovation Complete',
        description: 'The new weight room is now open.',
        date: DateTime.now(),
        category: 'Facilities',
        imageUrl: '',
        eventId: 'e1', // ensure this news is linked to an existing event
      ),
    ];

    state = state.copyWith(
      events: events,
      news: news,
      isLoading: false,
      error: null,
    );
  }

  Future<void> addEvent(Event e) async {
    // TODO(Interview): Implement this method to add [e] to [state.events]
    // and persist the change. The notifier_crud_test expects the new event
    // to be present after calling this method.
  }

  Future<void> addNews(News n) async {
    // TODO(Interview): Validate eventId and add news to [state.news].
  }

  // Adds or removes an attendee placeholder to an event (by id).
  Future<void> changeAttendeeCount(String eventId, int delta) async {
    // TODO(Interview): Update attendee list respecting capacity limits.
  }

  Future<void> updateEvent(Event updated) async => _replaceEvent(updated);

  Future<void> deleteEvent(String id) async {
    // TODO(Interview): Remove the event and cascade delete linked news.
  }

  Future<void> _replaceEvent(Event updated) async {
    // TODO(Interview): Replace existing event in list and persist.
  }

  /// Removes a news item by id and persists the change.
  Future<void> deleteNews(String id) async {
    // TODO(Interview): Implement delete logic.
  }

  /// Replaces an existing news item with an updated version and persists.
  Future<void> updateNews(News updated) async {
    // TODO(Interview): Implement update logic for news.
  }
}

final homeFeedProvider = StateNotifierProvider<HomeFeedNotifier, HomeFeed>((
  ref,
) {
  return HomeFeedNotifier();
});
