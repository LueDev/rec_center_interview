import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_feed_notifier.dart';
import 'widgets/event_card.dart';
import 'widgets/news_card.dart';
import 'settings.dart';
import 'screens/settings_screen.dart';
import 'screens/event_form_screen.dart';
import 'screens/news_form_screen.dart';

class HomeScreenAssignment extends ConsumerStatefulWidget {
  const HomeScreenAssignment({super.key});

  @override
  ConsumerState<HomeScreenAssignment> createState() =>
      _HomeScreenAssignmentState();
}

class _HomeScreenAssignmentState extends ConsumerState<HomeScreenAssignment> {
  @override
  void initState() {
    super.initState();
    // Trigger initial load only if still loading.
    final feed = ref.read(homeFeedProvider);
    if (feed.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(homeFeedProvider.notifier).loadImmediate();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final feed = ref.watch(homeFeedProvider);
    // ignore: avoid_print
    print(
      'HomeScreen build loading=${feed.isLoading} events=${feed.events.length}',
    );
    final notifier = ref.read(homeFeedProvider.notifier);
    // Only show news that reference an existing event (avoid "orphan" news).
    final validNews =
        feed.news
            .where(
              (n) =>
                  n.eventId != null &&
                  feed.events.any((e) => e.id == n.eventId),
            )
            .toList();

    Widget body;

    if (feed.error != null && feed.error!.isNotEmpty) {
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(feed.error!, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: notifier.load,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else if (feed.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = RefreshIndicator(
        onRefresh: notifier.load,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Text('Events', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...feed.events.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: EventCard(event: e),
              ),
            ),
            const SizedBox(height: 24),
            Text('News', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...validNews.map(
              (n) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: NewsCard(news: n),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Toggle theme',
            onPressed: () => ref.read(settingsProvider.notifier).toggleMode(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final choice = await showModalBottomSheet<String>(
            context: context,
            builder:
                (ctx) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.event),
                      title: const Text('Add Event'),
                      onTap: () => Navigator.pop(ctx, 'event'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.article),
                      title: const Text('Add News'),
                      onTap: () => Navigator.pop(ctx, 'news'),
                    ),
                  ],
                ),
          );
          if (!mounted) return;
          if (choice == 'event') {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const EventFormScreen()));
          } else if (choice == 'news') {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const NewsFormScreen()));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
