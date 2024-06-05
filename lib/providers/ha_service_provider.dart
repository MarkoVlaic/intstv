import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luminar_control_app/services/home_assistant_service.dart';

class HaServiceProvider extends StateNotifier<HomeAssistantService> {
  static const _haBaseUrl = "http://10.0.2.2:8123";
  static const _haLongLiveAccessToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI0NmQzYjAwNjQ4N2U0NGMxOWU1MWFlMjZhOTEzNTc3MiIsImlhdCI6MTcxNzUxNjY2NCwiZXhwIjoyMDMyODc2NjY0fQ.ABcquNcjAf_uKH8rTNRk5bu99TSxTQEXiM3ip9EX4LA";

  HaServiceProvider() : super(HomeAssistantService(_haBaseUrl, _haLongLiveAccessToken));
}

final haServiceProvider = StateNotifierProvider<HaServiceProvider, HomeAssistantService>(
  (ref) => HaServiceProvider(),
);
