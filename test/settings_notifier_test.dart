/// 10 – Settings integration
///
/// Checks that SettingsNotifier mutates state AND that MyApp rebuilds with the
/// new values (text scale, font family, seed color).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec_center_interview/main.dart';
import 'package:rec_center_interview/settings.dart';
import 'package:rec_center_interview/home_screen_assignment.dart';
import 'package:rec_center_interview/home_feed_notifier.dart';

void main() {
  group('Settings functionality', () {
    test('StateNotifier mutates values', () {
      final notifier = SettingsNotifier();
      notifier.setTextScale(1.2);
      expect(notifier.state.textScaleFactor, closeTo(1.2, 0.01));
      notifier.setFontFamily('Roboto');
      expect(notifier.state.fontFamily, 'Roboto');
      notifier.setSeedColor(Colors.teal);
      expect(notifier.state.seedColor, Colors.teal);
    });

    testWidgets('UI reflects font size, family and seed color', (tester) async {
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

      BuildContext ctx = tester.element(find.byType(MyApp));
      final container = ProviderScope.containerOf(ctx, listen: false);

      // Change font family
      container.read(settingsProvider.notifier).setFontFamily('Roboto');
      await tester.pump();
      ctx = tester.element(find.byType(MyApp));
      expect(Theme.of(ctx).textTheme.bodyMedium!.fontFamily, 'Roboto');

      // Change text scale
      container.read(settingsProvider.notifier).setTextScale(1.25);

      await pumpUntil(tester, () {
        final innerCtx = tester.element(find.byType(HomeScreenAssignment));
        return MediaQuery.of(innerCtx).textScaleFactor > 1.1;
      });

      final innerCtx = tester.element(find.byType(HomeScreenAssignment));
      expect(MediaQuery.of(innerCtx).textScaleFactor, closeTo(1.25, 0.01));

      // Change seed color
      final before = container.read(settingsProvider).seedColor;
      container.read(settingsProvider.notifier).setSeedColor(Colors.orange);
      await tester.pump();
      expect(container.read(settingsProvider).seedColor, isNot(equals(before)));
    });
  });
}

Future<void> pumpUntil(
  WidgetTester tester,
  bool Function() condition, {
  Duration step = const Duration(milliseconds: 20),
  Duration max = const Duration(seconds: 2),
}) async {
  var elapsed = Duration.zero;
  while (!condition() && elapsed < max) {
    await tester.pump(step);
    elapsed += step;
  }
}
