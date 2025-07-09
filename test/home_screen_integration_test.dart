/// 08 – HomeScreen happy flow
///
/// Ensures spinner disappears after loading and lists render section headers
/// plus cards. Relies on working notifier CRUD and mock data.

@Timeout(Duration(seconds: 20))
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec_center_interview/home_screen_assignment.dart';

void main() {
  testWidgets('HomeScreen displays data after load', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: HomeScreenAssignment())),
    );

    // Initial loading indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait until loading spinner disappears (max 4s)
    await pumpUntil(tester, () => tester.any(find.text('Events')));

    // Expect at least one event and one news item rendered
    expect(find.text('Events'), findsOneWidget);
    expect(find.text('News'), findsOneWidget);

    // There should be at least one ListTile / Card from the lists
    expect(find.byType(Card), findsWidgets);
  });
}

Future<void> pumpUntil(
  WidgetTester tester,
  bool Function() condition, {
  Duration step = const Duration(milliseconds: 50),
  Duration max = const Duration(seconds: 4),
}) async {
  var elapsed = Duration.zero;
  while (!condition() && elapsed < max) {
    await tester.pump(step);
    elapsed += step;
  }
}
