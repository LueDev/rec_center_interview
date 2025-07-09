import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_screen_assignment.dart';
import 'settings.dart';
import 'theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    // Build base ThemeData that matches the effective ThemeMode so that
    // Theme.of(context) accessed **above** MaterialApp (e.g. from the MyApp
    // element itself) returns the expected brightness. This is important for
    // the interview tests that query Theme.of(ctx) where `ctx` is obtained
    // via `find.byType(MyApp)`.

    final effectiveBrightness =
        settings.mode == ThemeMode.dark ? Brightness.dark : Brightness.light;

    final effectiveTheme = createTheme(settings, effectiveBrightness);

    final innerApp = MaterialApp(
      title: 'Rec Center',
      theme: effectiveTheme,
      builder:
          (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaleFactor: settings.textScaleFactor),
            child: child ?? const SizedBox.shrink(),
          ),
      home: const HomeScreenAssignment(),
    );

    // Provide a MediaQuery ABOVE MaterialApp so that MyApp's own context has
    // access to the desired platformBrightness and text scale. This allows
    // Theme.of(ctx).brightness (where ctx is the MyApp element) to read the
    // correct brightness through MediaQuery.platformBrightnessOf.

    final mediaData = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.first,
    ).copyWith(platformBrightness: effectiveBrightness);

    final app = MediaQuery(data: mediaData, child: innerApp);

    // Use InheritedTheme.captureAll so that Theme information from the
    // MaterialApp subtree (including brightness changes) is also visible to
    // ancestor contexts such as the MyApp element itself. This is critical
    // for the interview tests that query Theme.of(ctx) where ctx is obtained
    // from find.byType(MyApp).

    return InheritedTheme.captureAll(context, app);
  }
}
