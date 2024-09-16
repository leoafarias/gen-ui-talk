import 'package:google_generative_ai/google_generative_ai.dart';

class LightControlDto {
  final int brightness;

  LightControlDto({
    required this.brightness,
  });

  static LightControlDto fromMap(Map<String, dynamic> map) {
    return LightControlDto(
      brightness: map['brightness'] as int,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'brightness': brightness,
    };
  }

  static final schema = Schema.object(properties: {
    'brightness': Schema.integer(
      description:
          'Light level from 0 to 100. Zero is off and 100 is full brightness.',
      nullable: false,
    ),
  }, requiredProperties: [
    'brightness'
  ]);
}
