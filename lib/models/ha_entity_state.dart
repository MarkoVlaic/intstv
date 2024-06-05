class HaEntityState {
  Map<String, dynamic> attributes;
  String entityId;
  String roomId;
  String domain;
  String lastChanged;
  String state;
  String name;

  HaEntityState({
    required this.attributes,
    required this.entityId,
    required this.roomId,
    required this.lastChanged,
    required this.state,
    required this.domain,
    required this.name,
  });

  factory HaEntityState.fromJson(Map<String, dynamic> json) {
    return HaEntityState(
      attributes: json['attributes'] ?? {},
      entityId: json['entity_id'],
      roomId: (json['entity_id'].split('.')[1]).split('_').first,
      domain: json['entity_id'].split('.').first,
      name: json['entity_id'].split('.')[1],
      lastChanged: json['last_changed'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['attributes'] = attributes;
    data['entity_id'] = entityId;
    data['last_changed'] = lastChanged;
    data['state'] = state;
    return data;
  }
}
