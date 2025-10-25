// Simple tool definitions for intent-driven selection.
// The LLM uses these descriptions to decide what to show based on user intent.

/// A tool group with its description
class ToolGroupDefinition {
  final String id;
  final String label;
  final String description;

  const ToolGroupDefinition({
    required this.id,
    required this.label,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'description': description,
      };
}

/// All available toolbar groups and what they do
class ToolbarDefinitions {
  static const allGroups = [
    ToolGroupDefinition(
      id: 'file',
      label: 'File',
      description: 'Search and print operations',
    ),
    ToolGroupDefinition(
      id: 'history',
      label: 'History',
      description: 'Undo and redo changes',
    ),
    ToolGroupDefinition(
      id: 'zoom',
      label: 'Zoom',
      description: 'Zoom level control (50%, 75%, 100%, 125%, 150%, 200%)',
    ),
    ToolGroupDefinition(
      id: 'style',
      label: 'Text Style',
      description:
          'Paragraph styles: Normal text, Title, Subtitle, Heading 1/2/3',
    ),
    ToolGroupDefinition(
      id: 'font',
      label: 'Font',
      description:
          'Font family (Arial, Roboto, Georgia, Times New Roman, Courier New) and size (9-24pt)',
    ),
    ToolGroupDefinition(
      id: 'marks',
      label: 'Text Formatting',
      description: 'Bold, italic, underline, text color, and highlighting',
    ),
    ToolGroupDefinition(
      id: 'insert',
      label: 'Insert',
      description: 'Insert links and images into the document',
    ),
    ToolGroupDefinition(
      id: 'alignment',
      label: 'Alignment',
      description: 'Text alignment: left, center, right',
    ),
    ToolGroupDefinition(
      id: 'lists',
      label: 'Lists',
      description: 'Create bullet lists, numbered lists, and checklists',
    ),
    ToolGroupDefinition(
      id: 'indent',
      label: 'Indentation',
      description:
          'Increase/decrease indentation and adjust line spacing (1.0, 1.15, 1.5, 2.0)',
    ),
    ToolGroupDefinition(
      id: 'misc',
      label: 'Miscellaneous',
      description: 'Clear formatting, version history, and edit mode',
    ),
  ];

  /// Generate a system prompt for the LLM
  static String generateSystemPrompt() {
    final buffer = StringBuffer();
    buffer.writeln(
      'You help users by selecting relevant toolbar groups based on their intent.',
    );
    buffer.writeln();
    buffer.writeln('Available toolbar groups:');
    buffer.writeln();

    for (final group in allGroups) {
      buffer.writeln('- **${group.id}** (${group.label}): ${group.description}');
    }

    buffer.writeln();
    buffer.writeln('Guidelines:');
    buffer.writeln('- Select only the groups relevant to the user\'s intent');
    buffer.writeln('- Less is more - show only what\'s needed for the task');
    buffer.writeln(
      '- If unsure, prefer basic tools (marks, alignment, history)',
    );
    buffer.writeln('- For reading/viewing, show minimal tools (zoom, file)');
    buffer.writeln('- For writing, show formatting tools (marks, alignment)');
    buffer.writeln(
      '- For advanced formatting, add style and font options',
    );
    buffer.writeln();
    buffer.writeln('IMPORTANT:');
    buffer.writeln('- Provide a clear explanation of WHY you selected these specific tools');
    buffer.writeln('- Explain the reasoning behind including or excluding each group');
    buffer.writeln('- Connect your choices directly to the user\'s stated intent');
    buffer.writeln('- Make your thought process transparent and educational');

    return buffer.toString();
  }

  /// Convert to JSON for structured output
  static Map<String, dynamic> toJsonSchema() {
    return {
      'type': 'object',
      'properties': {
        'selectedToolGroups': {
          'type': 'array',
          'description': 'List of tool group IDs to show',
          'items': {
            'type': 'string',
            'enum': allGroups.map((g) => g.id).toList(),
          },
        },
        'explanation': {
          'type': 'string',
          'description': 'Clear, detailed explanation of WHY these specific tools were selected based on the user\'s intent. Explain the reasoning behind including or excluding groups and connect choices directly to what the user wants to accomplish.',
        },
      },
      'required': ['selectedToolGroups', 'explanation'],
    };
  }

  /// Get group definitions as a list for JSON
  static List<Map<String, dynamic>> toJson() {
    return allGroups.map((g) => g.toJson()).toList();
  }
}
