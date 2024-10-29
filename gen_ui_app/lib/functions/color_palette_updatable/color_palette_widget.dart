import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'color_palette_updatable_dto.dart';

class ColorPaletteUpdatableResponseView extends HookWidget {
  final WidgetSchemaDto data;

  const ColorPaletteUpdatableResponseView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Helper functions

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

    // Render dropdowns with labels
    if (data.dropdowns != null) {
      for (int i = 0; i < data.dropdowns!.length; i++) {
        final dropdownData = data.dropdowns![i];
        widgets.add(
          ListTile(
            title: Text(dropdownData.label,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            trailing: DropdownButton<String>(
              style: const TextStyle(
                fontSize: 24,
              ),
              value: dropdownData.currentValue,
              items: dropdownData.options.map((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (newValue) {},
            ),
          ),
        );
      }
    }

    // Render color pickers using flutter_colorpicker with labels
    for (int i = 0; i < selectedColors.value.length; i++) {
      widgets.add(
        ListTile(
          title: Text(
            colorPickerLabels[i],
            style: const TextStyle(fontSize: 24),
          ),
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

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // children: widgets,
        // add a horizontal diider to all the widgets
        children:
            widgets.expand((element) => [element, const Divider()]).toList()
              ..removeLast(),
      ),
    );
  }
}
