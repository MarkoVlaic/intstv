class HAScene {
  String entityId;
  HASceneAttributes attributes;

  HAScene({required this.entityId, required this.attributes});

  factory HAScene.fromJson(Map<String, dynamic> json) {
    return HAScene(
      entityId: json['entity_id'],
      attributes: HASceneAttributes.fromJson(json['attributes']),
    );
  }
}

class HASceneAttributes {
  List<String> entityIds;
  String friendlyName;

  HASceneAttributes({
    required this.entityIds,
    required this.friendlyName,
  });

  factory HASceneAttributes.fromJson(Map<String, dynamic> json) {
    return HASceneAttributes(
      entityIds: List<String>.from(json['entity_id']),
      friendlyName: json['friendly_name'],
    );
  }
}
