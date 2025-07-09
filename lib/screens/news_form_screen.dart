import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/news.dart';
import '../home_feed_notifier.dart';

class NewsFormScreen extends ConsumerStatefulWidget {
  const NewsFormScreen({super.key, this.initial});

  /// If provided, the form will edit the existing [News] object instead of
  /// creating a new one.
  final News? initial;

  @override
  ConsumerState<NewsFormScreen> createState() => _NewsFormScreenState();
}

class _NewsFormScreenState extends ConsumerState<NewsFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _title;
  late String _description;
  late String _category;
  late String? _selectedEventId;

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      _title = widget.initial!.title;
      _description = widget.initial!.description;
      _category = widget.initial!.category;
      _selectedEventId = widget.initial!.eventId;
    } else {
      _title = '';
      _description = '';
      _category = '';
      _selectedEventId = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(homeFeedProvider).events;

    final isEditing = widget.initial != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit News' : 'Create News')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (events.isEmpty)
                const Text('No events available. Create an event first.'),
              if (events.isNotEmpty)
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Related Event'),
                  items:
                      events
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.title),
                            ),
                          )
                          .toList(),
                  value: _selectedEventId,
                  onChanged: (v) => setState(() => _selectedEventId = v),
                  validator: (v) => v == null ? 'Required' : null,
                ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                initialValue: _title,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                onSaved: (v) => _title = v!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                initialValue: _description,
                onSaved: (v) => _description = v ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Category'),
                initialValue: _category,
                onSaved: (v) => _category = v ?? '',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: Text(isEditing ? 'Update' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final notifier = ref.read(homeFeedProvider.notifier);

    if (widget.initial == null) {
      // Create new
      final news = News(
        id: 'n${DateTime.now().millisecondsSinceEpoch}',
        title: _title,
        description: _description,
        date: DateTime.now(),
        category: _category,
        imageUrl: '',
        eventId: _selectedEventId,
      );
      notifier.addNews(news);
    } else {
      // Update existing
      final updated = widget.initial!.copyWith(
        title: _title,
        description: _description,
        category: _category,
        eventId: _selectedEventId,
      );
      notifier.updateNews(updated);
    }

    Navigator.pop(context);
  }
}
