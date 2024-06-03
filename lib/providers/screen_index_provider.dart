import 'package:flutter_riverpod/flutter_riverpod.dart';

// is light theme active
class ScreenIndexProvider extends StateNotifier<int> {
  ScreenIndexProvider() : super(0);

  void changeScreenIindex(int screenIndex) {
    state = screenIndex;
  }
}

final screenIndexProvider = StateNotifierProvider<ScreenIndexProvider, int>(
  (ref) => ScreenIndexProvider(),
);
