/*
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luminar_control_app/models/ha_entity_state.dart';

class EntityStatesProvider extends StateNotifier<List<HaEntityState>?> {
  EntityStatesProvider() : super(null);

  void setEntityStates(List<HaEntityState> entityStates) {
    state = entityStates;
  }

  void changeEntityState(HaEntityState oldEntitySate, HaEntityState newEntitySate) {
    List<HaEntityState> updatedEntityStates = List.from(state!);
    updatedEntityStates[updatedEntityStates.indexOf(oldEntitySate)] = newEntitySate;
    state = updatedEntityStates;
  }

  HaEntityState? getEntityStateByEntityId(String entityID) {
    return state?.firstWhere((entity) => entity.entityId == entityID);
  }
}

final entityStatesProvider = StateNotifierProvider<EntityStatesProvider, List<HaEntityState>?>(
  (ref) => EntityStatesProvider(),
);

final entityStateProviderByID = Provider.family<HaEntityState?, String>((ref, entityID) {
  final entityStates = ref.watch(entityStatesProvider);

  final filteredEntityState = entityStates?.firstWhere((entity) => entity.entityId == entityID);

  return filteredEntityState;
});

final entityIdsProviderByRoomID = Provider.family<List<String>?, String>((ref, roomID) {
  final entityStates = ref.watch(entityStatesProvider);

  final filteredEntityState = entityStates?.where((entity) => entity.roomId == roomID).toList();

  return filteredEntityState?.map((entity) => entity.entityId).toList();
});
*/