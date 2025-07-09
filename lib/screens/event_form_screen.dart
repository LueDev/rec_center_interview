import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event.dart';
import '../home_feed_notifier.dart';

class EventFormScreen extends ConsumerStatefulWidget {
  const EventFormScreen({super.key, this.initial});

  final Event? initial;

  @override
  ConsumerState<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends ConsumerState<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _locationController;
  late int _capacity;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    final e = widget.initial;
    _titleController = TextEditingController(text: e?.title ?? '');
    _locationController = TextEditingController(text: e?.location ?? '');
    _capacity = e?.capacity ?? 1;
    _date = e?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initial == null ? 'Create Event' : 'Edit Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                controller: _titleController,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Location'),
                controller: _locationController,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Capacity'),
                keyboardType: TextInputType.number,
                initialValue: _capacity.toString(),
                validator:
                    (v) =>
                        (int.tryParse(v ?? '') ?? 0) < 1
                            ? 'Enter number ≥1'
                            : null,
                onSaved: (v) => _capacity = int.parse(v!),
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _submit, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final _title = _titleController.text;
    final _location = _locationController.text;
    _formKey.currentState!.save();

    if (widget.initial == null) {
      final event = Event(
        id: 'e${DateTime.now().millisecondsSinceEpoch}',
        title: _title,
        date: _date,
        location: _location,
        imageUrl: '',
        level: 'All',
        capacity: _capacity,
      );
      ref.read(homeFeedProvider.notifier).addEvent(event);
    } else {
      final updated = widget.initial!.copyWith(
        title: _title,
        location: _location,
        capacity: _capacity,
      );
      ref.read(homeFeedProvider.notifier).updateEvent(updated);
    }
    Navigator.pop(context);
  }
}
