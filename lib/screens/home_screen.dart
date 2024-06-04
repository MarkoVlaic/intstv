import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luminar_control_app/providers/screen_index_provider.dart';
import 'package:luminar_control_app/screens/floor_plan_screen.dart';
import 'package:luminar_control_app/screens/settings_screen.dart';
import 'package:luminar_control_app/home_assistant_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  final List<Widget> screensList = const [FloorPlanScreen(), SettingsScreen()];
  final List<String> screenNames = const ["Control", "Settings"];

  //PROMJENITI ZA LOKALNO TESTIRANJE
  final HSUrl = "http://localhost:8123";
  final HStoken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiIwN2EwMTE5NmQ0YWQ0Yjk5YWViZWEzODE5MmQ4ZDBiMCIsImlhdCI6MTcxNzQ5OTgzMywiZXhwIjoyMDMyODU5ODMzfQ.n5xZFksIZtUIhV7IIH0cirnIdLzGjfo7X2xonKNDI0Y";

  Future<void> _fetchScenes(BuildContext context) async {
    final haService = HomeAssistantService(HSUrl, HStoken);
    try {
      final scenes = await haService.fetchScenes();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Fetched Scenes'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: scenes.map((scene) {
                return ListTile(
                  title: Text(scene['entity_id']),
                  trailing: IconButton(
                    icon: Icon(Icons.lightbulb),
                    onPressed: () => _fetchSceneDevices(context, scene['entity_id']),
                  ),
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _fetchSceneDevices(BuildContext context, String sceneId) async {
    final haService = HomeAssistantService(HSUrl, HStoken);
    try {
      final devices = await haService.fetchSceneDevices(sceneId);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Devices in $sceneId'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: devices.map((device) {
                return ListTile(
                  title: Text(device),
                  trailing: IconButton(
                    icon: Icon(Icons.power),
                    onPressed: () => _turnOnDevice(context, device),
                  ),
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }


  Future<void> _turnOnDevice(BuildContext context, String deviceId) async {
    final haService = HomeAssistantService(HSUrl, HStoken);
    try {
      await haService.turnOnOrOffDevice(deviceId, 'off');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Turned on $deviceId')),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
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
        actions: [
          IconButton(
            icon: Icon(Icons.cloud_download),
            onPressed: () => _fetchScenes(context),
          ),
        ],
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
