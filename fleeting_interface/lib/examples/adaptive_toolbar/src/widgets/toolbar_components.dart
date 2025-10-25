// Copyright 2025 The Flutter Authors.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// Reusable toolbar button components
/// These ensure visual consistency across all atomic toolbar widgets

/// Standard icon button for toolbar
/// Used by all simple action buttons (bold, italic, undo, etc.)
class ToolbarIconButton extends StatelessWidget {
  const ToolbarIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        visualDensity: VisualDensity.compact,
        icon: Icon(icon),
        onPressed: onPressed,
      ),
    );
  }
}

/// Dropdown selector for toolbar
/// Used for zoom level, text style, font family, font size, line spacing
class ToolbarDropdown<T> extends StatelessWidget {
  const ToolbarDropdown({
    super.key,
    required this.tooltip,
    required this.hint,
    required this.options,
    required this.onChanged,
    this.currentValue,
  });

  final String tooltip;
  final String hint;
  final List<DropdownOption<T>> options;
  final ValueChanged<T?> onChanged;
  final T? currentValue;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: DropdownButtonHideUnderline(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<T>(
            isDense: true,
            value: currentValue,
            hint: Text(hint),
            items: [
              for (final opt in options)
                DropdownMenuItem<T>(
                  value: opt.value,
                  child: opt.child ?? Text(opt.label ?? opt.value.toString()),
                ),
            ],
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}

/// Simple value wrapper for dropdown menus
class DropdownOption<T> {
  const DropdownOption(this.value, {this.label, this.child});
  final T value;
  final String? label;
  final Widget? child;
}

/// Vertical divider for visual grouping in toolbar
class ToolbarDivider extends StatelessWidget {
  const ToolbarDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 28,
      child: VerticalDivider(
        width: 10,
        thickness: 1,
        indent: 2,
        endIndent: 2,
      ),
    );
  }
}
