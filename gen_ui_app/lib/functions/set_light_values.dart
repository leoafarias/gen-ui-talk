import 'package:google_generative_ai/google_generative_ai.dart';

import '../ai/models/llm_function.dart';

enum _ColorTemperature {
  daylight,
  cool,
  warm;

  static List<String> get enumString => values.map((e) => e.name).toList();

  static _ColorTemperature fromString(String value) {
    return values.firstWhere((e) => e.name == value);
  }
}

class SetLightValuesResponse {
  final int brightness;
  final _ColorTemperature colorTemperature;

  SetLightValuesResponse({
    required this.brightness,
    required this.colorTemperature,
  });

  factory SetLightValuesResponse.fromJson(Map<String, Object?> json) {
    return SetLightValuesResponse(
      brightness: json['brightness'] as int,
      colorTemperature: _ColorTemperature.fromString(
        json['colorTemperature'] as String,
      ),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'brightness': brightness,
      'colorTemperature': colorTemperature,
    };
  }

  static final schema = Schema.object(
    properties: {
      'brightness': Schema.number(
          description:
              'Light level from 0 to 100. Zero is off and 100 is full brightness.',
          nullable: false),
      'colorTemperature': Schema.enumString(
        enumValues: _ColorTemperature.enumString,
        description:
            'Color temperature of the light fixture which can be `daylight`, `cool`, or `warm`',
        nullable: false,
      ),
    },
  );
}

final setLightValuesFunction = LlmFunction(
  name: 'controlLight',
  description: 'Set the brightness and color temperature of a room light. ',
  parameters: SetLightValuesResponse.schema,
  handler: (Map<String, Object?> args) => args,
);
