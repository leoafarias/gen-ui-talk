import '../../ai/helpers.dart';

int _brightness = 0;

class LightControlMockApi {
  const LightControlMockApi();

  Future<JSON> post(JSON parameters) {
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
  }

  int getBrightness() => _brightness;
}
