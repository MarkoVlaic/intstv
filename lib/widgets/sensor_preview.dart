import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luminar_control_app/models/ha_entity_state.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SensorPreview extends ConsumerStatefulWidget {
  final HaEntityState? lightState;

  const SensorPreview(this.lightState, {super.key});

  @override
  ConsumerState<SensorPreview> createState() => _SensorPreviewState();
}

class _SensorPreviewState extends ConsumerState<SensorPreview> {
  @override
  Widget build(BuildContext context) {
    //humidity icon
    Icon icon2 = const Icon(Icons.water_drop_outlined);
    List<String> tokens = widget.lightState!.name.split('_');
    bool isTempSensor = tokens.contains('temperature');
    if (tokens.contains('light')) {
      icon2 = const Icon(Icons.light_mode_outlined);
      // ignore: curly_braces_in_flow_control_structures
    } else if (isTempSensor) icon2 = const Icon(Icons.thermostat);
    return widget.lightState != null
        ? Card(
            color: Theme.of(context).colorScheme.inversePrimary,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          icon2,
                          const SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: CircularPercentIndicator(
                      backgroundColor: Theme.of(context).colorScheme.onSecondary,
                      radius: 50.0,
                      lineWidth: 5.0,
                      animation: true,
                      animationDuration: 700,
                      percent: (widget.lightState!.state != "unavailable" && widget.lightState!.state != "unknown")
                          ? double.parse(widget.lightState!.state) / 100
                          : 0,
                      center: Text('${widget.lightState!.state.substring(0, 4)} ${isTempSensor ? '°C' : '%'}'),
                      progressColor: Theme.of(context).colorScheme.primary,
                      curve: Curves.decelerate,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          )
        : Container();
  }
}
