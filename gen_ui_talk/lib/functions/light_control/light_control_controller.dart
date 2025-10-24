import 'package:flutter/widgets.dart';

import '../../ai/helpers.dart';

final lightControlController = _LightControlMockController();

class _LightControlMockController extends ChangeNotifier {
  int _brightness = 90;
  _LightControlMockController();

  Future<JSON> post(JSON parameters) async {
    await Future.delayed(const Duration(seconds: 1));
    setBrightness(parameters['brightness'] as int);
    return Future.value(get());
  }

  Future<JSON> get() {
    final result = {
      'brightness': _brightness,
    };
    return Future.value(result);
  }

  void setBrightness(int brightness) {
    if (brightness > 100) {
      brightness = 100;
    } else if (brightness < 0) {
      brightness = 0;
    }
    _brightness = brightness;
    notifyListeners();
  }

  int get brightness => _brightness;
}
