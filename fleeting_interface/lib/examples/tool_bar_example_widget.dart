import 'package:flutter/material.dart';

// DartPad entry point
void main() => runApp(const ToolBarExampleWidget());

/// Demo app: toggles groups to prove the toolbar is purely config-driven.
class ToolBarExampleWidget extends StatefulWidget {
  const ToolBarExampleWidget({super.key});

  @override
  State<ToolBarExampleWidget> createState() => _ToolBarExampleWidgetState();
}

class _ToolBarExampleWidgetState extends State<ToolBarExampleWidget> {
  // Start with everything visible.
  final Set<ToolbarGroup> shown = {
    ToolbarGroup.file,
    ToolbarGroup.history,
    ToolbarGroup.zoom,
    ToolbarGroup.style,
    ToolbarGroup.font,
    ToolbarGroup.marks,
    ToolbarGroup.insert,
    ToolbarGroup.alignment,
    ToolbarGroup.lists,
    ToolbarGroup.indent,
    ToolbarGroup.misc,
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(title: const Text('ToolBarExample')),
        body: Column(
          children: [
            // Simple control panel to add/remove groups at runtime.
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ToolbarGroup.values.map((g) {
                  final enabled = shown.contains(g);
                  return _TogglePill(
                    label: g.label,
                    enabled: enabled,
                    onTap: () => setState(() {
                      if (enabled) {
                        shown.remove(g);
                      } else {
                        shown.add(g);
                      }
                    }),
                  );
                }).toList(),
              ),
            ),
            const Divider(height: 1),

            // The actual toolbar (stateless; purely driven by [shown]).
            ExampleToolbar(
              groups: shown,
              onCommand: (cmd, payload) {
                // In a real app, route this to your editor; for demo, print it.
                debugPrint('Toolbar -> $cmd payload=$payload');
              },
            ),

            const Divider(height: 1),
            const Expanded(
              child: Center(
                child: Text(
                  'This area stands in for your editor.\n\n'
                  'The toolbar has no selection/format state—\n'
                  'just dynamic group show/hide.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TogglePill extends StatelessWidget {
  const _TogglePill({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Color background = enabled
        ? scheme.primaryContainer
        : scheme.surfaceContainerHighest;
    final Color foreground = enabled
        ? scheme.onPrimaryContainer
        : scheme.onSurfaceVariant;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: enabled ? scheme.primary : scheme.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: foreground),
        ),
      ),
    );
  }
}

/// Example toolbar demonstrating config-driven toolbar composition.
/// - No editor state, no selection tracking.
/// - You pass a set of [ToolbarGroup]s to show.
/// - Buttons call [onCommand] with a command (+ optional payload).
/// - Wrap layout naturally forms ~two rows; if it ever needs more, it
///   becomes vertically scrollable to avoid overflow in DartPad.
class ExampleToolbar extends StatelessWidget {
  const ExampleToolbar({
    super.key,
    required this.groups,
    required this.onCommand,
    this.spacing = 6,
    this.runSpacing = 8,
    this.height = 96, // ~two compact rows
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    this.backgroundColor,
  });

  /// Which button groups to display.
  final Set<ToolbarGroup> groups;

  /// Command sink for demo purposes.
  final void Function(ToolbarCommand command, dynamic payload) onCommand;

  // Visuals
  final double spacing;
  final double runSpacing;
  final double height;
  final EdgeInsets padding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding,
      child: Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.spaceBetween, // helps balance row widths
        crossAxisAlignment: WrapCrossAlignment.center,
        children: _buildChildren(context),
      ),
    );

    return Material(
      color: backgroundColor ?? Theme.of(context).colorScheme.surface,
      child: SizedBox(
        height: height,
        // If you ever have more than two rows, this avoids overflow in DartPad.
        child: SingleChildScrollView(child: content),
      ),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    final List<Widget> out = [];

    void add(ToolbarGroup group, List<Widget> children) {
      if (!groups.contains(group)) return;
      if (out.isNotEmpty) out.add(_divider(context));
      out.addAll(children);
    }

    add(ToolbarGroup.file, [
      _btn(context, Icons.search, ToolbarCommand.search),
      _btn(context, Icons.print, ToolbarCommand.print),
    ]);

    add(ToolbarGroup.history, [
      _btn(context, Icons.undo, ToolbarCommand.undo),
      _btn(context, Icons.redo, ToolbarCommand.redo),
    ]);

    add(ToolbarGroup.zoom, [
      _dropdown<int>(
        context,
        tip: 'Zoom',
        cmd: ToolbarCommand.zoom,
        hint: '100%',
        options: const [
          DropdownOption(50, label: '50%'),
          DropdownOption(75, label: '75%'),
          DropdownOption(100, label: '100%'),
          DropdownOption(125, label: '125%'),
          DropdownOption(150, label: '150%'),
          DropdownOption(200, label: '200%'),
        ],
      ),
    ]);

    add(ToolbarGroup.style, [
      _dropdown<String>(
        context,
        tip: 'Text style',
        cmd: ToolbarCommand.style,
        hint: 'Normal text',
        options: const [
          DropdownOption('Normal text'),
          DropdownOption('Title'),
          DropdownOption('Subtitle'),
          DropdownOption('Heading 1'),
          DropdownOption('Heading 2'),
          DropdownOption('Heading 3'),
        ],
      ),
    ]);

    add(ToolbarGroup.font, [
      _dropdown<String>(
        context,
        tip: 'Font',
        cmd: ToolbarCommand.fontFamily,
        hint: 'Arial',
        options: const [
          DropdownOption('Arial'),
          DropdownOption('Roboto'),
          DropdownOption('Georgia'),
          DropdownOption('Times New Roman'),
          DropdownOption('Courier New'),
        ],
      ),
      _dropdown<int>(
        context,
        tip: 'Size',
        cmd: ToolbarCommand.fontSize,
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
      ),
    ]);

    add(ToolbarGroup.marks, [
      _btn(context, Icons.format_bold, ToolbarCommand.bold),
      _btn(context, Icons.format_italic, ToolbarCommand.italic),
      _btn(context, Icons.format_underline, ToolbarCommand.underline),
      _btn(context, Icons.format_color_text, ToolbarCommand.textColor),
      _btn(context, Icons.highlight, ToolbarCommand.highlight),
    ]);

    add(ToolbarGroup.insert, [
      _btn(context, Icons.link, ToolbarCommand.link),
      _btn(context, Icons.image, ToolbarCommand.image), // safe icon for DartPad
    ]);

    add(ToolbarGroup.alignment, [
      _btn(context, Icons.format_align_left, ToolbarCommand.alignLeft),
      _btn(context, Icons.format_align_center, ToolbarCommand.alignCenter),
      _btn(context, Icons.format_align_right, ToolbarCommand.alignRight),
    ]);

    add(ToolbarGroup.lists, [
      _btn(context, Icons.format_list_bulleted, ToolbarCommand.bulletList),
      _btn(context, Icons.format_list_numbered, ToolbarCommand.numberList),
      _btn(
        context,
        Icons.check_box,
        ToolbarCommand.checkList,
      ), // safe, ubiquitous
    ]);

    add(ToolbarGroup.indent, [
      _btn(
        context,
        Icons.format_indent_decrease,
        ToolbarCommand.decreaseIndent,
      ),
      _btn(
        context,
        Icons.format_indent_increase,
        ToolbarCommand.increaseIndent,
      ),
      _dropdown<double>(
        context,
        tip: 'Line spacing',
        cmd: ToolbarCommand.lineSpacing,
        hint: '1.15',
        options: const [
          DropdownOption(1.0, label: '1.0'),
          DropdownOption(1.15, label: '1.15'),
          DropdownOption(1.5, label: '1.5'),
          DropdownOption(2.0, label: '2.0'),
        ],
      ),
    ]);

    add(ToolbarGroup.misc, [
      _btn(context, Icons.format_clear, ToolbarCommand.clearFormatting),
      _btn(context, Icons.history, ToolbarCommand.history),
      _btn(context, Icons.edit, ToolbarCommand.edit),
    ]);

    return out;
  }

  // --- tiny builders ---
  Widget _btn(
    BuildContext context,
    IconData icon,
    ToolbarCommand cmd, {
    String? tip,
  }) => Tooltip(
    message: tip ?? cmd.label,
    child: IconButton(
      visualDensity: VisualDensity.compact,
      icon: Icon(icon),
      onPressed: () => onCommand(cmd, null),
    ),
  );

  Widget _dropdown<T>(
    BuildContext context, {
    required ToolbarCommand cmd,
    required List<DropdownOption<T>> options,
    required String hint,
    String? tip,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: tip ?? cmd.label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: scheme.surface,
          border: Border.all(color: scheme.outlineVariant),
          borderRadius: BorderRadius.circular(4),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            isDense: true,
            value: null, // stateless demo: always show hint
            hint: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  hint,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.arrow_drop_down,
                  size: 18,
                  color: scheme.onSurfaceVariant,
                ),
              ],
            ),
            icon: const SizedBox.shrink(), // Hide default icon since we show it in hint
            items: [
              for (final opt in options)
                DropdownMenuItem<T>(
                  value: opt.value,
                  child: opt.child ?? Text(opt.label ?? opt.value.toString()),
                ),
            ],
            onChanged: (v) => onCommand(cmd, v),
          ),
        ),
      ),
    );
  }

  Widget _divider(BuildContext context) => SizedBox(
    height: 28,
    child: VerticalDivider(width: 10, thickness: 1, indent: 2, endIndent: 2),
  );
}

// ===== Groups & Commands =====

enum ToolbarGroup {
  file, // search/print
  history, // undo/redo
  zoom,
  style,
  font, // family + size
  marks, // bold/italic/underline/color/highlight
  insert, // link/image
  alignment, // left/center/right
  lists, // bullets/numbers/checklist
  indent, // indent +/- , line spacing
  misc, // clear/history/edit
}

extension ToolbarGroupLabel on ToolbarGroup {
  String get label => switch (this) {
    ToolbarGroup.file => 'File',
    ToolbarGroup.history => 'History',
    ToolbarGroup.zoom => 'Zoom',
    ToolbarGroup.style => 'Style',
    ToolbarGroup.font => 'Font',
    ToolbarGroup.marks => 'Marks',
    ToolbarGroup.insert => 'Insert',
    ToolbarGroup.alignment => 'Alignment',
    ToolbarGroup.lists => 'Lists',
    ToolbarGroup.indent => 'Indent',
    ToolbarGroup.misc => 'Misc',
  };
}

enum ToolbarCommand {
  search,
  print,
  undo,
  redo,
  zoom,
  style,
  fontFamily,
  fontSize,
  bold,
  italic,
  underline,
  strikethrough,
  subscript,
  superscript,
  textColor,
  highlight,
  link,
  image,
  table,
  emoji,
  alignLeft,
  alignCenter,
  alignRight,
  alignJustify,
  bulletList,
  numberList,
  checkList,
  decreaseIndent,
  increaseIndent,
  lineSpacing,
  clearFormatting,
  history,
  edit,
}

extension on ToolbarCommand {
  String get label => switch (this) {
    ToolbarCommand.search => 'Search',
    ToolbarCommand.print => 'Print',
    ToolbarCommand.undo => 'Undo',
    ToolbarCommand.redo => 'Redo',
    ToolbarCommand.zoom => 'Zoom',
    ToolbarCommand.style => 'Text style',
    ToolbarCommand.fontFamily => 'Font family',
    ToolbarCommand.fontSize => 'Font size',
    ToolbarCommand.bold => 'Bold',
    ToolbarCommand.italic => 'Italic',
    ToolbarCommand.underline => 'Underline',
    ToolbarCommand.strikethrough => 'Strikethrough',
    ToolbarCommand.subscript => 'Subscript',
    ToolbarCommand.superscript => 'Superscript',
    ToolbarCommand.textColor => 'Text color',
    ToolbarCommand.highlight => 'Highlight',
    ToolbarCommand.link => 'Insert link',
    ToolbarCommand.image => 'Insert image',
    ToolbarCommand.table => 'Insert table',
    ToolbarCommand.emoji => 'Insert emoji',
    ToolbarCommand.alignLeft => 'Align left',
    ToolbarCommand.alignCenter => 'Align center',
    ToolbarCommand.alignRight => 'Align right',
    ToolbarCommand.alignJustify => 'Justify',
    ToolbarCommand.bulletList => 'Bulleted list',
    ToolbarCommand.numberList => 'Numbered list',
    ToolbarCommand.checkList => 'Checklist',
    ToolbarCommand.decreaseIndent => 'Decrease indent',
    ToolbarCommand.increaseIndent => 'Increase indent',
    ToolbarCommand.lineSpacing => 'Line spacing',
    ToolbarCommand.clearFormatting => 'Clear formatting',
    ToolbarCommand.history => 'Version history',
    ToolbarCommand.edit => 'Edit',
  };
}

// Simple value wrapper for dropdown menus.
class DropdownOption<T> {
  const DropdownOption(this.value, {this.label, this.child});
  final T value;
  final String? label;
  final Widget? child;
}
