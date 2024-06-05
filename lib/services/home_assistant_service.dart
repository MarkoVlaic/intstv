import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:luminar_control_app/models/ha_entity_state.dart';
import 'package:luminar_control_app/models/ha_scene.dart';

class HomeAssistantService {
  final String _baseUrl;
  final String _token;

  HomeAssistantService(this._baseUrl, this._token);

  final List<String> implementedEntitityIDs = ['light.bedroom_light', 'number.bedroom_temperature'];

  Future<List<HaEntityState>> fetchEntityStates() async {
    final url = Uri.parse('$_baseUrl/api/states');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        log(response.body);
        return data.map((entity) => HaEntityState.fromJson(entity)).toList();
      } else {
        throw Exception('Failed to fetch states: GET /api/states');
      }
    } catch (e) {
      debugPrint('Here->fetchEntityStates'); //
      throw Exception(e);
    }
  }

  Future<HaEntityState> fetchEntityState(String entityId) async {
    // /api/states/sensor.kitchen_temperature
    final url = Uri.parse('$_baseUrl/api/states/$entityId');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final dynamic jsonData = jsonDecode(response.body);
        return HaEntityState.fromJson(jsonData);
      } else {
        throw Exception('Failed to fetch entity state: GET /api/states/<entity_id>');
      }
    } catch (e) {
      debugPrint('Here->fetchEntityState'); //
      throw Exception(e);
    }
  }

  Future<List<HAScene>> fetchScenes() async {
    final url = Uri.parse('$_baseUrl/api/states');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        // scenes are enitites with id like scene.somehting_somehthing
        final filterSceneData = data.where((entity) {
          return entity['entity_id'].split('.').first == 'scene';
        });
        return filterSceneData.map((sceneJson) => HAScene.fromJson(sceneJson)).toList();
      } else {
        throw Exception('Failed to fetch scenes: GET /api/states');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> fetchApiServices() async {
    final url = Uri.parse('$_baseUrl/api/services');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to fetch services: GET /api/services');
      }
    } catch (e) {
      debugPrint('Here->fetchApiServides'); //
      throw Exception(e);
    }
  }

  /// The [action] and [additionalActions] parameter is the [Entity.attributes] value for the service
  Future<bool> executeService(String entityId, String action,
      {Map<String, dynamic> additionalActions = const {}}) async {
    final url = Uri.parse('$_baseUrl/api/services/${entityId.split('.').first}/$action');
    // for additiotional actions
    Map<String, dynamic> data = Map.from(additionalActions);
    data["entity_id"] = entityId;

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'entity_id': entityId}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
