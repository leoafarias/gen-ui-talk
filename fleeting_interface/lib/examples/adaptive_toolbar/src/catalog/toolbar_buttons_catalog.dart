// Copyright 2025 The Flutter Authors.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_genui/flutter_genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import '../../../tool_bar_example_widget.dart' hide DropdownOption;
import '../widgets/toolbar_components.dart';

/// Atomic toolbar button catalog
/// Each button is a separate widget that can be individually created/deleted
/// This enables true ephemeral composition based on user intent

/// ===== SIMPLE ACTION BUTTONS (29) =====

// FILE OPERATIONS

final btnSearch = CatalogItem(
  name: 'SearchButton',
  dataSchema: S.object(
    description: 'Search button for finding text in document',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarIconButton(
      icon: Icons.search,
      tooltip: 'Search',
      onPressed: () => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {'command': ToolbarCommand.search.toString()},
        ),
      ),
    );
  },
);

final btnPrint = CatalogItem(
  name: 'PrintButton',
  dataSchema: S.object(
    description: 'Print button for printing document',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarIconButton(
      icon: Icons.print,
      tooltip: 'Print',
      onPressed: () => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {'command': ToolbarCommand.print.toString()},
        ),
      ),
    );
  },
);

// HISTORY

final btnUndo = CatalogItem(
  name: 'UndoButton',
  dataSchema: S.object(
    description: 'Undo button for reversing last action',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarIconButton(
      icon: Icons.undo,
      tooltip: 'Undo',
      onPressed: () => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {'command': ToolbarCommand.undo.toString()},
        ),
      ),
    );
  },
);

final btnRedo = CatalogItem(
  name: 'RedoButton',
  dataSchema: S.object(
    description: 'Redo button for reapplying undone action',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarIconButton(
      icon: Icons.redo,
      tooltip: 'Redo',
      onPressed: () => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {'command': ToolbarCommand.redo.toString()},
        ),
      ),
    );
  },
);

// TEXT FORMATTING (MARKS)

final btnBold = CatalogItem(
  name: 'BoldButton',
  dataSchema: S.object(
    description: 'Bold button for making text bold',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarIconButton(
      icon: Icons.format_bold,
      tooltip: 'Bold',
      onPressed: () => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {'command': ToolbarCommand.bold.toString()},
        ),
      ),
    );
  },
);

final btnItalic = CatalogItem(
  name: 'ItalicButton',
  dataSchema: S.object(
    description: 'Italic button for making text italic',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarIconButton(
      icon: Icons.format_italic,
      tooltip: 'Italic',
      onPressed: () => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {'command': ToolbarCommand.italic.toString()},
        ),
      ),
    );
  },
);

final btnUnderline = CatalogItem(
  name: 'UnderlineButton',
  dataSchema: S.object(
    description: 'Underline button for underlining text',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarIconButton(
      icon: Icons.format_underline,
      tooltip: 'Underline',
      onPressed: () => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {'command': ToolbarCommand.underline.toString()},
        ),
      ),
    );
  },
);

final btnTextColor = CatalogItem(
  name: 'TextColorButton',
  dataSchema: S.object(
    description: 'Text color button for changing text color',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarIconButton(
      icon: Icons.format_color_text,
      tooltip: 'Text Color',
      onPressed: () => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {'command': ToolbarCommand.textColor.toString()},
        ),
      ),
    );
  },
);

final btnHighlight = CatalogItem(
  name: 'HighlightButton',
  dataSchema: S.object(
    description: 'Highlight button for highlighting text background',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarIconButton(
      icon: Icons.highlight,
      tooltip: 'Highlight',
      onPressed: () => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {'command': ToolbarCommand.highlight.toString()},
        ),
      ),
    );
  },
);

// INSERT

final btnLink = CatalogItem(
  name: 'LinkButton',
  dataSchema: S.object(
    description: 'Insert link button for adding hyperlinks',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarIconButton(
      icon: Icons.link,
      tooltip: 'Insert Link',
      onPressed: () => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {'command': ToolbarCommand.link.toString()},
        ),
      ),
    );
  },
);

final btnImage = CatalogItem(
  name: 'ImageButton',
  dataSchema: S.object(
    description: 'Insert image button for adding images',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarIconButton(
      icon: Icons.image,
      tooltip: 'Insert Image',
      onPressed: () => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {'command': ToolbarCommand.image.toString()},
        ),
      ),
    );
  },
);

// ALIGNMENT

final btnAlignLeft = CatalogItem(
  name: 'AlignLeftButton',
  dataSchema: S.object(
    description: 'Align left button for left text alignment',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarIconButton(
      icon: Icons.format_align_left,
      tooltip: 'Align Left',
      onPressed: () => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {'command': ToolbarCommand.alignLeft.toString()},
        ),
      ),
    );
  },
);

final btnAlignCenter = CatalogItem(
  name: 'AlignCenterButton',
  dataSchema: S.object(
    description: 'Align center button for centered text alignment',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarIconButton(
      icon: Icons.format_align_center,
      tooltip: 'Align Center',
      onPressed: () => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {'command': ToolbarCommand.alignCenter.toString()},
        ),
      ),
    );
  },
);

final btnAlignRight = CatalogItem(
  name: 'AlignRightButton',
  dataSchema: S.object(
    description: 'Align right button for right text alignment',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarIconButton(
      icon: Icons.format_align_right,
      tooltip: 'Align Right',
      onPressed: () => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {'command': ToolbarCommand.alignRight.toString()},
        ),
      ),
    );
  },
);

// LISTS

final btnBulletList = CatalogItem(
  name: 'BulletListButton',
  dataSchema: S.object(
    description: 'Bullet list button for creating bulleted lists',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarIconButton(
      icon: Icons.format_list_bulleted,
      tooltip: 'Bullet List',
      onPressed: () => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {'command': ToolbarCommand.bulletList.toString()},
        ),
      ),
    );
  },
);

final btnNumberList = CatalogItem(
  name: 'NumberListButton',
  dataSchema: S.object(
    description: 'Numbered list button for creating numbered lists',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarIconButton(
      icon: Icons.format_list_numbered,
      tooltip: 'Numbered List',
      onPressed: () => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {'command': ToolbarCommand.numberList.toString()},
        ),
      ),
    );
  },
);

final btnCheckList = CatalogItem(
  name: 'CheckListButton',
  dataSchema: S.object(
    description: 'Checklist button for creating task lists',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarIconButton(
      icon: Icons.check_box,
      tooltip: 'Checklist',
      onPressed: () => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {'command': ToolbarCommand.checkList.toString()},
        ),
      ),
    );
  },
);

// INDENT

final btnIndentDecrease = CatalogItem(
  name: 'IndentDecreaseButton',
  dataSchema: S.object(
    description: 'Decrease indent button for reducing indentation',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarIconButton(
      icon: Icons.format_indent_decrease,
      tooltip: 'Decrease Indent',
      onPressed: () => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {'command': ToolbarCommand.decreaseIndent.toString()},
        ),
      ),
    );
  },
);

final btnIndentIncrease = CatalogItem(
  name: 'IndentIncreaseButton',
  dataSchema: S.object(
    description: 'Increase indent button for adding indentation',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarIconButton(
      icon: Icons.format_indent_increase,
      tooltip: 'Increase Indent',
      onPressed: () => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {'command': ToolbarCommand.increaseIndent.toString()},
        ),
      ),
    );
  },
);

// MISC

final btnClearFormatting = CatalogItem(
  name: 'ClearFormattingButton',
  dataSchema: S.object(
    description: 'Clear formatting button for removing all text formatting',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarIconButton(
      icon: Icons.format_clear,
      tooltip: 'Clear Formatting',
      onPressed: () => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {'command': ToolbarCommand.clearFormatting.toString()},
        ),
      ),
    );
  },
);

final btnHistory = CatalogItem(
  name: 'HistoryButton',
  dataSchema: S.object(
    description: 'Version history button for viewing document history',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarIconButton(
      icon: Icons.history,
      tooltip: 'Version History',
      onPressed: () => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {'command': ToolbarCommand.history.toString()},
        ),
      ),
    );
  },
);

final btnEdit = CatalogItem(
  name: 'EditButton',
  dataSchema: S.object(
    description: 'Edit button for entering edit mode',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarIconButton(
      icon: Icons.edit,
      tooltip: 'Edit',
      onPressed: () => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {'command': ToolbarCommand.edit.toString()},
        ),
      ),
    );
  },
);

/// ===== COMPLEX CONTROLS (5 DROPDOWNS) =====

final controlZoom = CatalogItem(
  name: 'ZoomControl',
  dataSchema: S.object(
    description: 'Zoom level dropdown for adjusting document zoom',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarDropdown<int>(
      tooltip: 'Zoom',
      hint: '100%',
      options: const [
        DropdownOption(50, label: '50%'),
        DropdownOption(75, label: '75%'),
        DropdownOption(100, label: '100%'),
        DropdownOption(125, label: '125%'),
        DropdownOption(150, label: '150%'),
        DropdownOption(200, label: '200%'),
      ],
      onChanged: (value) => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {
            'command': ToolbarCommand.zoom.toString(),
            'value': value,
          },
        ),
      ),
    );
  },
);

final controlStyle = CatalogItem(
  name: 'StyleControl',
  dataSchema: S.object(
    description: 'Text style dropdown for selecting paragraph styles',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarDropdown<String>(
      tooltip: 'Text Style',
      hint: 'Normal text',
      options: const [
        DropdownOption('Normal text'),
        DropdownOption('Title'),
        DropdownOption('Subtitle'),
        DropdownOption('Heading 1'),
        DropdownOption('Heading 2'),
        DropdownOption('Heading 3'),
      ],
      onChanged: (value) => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {
            'command': ToolbarCommand.style.toString(),
            'value': value,
          },
        ),
      ),
    );
  },
);

final controlFontFamily = CatalogItem(
  name: 'FontFamilyControl',
  dataSchema: S.object(
    description: 'Font family dropdown for selecting typeface',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarDropdown<String>(
      tooltip: 'Font Family',
      hint: 'Arial',
      options: const [
        DropdownOption('Arial'),
        DropdownOption('Roboto'),
        DropdownOption('Georgia'),
        DropdownOption('Times New Roman'),
        DropdownOption('Courier New'),
      ],
      onChanged: (value) => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {
            'command': ToolbarCommand.fontFamily.toString(),
            'value': value,
          },
        ),
      ),
    );
  },
);

final controlFontSize = CatalogItem(
  name: 'FontSizeControl',
  dataSchema: S.object(
    description: 'Font size dropdown for selecting text size',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarDropdown<int>(
      tooltip: 'Font Size',
      hint: '11',
      options: const [
        DropdownOption(9),
        DropdownOption(10),
        DropdownOption(11),
        DropdownOption(12),
        DropdownOption(14),
        DropdownOption(18),
        DropdownOption(24),
      ],
      onChanged: (value) => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {
            'command': ToolbarCommand.fontSize.toString(),
            'value': value,
          },
        ),
      ),
    );
  },
);

final controlLineSpacing = CatalogItem(
  name: 'LineSpacingControl',
  dataSchema: S.object(
    description: 'Line spacing dropdown for adjusting line height',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return ToolbarDropdown<double>(
      tooltip: 'Line Spacing',
      hint: '1.15',
      options: const [
        DropdownOption(1.0, label: '1.0'),
        DropdownOption(1.15, label: '1.15'),
        DropdownOption(1.5, label: '1.5'),
        DropdownOption(2.0, label: '2.0'),
      ],
      onChanged: (value) => dispatchEvent(
        UserActionEvent(
          name: 'toolbarCommand',
          sourceComponentId: id,
          context: {
            'command': ToolbarCommand.lineSpacing.toString(),
            'value': value,
          },
        ),
      ),
    );
  },
);

/// ===== LAYOUT (1 DIVIDER) =====

final dividerVertical = CatalogItem(
  name: 'VerticalDivider',
  dataSchema: S.object(
    description: 'Vertical divider for visual grouping of buttons',
  ),
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    return const ToolbarDivider();
  },
);
