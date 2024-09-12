// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// A circular button widget with an icon.
///
/// This widget creates a circular button with a customizable icon and size.
/// It can be enabled or disabled based on the presence of an [onPressed]
/// callback.
class CircleButton extends StatelessWidget {
  /// Creates a [CircleButton].
  ///
  /// The [icon] parameter is required and specifies the icon to be displayed.
  /// The [onPressed] callback is optional and determines if the button is
  /// enabled. The [size] parameter determines the diameter of the circular
  /// button.
  const CircleButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 40,
  });

  /// The icon to display in the button.
  final IconData icon;

  /// The callback that is called when the button is tapped.
  /// If null, the button will be disabled.
  final VoidCallback? onPressed;

  /// The diameter of the circular button.
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _enabled ? theme.colorScheme.primary : theme.disabledColor,
        ),
        child: Icon(
          icon,
          color: _enabled
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface,
          size: size * 0.6,
        ),
      ),
    );
  }

  /// Whether the button is enabled.
  bool get _enabled => onPressed != null;
}

/// A widget that displays a horizontal bar of [CircleButton]s.
///
/// This widget creates a container with rounded corners that houses a series of
/// [CircleButton]s. The buttons are laid out horizontally and can overflow if
/// there's not enough space.
class CircleButtonBar extends StatelessWidget {
  /// Creates a [CircleButtonBar].
  ///
  /// The [buttons] parameter is required and specifies the list of
  /// [CircleButton]s to be displayed in the bar.
  const CircleButtonBar(this.buttons, {super.key});

  /// The list of [CircleButton]s to be displayed in the bar.
  final List<CircleButton> buttons;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: OverflowBar(
        children: buttons,
      ),
    );
  }
}
