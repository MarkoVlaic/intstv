import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luminar_control_app/models/ha_scene.dart';

class ScenesProvider extends StateNotifier<List<HAScene>> {
  ScenesProvider() : super([]);

  void setScenes(List<HAScene> entityStates) {
    state = entityStates;
  }

  HAScene? getSceneById(String sceneID) {
    return state.firstWhere((entity) => entity.entityId == sceneID);
  }
}

final scenesProvider = StateNotifierProvider<ScenesProvider, List<HAScene>>(
  (ref) => ScenesProvider(),
);
