import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luminar_control_app/providers/language_provider.dart';
import 'package:luminar_control_app/providers/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLightThemeAactive = ref.watch(themeProvider);
    final language = ref.watch(languageProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(height: 25),
            Text(AppLocalizations.of(context)!.general, style: Theme.of(context).textTheme.headlineMedium),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              color: Theme.of(context).colorScheme.onSurface,
              height: 1.5,
              width: double.infinity,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${AppLocalizations.of(context)!.language}:'),
                    DropdownMenu<Language>(
                      initialSelection: language,
                      enableSearch: false,
                      width: 150,
                      inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
                            isDense: true,
                          ),
                      dropdownMenuEntries:
                          Language.values.map((entry) => DropdownMenuEntry(value: entry, label: entry.name)).toList(),
                      onSelected: (value) {
                        ref.read(languageProvider.notifier).updateLanguage(value!);
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 100),
            Text(AppLocalizations.of(context)!.theme, style: Theme.of(context).textTheme.headlineMedium),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              color: Theme.of(context).colorScheme.onSurface,
              height: 1.5,
              width: double.infinity,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${AppLocalizations.of(context)!.lightTheme}:'),
                Row(
                  children: [
                    const Text('Off'),
                    Switch(
                      value: isLightThemeAactive,
                      onChanged: (newVall) => ref.read(themeProvider.notifier).switchTheme(),
                      activeColor: Theme.of(context).colorScheme.primary,
                      // activeTrackColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    const Text('On'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
