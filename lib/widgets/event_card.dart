import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event.dart';
import '../home_feed_notifier.dart';
import '../screens/event_form_screen.dart';

class EventCard extends ConsumerWidget {
  const EventCard({super.key, required this.event});
  final Event event;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(homeFeedProvider.notifier);
    return Card(
      elevation: 2,
      child: Row(
        children: [
          if (event.imageUrl.isNotEmpty)
            Image.network(
              event.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(width: 80, height: 80, color: Colors.grey),
            )
          else
            Container(width: 80, height: 80, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  event.location,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 18),
                onPressed: () => notifier.changeAttendeeCount(event.id, -1),
              ),
              Text(
                '${event.attendees.length}/${event.capacity}',
                style: const TextStyle(fontSize: 12),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 18),
                onPressed: () => notifier.changeAttendeeCount(event.id, 1),
              ),
            ],
          ),
          PopupMenuButton<String>(
            onSelected: (v) async {
              if (v == 'delete') {
                await notifier.deleteEvent(event.id);
              } else if (v == 'edit') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EventFormScreen(initial: event),
                  ),
                );
              }
            },
            itemBuilder:
                (ctx) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
