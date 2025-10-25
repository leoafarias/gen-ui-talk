import 'smart_oven_widget.dart';

/// Oven configuration result from LLM
class OvenSelection {
  final FoodPreset foodType;
  final FoodOptions options;
  final String explanation;

  OvenSelection({
    required this.foodType,
    required this.options,
    required this.explanation,
  });

  factory OvenSelection.fromJson(Map<String, dynamic> json) {
    final foodType = FoodPreset.values.firstWhere(
      (e) => e.name == json['foodType'],
      orElse: () => FoodPreset.pizza,
    );

    FoodOptions options;
    switch (foodType) {
      case FoodPreset.pizza:
        final pizza = json['pizzaOptions'] as Map<String, dynamic>?;
        options = PizzaOptions(
          crust: PizzaCrust.values.firstWhere(
            (e) => e.name == pizza?['crust'],
            orElse: () => PizzaCrust.regular,
          ),
          size: PizzaSize.values.firstWhere(
            (e) => e.name == pizza?['size'],
            orElse: () => PizzaSize.medium,
          ),
          temperatureC: pizza?['temperatureC'] as int? ?? 245,
          minutes: pizza?['minutes'] as int? ?? 12,
        );
        break;
      case FoodPreset.cookies:
        final cookie = json['cookieOptions'] as Map<String, dynamic>?;
        options = CookieOptions(
          type: CookieType.values.firstWhere(
            (e) => e.name == cookie?['type'],
            orElse: () => CookieType.chocolateChip,
          ),
          batch: CookieBatch.values.firstWhere(
            (e) => e.name == cookie?['batch'],
            orElse: () => CookieBatch.b24,
          ),
          temperatureC: cookie?['temperatureC'] as int? ?? 175,
          minutes: cookie?['minutes'] as int? ?? 10,
        );
        break;
      case FoodPreset.chicken:
        final chicken = json['chickenOptions'] as Map<String, dynamic>?;
        options = ChickenOptions(
          cut: ChickenCut.values.firstWhere(
            (e) => e.name == chicken?['cut'],
            orElse: () => ChickenCut.whole,
          ),
          weight: ChickenWeight.values.firstWhere(
            (e) => e.name == chicken?['weight'],
            orElse: () => ChickenWeight.w4to5,
          ),
          temperatureC: chicken?['temperatureC'] as int? ?? 190,
          minutes: chicken?['minutes'] as int? ?? 60,
        );
        break;
    }

    return OvenSelection(
      foodType: foodType,
      options: options,
      explanation: json['explanation'] as String? ?? '',
    );
  }
}

class OvenDefinitions {
  static String generateSystemPrompt() {
    return '''
You are a smart oven assistant. Based on the user's cooking intent, select the appropriate food type, cooking options, and determine the optimal temperature and time.

Available Food Types:
1. Pizza (foodType: "pizza")
   - crust: "thin", "regular", "thick"
   - size: "personal", "medium", "large"
   - temperatureC: cooking temperature in Celsius (typically 230-260°C)
   - minutes: cooking time in minutes (typically 8-16 min)

2. Cookies (foodType: "cookies")
   - type: "chocolateChip", "sugar", "oatmeal"
   - batch: "b12", "b24", "b36"
   - temperatureC: cooking temperature in Celsius (typically 170-180°C)
   - minutes: cooking time in minutes (typically 10-14 min)

3. Chicken (foodType: "chicken")
   - cut: "whole", "pieces", "wings"
   - weight: "w4to5", "w6to7", "w8plus"
   - temperatureC: cooking temperature in Celsius (typically 180-200°C)
   - minutes: cooking time in minutes (typically 25-90 min depending on size)

Instructions:
- Determine which food the user wants to cook based on their description
- Select appropriate options for that food type
- Determine the optimal cooking temperature and time based on the user's description (e.g., "crispy" = higher temp, "well-done" = longer time)
- Only return ONE food type with its specific options, temperature, and time

IMPORTANT - Explanation Requirements:
- Provide a clear, detailed explanation of WHY you selected these specific settings
- Explain the reasoning behind each choice (food type, options, temperature, time)
- Connect your choices directly to the user's stated cooking intent
- Make your thought process transparent and educational
- Help the user understand how different settings affect the outcome
''';
  }

  static Map<String, dynamic> toJsonSchema() {
    return {
      'type': 'object',
      'properties': {
        'foodType': {
          'type': 'string',
          'enum': ['pizza', 'cookies', 'chicken'],
          'description': 'The type of food to cook',
        },
        'pizzaOptions': {
          'type': 'object',
          'properties': {
            'crust': {
              'type': 'string',
              'enum': ['thin', 'regular', 'thick'],
            },
            'size': {
              'type': 'string',
              'enum': ['personal', 'medium', 'large'],
            },
            'toppings': {
              'type': 'string',
              'enum': ['light', 'regular', 'extra'],
            },
          },
        },
        'cookieOptions': {
          'type': 'object',
          'properties': {
            'type': {
              'type': 'string',
              'enum': ['chocolateChip', 'sugar', 'oatmeal'],
            },
            'texture': {
              'type': 'string',
              'enum': ['soft', 'crispy'],
            },
            'batch': {
              'type': 'string',
              'enum': ['b12', 'b24', 'b36'],
            },
          },
        },
        'chickenOptions': {
          'type': 'object',
          'properties': {
            'cut': {
              'type': 'string',
              'enum': ['whole', 'pieces', 'wings'],
            },
            'weight': {
              'type': 'string',
              'enum': ['w4to5', 'w6to7', 'w8plus'],
            },
            'style': {
              'type': 'string',
              'enum': ['roasted', 'crispy', 'bbq'],
            },
          },
        },
        'explanation': {
          'type': 'string',
          'description': 'Clear, detailed explanation of WHY these specific cooking settings were selected based on the user\'s intent. Explain the reasoning behind each choice (food type, options, temperature, time) and connect choices directly to what the user wants to accomplish.',
        },
      },
      'required': ['foodType', 'explanation'],
      'anyOf': [
        {
          'properties': {
            'foodType': {'const': 'pizza'},
          },
          'required': ['pizzaOptions'],
        },
        {
          'properties': {
            'foodType': {'const': 'cookies'},
          },
          'required': ['cookieOptions'],
        },
        {
          'properties': {
            'foodType': {'const': 'chicken'},
          },
          'required': ['chickenOptions'],
        },
      ],
    };
  }
}
