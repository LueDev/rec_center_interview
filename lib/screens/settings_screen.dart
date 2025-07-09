import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _seedOptions = <Color>[
    Colors.indigo,
    Colors.teal,
    Colors.deepPurple,
    Colors.orange,
    Colors.pink,
  ];

  static const _fontOptions = <String>[
    'System',
    'Roboto',
    'Serif',
    'Monospace',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Dark mode'),
            value: settings.mode == ThemeMode.dark,
            onChanged: (_) => notifier.toggleMode(),
          ),
          const SizedBox(height: 24),
          Text('Seed color', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children:
                _seedOptions.map((color) {
                  final selected = settings.seedColor == color;
                  return ChoiceChip(
                    label: const SizedBox(width: 24, height: 24),
                    selected: selected,
                    selectedColor: color,
                    backgroundColor: color.withOpacity(0.3),
                    shape: const CircleBorder(),
                    onSelected: (_) => notifier.setSeedColor(color),
                  );
                }).toList(),
          ),
          const SizedBox(height: 24),
          Text('Text size', style: Theme.of(context).textTheme.titleMedium),
          Slider(
            value: settings.textScaleFactor,
            min: 0.8,
            max: 1.3,
            divisions: 5,
            label: settings.textScaleFactor.toStringAsFixed(1),
            onChanged: notifier.setTextScale,
          ),

          const SizedBox(height: 24),
          Text('Font family', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children:
                _fontOptions.map((f) {
                  final selected = settings.fontFamily == f;
                  return ChoiceChip(
                    label: Text(
                      f,
                      style: TextStyle(fontFamily: f == 'System' ? null : f),
                    ),
                    selected: selected,
                    onSelected: (_) => notifier.setFontFamily(f),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
