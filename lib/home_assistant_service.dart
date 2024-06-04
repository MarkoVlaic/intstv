import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeAssistantService {
  final String _baseUrl;
  final String _token;

  HomeAssistantService(this._baseUrl, this._token);

  Future<List<dynamic>> fetchScenes() async {
    final url = Uri.parse('$_baseUrl/api/states');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      // Filter the scenes from the response
      final scenes = data.where((element) => element['entity_id'].startsWith('scene.')).toList();
      return scenes;
    } else {
      throw Exception('Failed to load scenes');
    }
  }

  Future<List<dynamic>> fetchSceneDevices(String sceneId) async {
    final url = Uri.parse('$_baseUrl/api/states/$sceneId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Data from Home Assistant: $data'); // Debug ispis
      if (data != null && data['attributes'] != null && data['attributes']['entity_id'] != null) {
        final devices = data['attributes']['entity_id'] as List<dynamic>;
        return devices;
      } else {
        throw Exception('No devices found for scene $sceneId');
      }
    } else {
      throw Exception('Failed to load devices for scene $sceneId');
    }
  }

  Future<void> turnOnOrOffDevice(String entityId, String state) async {
    final url = Uri.parse('$_baseUrl/api/services/light/turn_'+state);
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'entity_id': entityId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to turn on device $entityId');
    }
  }
}