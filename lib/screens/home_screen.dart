import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luminar_control_app/providers/screen_index_provider.dart';
import 'package:luminar_control_app/screens/floor_plan_screen.dart';
import 'package:luminar_control_app/screens/settings_screen.dart';
// import 'package:luminar_control_app/home_assistant_service.dart';
// import '../env/env.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  final List<Widget> screensList = const [FloorPlanScreen(), SettingsScreen()];
  final List<String> screenNames = const ["Control", "Settings"];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenIndex = ref.watch(screenIndexProvider);
    Widget activeScreen = screensList[screenIndex];
    String screenTitle = screenNames[screenIndex];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: Text(
          screenTitle,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        unselectedItemColor: Theme.of(context).colorScheme.inversePrimary,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.light_mode), label: 'control'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'settings'),
        ],
        currentIndex: screenIndex,
        onTap: (idx) => ref.read(screenIndexProvider.notifier).changeScreenIindex(idx),
      ),
      body: activeScreen,
    );
  }
}
