import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luminar_control_app/providers/scenes_provider.dart';
import 'package:luminar_control_app/screens/room_control_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FloorPlanScreen extends ConsumerWidget {
  const FloorPlanScreen({super.key});

  static const List<double> heightTopDividers = [3, 4, 6.5, 13];
  static const List<double> widthLeftDividers = [1.4, 6, 1.85, 6];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenes = ref.watch(scenesProvider);
    Size screenSize = MediaQuery.of(context).size;
    double imageHorizontalPadding = 50;
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50, width: double.infinity),
          Text(
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
            AppLocalizations.of(context)!.trackAndManageYourHome,
          ),
          const SizedBox(height: 50, width: double.infinity),
          Center(
            child: Stack(
              children: [
                Center(
                  child: Image.asset(
                    'assets/floor_plan/floor_plan_p.png',
                    width: screenSize.width - imageHorizontalPadding,
                  ),
                ),
                ...scenes.asMap().entries.map(
                  (entry) {
                    final index = entry.key;
                    final scene = entry.value;
                    return Positioned(
                      top: screenSize.height / heightTopDividers[index],
                      left: screenSize.width / widthLeftDividers[index],
                      child: Opacity(
                        opacity: .8,
                        child: SizedBox(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(minimumSize: const Size(30, 40)),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return RoomControlScreen(
                                    entityIDs: scene.attributes.entityIds,
                                    frendlyName: scene.attributes.friendlyName,
                                  );
                                },
                              );
                            },
                            child: const Icon(Icons.light),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                /*
                Positioned(
                  top: screenSize.height / 13,
                  left: screenSize.width / 6,
                  child: Opacity(
                    opacity: .8,
                    child: SizedBox(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(minimumSize: const Size(30, 40)),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return RoomControlScreen(entityIDs: scenes.first.attributes.entityIds);
                            },
                          );
                        },
                        child: const Icon(Icons.light),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenSize.height / 6.5,
                  left: screenSize.width / 1.85,
                  child: Opacity(
                    opacity: .8,
                    child: SizedBox(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(minimumSize: const Size(30, 40)),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return RoomControlScreen(entityIDs: scenes[1].attributes.entityIds);
                            },
                          );
                        },
                        child: const Icon(Icons.light),
                      ),
                    ),
                  ),
                ),
                */
              ],
            ),
          ),
        ],
      ),
    );
  }
}
