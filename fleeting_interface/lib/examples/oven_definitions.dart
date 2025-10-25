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
          toppings: PizzaToppings.values.firstWhere(
            (e) => e.name == pizza?['toppings'],
            orElse: () => PizzaToppings.regular,
          ),
        );
        break;
      case FoodPreset.cookies:
        final cookie = json['cookieOptions'] as Map<String, dynamic>?;
        options = CookieOptions(
          type: CookieType.values.firstWhere(
            (e) => e.name == cookie?['type'],
            orElse: () => CookieType.chocolateChip,
          ),
          texture: CookieTexture.values.firstWhere(
            (e) => e.name == cookie?['texture'],
            orElse: () => CookieTexture.soft,
          ),
          batch: CookieBatch.values.firstWhere(
            (e) => e.name == cookie?['batch'],
            orElse: () => CookieBatch.b24,
          ),
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
          style: ChickenStyle.values.firstWhere(
            (e) => e.name == chicken?['style'],
            orElse: () => ChickenStyle.roasted,
          ),
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
You are a smart oven assistant. Based on the user's cooking intent, select the appropriate food type and cooking options.

Available Food Types:
1. Pizza (foodType: "pizza")
   - crust: "thin", "regular", "thick"
   - size: "personal", "medium", "large"
   - toppings: "light", "regular", "extra"

2. Cookies (foodType: "cookies")
   - type: "chocolateChip", "sugar", "oatmeal"
   - texture: "soft", "crispy"
   - batch: "b12", "b24", "b36"

3. Chicken (foodType: "chicken")
   - cut: "whole", "pieces", "wings"
   - weight: "w4to5", "w6to7", "w8plus"
   - style: "roasted", "crispy", "bbq"

Instructions:
- Determine which food the user wants to cook based on their description
- Select appropriate options for that food type
- Provide a brief explanation of your choices
- Only return ONE food type with its specific options
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
          'description': 'Brief explanation of the cooking choices',
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
