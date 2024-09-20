import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'color_palette_updatable_dto.dart';

class ColorPaletteUpdatableResponseView extends HookWidget {
  final WidgetSchemaDto data;

  const ColorPaletteUpdatableResponseView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Initialize text controllers and labels using hooks
    final textControllers = <TextEditingController>[];
    final textLabels = <String>[];
    if (data.textFields != null) {
      for (var textField in data.textFields!) {
        final controller = useTextEditingController(text: textField.text);
        textControllers.add(controller);
        textLabels.add(textField.label);
      }
    }

    // Initialize selected dropdown values and labels using hooks
    final selectedDropdownValues = useState<List<String>>(
      List.from(
          data.dropdowns?.map((dropdown) => dropdown.value).toList() ?? []),
    );
    final dropdownLabels =
        data.dropdowns?.map((dropdown) => dropdown.label).toList() ?? [];

    // Initialize selected colors and labels using hooks
    final selectedColors = useState<List<Color>>(
      List.from(
          data.colorPickers?.map((colorPicker) => colorPicker.color).toList() ??
              []),
    );
    final colorPickerLabels =
        data.colorPickers?.map((colorPicker) => colorPicker.label).toList() ??
            [];

    // Build the widgets list
    List<Widget> widgets = [];

    // Render text fields with labels
    for (int i = 0; i < textControllers.length; i++) {
      widgets.add(
        TextField(
          controller: textControllers[i],
          decoration: InputDecoration(labelText: textLabels[i]),
        ),
      );
    }

    // Render dropdowns with labels
    if (data.dropdowns != null) {
      for (int i = 0; i < data.dropdowns!.length; i++) {
        final dropdownData = data.dropdowns![i];
        widgets.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(dropdownData.label),
              DropdownButton<String>(
                value: selectedDropdownValues.value[i],
                items: [
                  DropdownMenuItem(
                    value: dropdownData.value,
                    child: Text(dropdownData.value),
                  ),
                  // Add more DropdownMenuItems here if needed
                ],
                onChanged: (newValue) {
                  selectedDropdownValues.value =
                      List.from(selectedDropdownValues.value)..[i] = newValue!;
                },
              ),
            ],
          ),
        );
      }
    }

    // Render color pickers using flutter_colorpicker with labels
    for (int i = 0; i < selectedColors.value.length; i++) {
      widgets.add(
        ListTile(
          title: Text(colorPickerLabels[i]),
          trailing: GestureDetector(
            onTap: () async {
              Color pickedColor = selectedColors.value[i];
              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Pick a color for ${colorPickerLabels[i]}'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: pickedColor,
                        onColorChanged: (color) {
                          pickedColor = color;
                        },
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Done'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
              selectedColors.value = List.from(selectedColors.value)
                ..[i] = pickedColor;
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: selectedColors.value[i],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black),
              ),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: widgets,
      ),
    );
  }
}
