/// 05 – EventCard surface test
///
/// Pure widget test: validates that the title and location strings render and
/// that capacity text is present. No provider actions verified here.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec_center_interview/models/event.dart';
import 'package:rec_center_interview/widgets/event_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('EventCard shows title and capacity info', (tester) async {
    final event = Event(
      id: '1',
      title: 'Basketball',
      date: DateTime.now(),
      location: 'Court',
      imageUrl: '',
      level: 'All',
      capacity: 10,
      attendees: ['1', '2', '3'],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: Scaffold(body: EventCard(event: event))),
      ),
    );

    expect(find.text('Basketball'), findsOneWidget);
    expect(find.text('Court'), findsOneWidget);
    expect(find.text('3/10'), findsOneWidget);
  });
}
