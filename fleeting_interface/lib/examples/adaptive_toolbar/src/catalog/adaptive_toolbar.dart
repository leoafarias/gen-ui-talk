// Copyright 2025 The Flutter Authors.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_genui/flutter_genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import '../../../tool_bar_example_widget.dart';

/// Schema defines which toolbar groups are visible
final _schema = S.object(
  description: 'Adaptive toolbar that shows only relevant groups based on context',
  properties: {
    'context': S.string(
      description: 'The editing context (e.g., "writing", "copy editing", "prompt", "minimal", "advanced")',
    ),
    'groups': S.object(
      description: 'Boolean flags for each toolbar group',
      properties: {
        'file': S.boolean(description: 'Show file group (search, print)'),
        'history': S.boolean(description: 'Show history group (undo, redo)'),
        'zoom': S.boolean(description: 'Show zoom group'),
        'style': S.boolean(description: 'Show style group (headings, paragraphs)'),
        'font': S.boolean(description: 'Show font group (family, size)'),
        'marks': S.boolean(description: 'Show marks group (bold, italic, underline, color)'),
        'insert': S.boolean(description: 'Show insert group (link, image)'),
        'alignment': S.boolean(description: 'Show alignment group (left, center, right)'),
        'lists': S.boolean(description: 'Show lists group (bullets, numbers, checklist)'),
        'indent': S.boolean(description: 'Show indent group (indent, line spacing)'),
        'misc': S.boolean(description: 'Show misc group (clear formatting, history, edit)'),
      },
    ),
  },
  required: ['groups'],
);

extension type _AdaptiveToolbarData.fromMap(Map<String, Object?> _json) {
  factory _AdaptiveToolbarData({
    String? context,
    required Map<String, Object?> groups,
  }) =>
      _AdaptiveToolbarData.fromMap({
        if (context != null) 'context': context,
        'groups': groups,
      });

  String? get context => _json['context'] as String?;
  Map<String, Object?> get groups => _json['groups'] as Map<String, Object?>;
}

final adaptiveToolbar = CatalogItem(
  name: 'AdaptiveToolbar',
  dataSchema: _schema,
  widgetBuilder: ({
    required data,
    required id,
    required buildChild,
    required dispatchEvent,
    required context,
    required dataContext,
  }) {
    final toolbarData = _AdaptiveToolbarData.fromMap(
      data as Map<String, Object?>,
    );

    // Extract which groups should be visible
    final groupsData = toolbarData.groups;
    final enabledGroups = <ToolbarGroup>{};

    for (final group in ToolbarGroup.values) {
      final key = group.name;
      final enabled = groupsData[key] as bool? ?? false;
      if (enabled) {
        enabledGroups.add(group);
      }
    }

    return _AdaptiveToolbarWidget(
      context: toolbarData.context,
      enabledGroups: enabledGroups,
      totalGroups: ToolbarGroup.values.length,
      onCommand: (cmd, payload) {
        // Dispatch command back to AI
        dispatchEvent(
          UserActionEvent(
            name: 'toolbarCommand',
            sourceComponentId: id,
            context: {
              'command': cmd.toString(),
              'payload': payload,
            },
          ),
        );
      },
    );
  },
);

class _AdaptiveToolbarWidget extends StatelessWidget {
  const _AdaptiveToolbarWidget({
    this.context,
    required this.enabledGroups,
    required this.totalGroups,
    required this.onCommand,
  });

  final String? context;
  final Set<ToolbarGroup> enabledGroups;
  final int totalGroups;
  final void Function(ToolbarCommand command, dynamic payload) onCommand;

  @override
  Widget build(BuildContext buildContext) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Context label
        if (context != null)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Context: $context',
                  style: Theme.of(buildContext).textTheme.titleMedium,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(buildContext).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${enabledGroups.length} / $totalGroups groups',
                    style: Theme.of(buildContext).textTheme.bodySmall?.copyWith(
                          color: Theme.of(buildContext).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ),
              ],
            ),
          ),

        const Divider(height: 1),

        // The actual toolbar (reuses existing SimpleToolbar)
        SimpleToolbar(
          groups: enabledGroups,
          onCommand: onCommand,
        ),

        const Divider(height: 1),
      ],
    );
  }
}
