// 11 – New font family support (Lato)
//
// Ensures that selecting a new font family propagates through ThemeData.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec_center_interview/main.dart';
import 'package:rec_center_interview/settings.dart';
import 'package:rec_center_interview/home_feed_notifier.dart';

void main() {
  testWidgets('Selecting Lato updates ThemeData.fontFamily', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeFeedProvider.overrideWith(
            (ref) =>
                HomeFeedNotifier()..state = const HomeFeed(isLoading: false),
          ),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pump();

    // Access the provider container above MyApp.
    final ctx = tester.element(find.byType(MyApp));
    final container = ProviderScope.containerOf(ctx, listen: false);

    // Mutate settings.
    container.read(settingsProvider.notifier).setFontFamily('Lato');
    await tester.pump();

    final updatedCtx = tester.element(find.byType(MyApp));
    expect(Theme.of(updatedCtx).textTheme.bodyMedium!.fontFamily, 'Lato');
  });
}
