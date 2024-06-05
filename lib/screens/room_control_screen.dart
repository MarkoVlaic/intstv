import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luminar_control_app/models/ha_entity_state.dart';
import 'package:luminar_control_app/providers/ha_service_provider.dart';
import 'package:luminar_control_app/services/home_assistant_service.dart';
import 'package:luminar_control_app/widgets/light_control.dart';

class RoomControlScreen extends ConsumerWidget {
  const RoomControlScreen({
    super.key,
    required this.entityIDs,
    required this.frendlyName,
  });

  final List<String> entityIDs;
  final String frendlyName;

  Future<List<HaEntityState>> _fetchDevices(HomeAssistantService haService, List<String> entityIDs) async {
    List<HaEntityState> data = [];
    for (String id in entityIDs) {
      final HaEntityState state = await haService.fetchEntityState(id);
      data.add(state);
    }
    return data;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final haService = ref.watch(haServiceProvider);
    return FutureBuilder<List<HaEntityState>>(
      future: _fetchDevices(haService, entityIDs),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator while waiting for the data
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle error state
          return Text('Error: ${snapshot.error}');
        } else {
          // Data has been loaded successfully
          final List<HaEntityState> devices = snapshot.data!;
          // Use the entityStates list to build your UI
          return Center(
            child: Opacity(
              opacity: .9,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                padding: const EdgeInsets.all(10),
                width: size.width * .7,
                height: size.height * .6,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    // physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(frendlyName, style: Theme.of(context).textTheme.headlineMedium),
                        Container(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          height: .5,
                          width: double.infinity,
                        ),
                        ...devices.map(
                          (entity) {
                            if (entity.domain == 'light') {
                              return LightControl(entity);
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
