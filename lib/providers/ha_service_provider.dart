import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luminar_control_app/services/home_assistant_service.dart';
import '../env/secret.dart';

class HaServiceProvider extends StateNotifier<HomeAssistantService> {
  HaServiceProvider() : super(HomeAssistantService(Secrets.haBaseUrl, Secrets.haLongLiveAccessToken));
}

final haServiceProvider = StateNotifierProvider<HaServiceProvider, HomeAssistantService>(
  (ref) => HaServiceProvider(),
);
