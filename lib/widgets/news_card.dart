import 'package:flutter/material.dart';
import '../models/news.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../home_feed_notifier.dart';
import '../screens/news_form_screen.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({super.key, required this.news});
  final News news;

  @override
  Widget build(BuildContext context) {
    HomeFeedNotifier? notifier;
    try {
      final container = ProviderScope.containerOf(context, listen: false);
      notifier = container.read(homeFeedProvider.notifier);
    } catch (_) {
      // No provider in widget tree (unit tests). Actions will be disabled.
    }

    return Card(
      elevation: 2,
      child: ListTile(
        leading: Image.network(
          news.imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) =>
                  Container(width: 60, height: 60, color: Colors.grey),
        ),
        title: Text(news.title),
        subtitle: Text(news.category),
        trailing:
            notifier == null
                ? null
                : PopupMenuButton<String>(
                  onSelected: (v) async {
                    if (notifier == null) return;
                    if (v == 'delete') {
                      await notifier.deleteNews(news.id);
                    } else if (v == 'edit') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => NewsFormScreen(initial: news),
                        ),
                      );
                    }
                  },
                  itemBuilder:
                      (ctx) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                ),
      ),
    );
  }
}
