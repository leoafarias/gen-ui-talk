import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../ai/helpers.dart';
import '../../ai/helpers/color_helpers.dart';
import '../color_palette/color_palette_dto.dart';

class TextFieldSchemaDto {
  final String text;
  final String label;
  const TextFieldSchemaDto({
    required this.text,
    required this.label,
  });

  static TextFieldSchemaDto fromMap(Map<String, dynamic> map) {
    return TextFieldSchemaDto(
      text: map['text'] as String,
      label: map['label'] as String,
    );
  }

  JSON toMap() {
    return {
      'text': text,
      'label': label,
    };
  }

  static final schema = Schema.object(
    description: 'A text field schema',
    properties: {
      'text': Schema.string(
        description: 'The text of the text field',
        nullable: false,
      ),
      'label': Schema.string(
        description: 'The label of the text field',
        nullable: false,
      ),
    },
  );

  String toJson() => jsonEncode(toMap());
}

class WidgetSchemaDto {
  final List<TextFieldSchemaDto>? textFields;
  final List<DropdownSchemaDto>? dropdowns;
  final List<ColorPickerDtoSchema>? colorPickers; // Hex color strings

  WidgetSchemaDto({
    this.textFields,
    this.dropdowns,
    this.colorPickers,
  });

  static WidgetSchemaDto fromMap(Map<String, dynamic> map) {
    return WidgetSchemaDto(
      textFields: (map['textFields'] as List<dynamic>?)
          ?.map((e) => TextFieldSchemaDto.fromMap(e as Map<String, dynamic>))
          .toList(),
      dropdowns: (map['dropdowns'] as List<dynamic>?)
          ?.map((e) => DropdownSchemaDto.fromMap(e as Map<String, dynamic>))
          .toList(), // Hex color strings
      colorPickers: (map['colorPickers'] as List<dynamic>?)
          ?.map((e) => ColorPickerDtoSchema.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  JSON toMap() {
    return {
      'textFields': textFields?.map((e) => e.toMap()).toList(),
      'dropdowns': dropdowns?.map((e) => e.toMap()).toList(),
      'colorPickers': colorPickers?.map((e) => e.toMap()).toList(),
    };
  }

  String toJson() => jsonEncode(toMap());

  static final schema = Schema.object(properties: {
    'textFields': Schema.array(
      description: 'A list of text fields',
      items: TextFieldSchemaDto.schema,
      nullable: true,
    ),
    'dropdowns': Schema.array(
      description: 'A list of dropdowns',
      items: DropdownSchemaDto.schema,
      nullable: true,
    ),
    'colorPickers': Schema.array(
      description: 'A list of colors pickers',
      items: ColorPickerDtoSchema.schema,
      nullable: true,
    ),
  });
}

class DropdownSchemaDto {
  final String label;
  final String currentValue;
  final List<String> options;

  DropdownSchemaDto({
    required this.label,
    required this.currentValue,
    required this.options,
  });

  static DropdownSchemaDto fromMap(Map<String, dynamic> map) {
    return DropdownSchemaDto(
      label: map['label'] as String,
      currentValue: map['currentValue'] as String,
      options:
          (map['options'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  String toJson() => jsonEncode(toMap());

  static final schema = Schema.object(properties: {
    'label': Schema.string(
      description: 'The label of the dropdown',
      nullable: false,
    ),
    'currentValue': Schema.string(
      description: 'The currentValue of the dropdown',
      nullable: false,
    ),
    'options': Schema.array(
      description: 'The options of the dropdown',
      items: Schema.string(
        description: 'The options of the dropdown',
        nullable: false,
      ),
      nullable: false,
    )
  });

  JSON toMap() {
    return {
      'label': label,
      'currentValue': currentValue,
      'options': options,
    };
  }
}

class ColorPickerDtoSchema {
  final String label;
  final Color color;

  String toJson() => jsonEncode(toMap());

  const ColorPickerDtoSchema({required this.label, required this.color});

  static ColorPickerDtoSchema fromMap(Map<String, dynamic> map) {
    return ColorPickerDtoSchema(
      label: map['label'] as String,
      color: colorFromHex(map['color'] as String),
    );
  }

  JSON toMap() {
    return {
      'label': label,
      'color': color.toHex(),
    };
  }

  static final schema = Schema.object(properties: {
    'label': Schema.string(
      description: 'The label of the color picker',
      nullable: false,
    ),
    'color': Schema.string(
      description: 'The color of the color picker',
      nullable: false,
    ),
  });
}

class ColorPaletteUpdatableDto extends ColorPaletteDto {
  ColorPaletteUpdatableDto({
    required super.name,
    required super.font,
    required super.fontColor,
    required super.topLeftColor,
    required super.topRightColor,
    required super.bottomLeftColor,
    required super.bottomRightColor,
  });

  static final schema = Schema.object(properties: {
    'name': Schema.string(
      description:
          'The text content to display on color palette. Format: #FF0000',
      nullable: true,
    ),
    'font': Schema.enumString(
      enumValues: ColorPaletteFontFamily.enumString,
      description: 'The font to use for the poster text.',
      nullable: true,
    ),
    'fontColor': Schema.string(
      description: 'The hex color value of the poster text. Format: #FF0000',
      nullable: true,
    ),
    'topLeftColor': Schema.string(
      description:
          'The hex color value top left corner of color palette. Format: #FF0000',
      nullable: true,
    ),
    'topRightColor': Schema.string(
      description:
          'The hex color value top right corner of color palette. Format: #FF0000',
      nullable: true,
    ),
    'bottomLeftColor': Schema.string(
      description:
          'The hex color value bottom left corner of color palette. Format: #FF0000',
      nullable: true,
    ),
    'bottomRightColor': Schema.string(
      description:
          'The hex color value bottom right corner of color palette. Format: #FF0000',
      nullable: true,
    )
  });
}
