import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luminar_control_app/models/ha_entity_state.dart';
import 'package:luminar_control_app/providers/ha_service_provider.dart';

class LightControl extends ConsumerStatefulWidget {
  final HaEntityState? lightState;

  const LightControl(this.lightState, {super.key});

  @override
  ConsumerState<LightControl> createState() => _LightControlState();
}

class _LightControlState extends ConsumerState<LightControl> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final haService = ref.watch(haServiceProvider);
    bool isOn = widget.lightState?.state == 'on';
    Color iconColor = isOn ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.inversePrimary;
    return widget.lightState != null
        ? Card(
            color: isOn
                ? Theme.of(context).colorScheme.inversePrimary
                : Theme.of(context).colorScheme.secondaryContainer.withOpacity(.2),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.light, color: iconColor),
                          const SizedBox(width: 10),
                          Container(
                            constraints: BoxConstraints(maxWidth: (size.width * .7) / 2),
                            child: Text(
                              widget.lightState!.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: isOn,
                        onChanged: (newState) {
                          setState(() {
                            if (widget.lightState?.state == 'on') {
                              widget.lightState?.state = 'off';
                            } else {
                              widget.lightState?.state = 'on';
                            }
                          });
                          haService.executeService(widget.lightState!.entityId, 'toggle');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 200,
                  )
                ],
              ),
            ),
          )
        : Container();
  }
}
