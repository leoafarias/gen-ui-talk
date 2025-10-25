// Schema-based tool selection for ephemeral, intent-driven interfaces.
//
// This demonstrates how to define capabilities (what's possible) and let
// context + intent determine what actually appears.

/// Context that influences which tools should be shown
class ToolContext {
  /// What the user is trying to accomplish
  final String userIntent;

  /// Current selection or cursor state in the document
  final SelectionState? selectionState;

  /// User's skill level or preferences
  final UserProfile? userProfile;

  /// Time-based context (e.g., quick task vs detailed work)
  final WorkMode workMode;

  const ToolContext({
    required this.userIntent,
    this.selectionState,
    this.userProfile,
    this.workMode = WorkMode.standard,
  });
}

/// Represents what's currently selected in the document
class SelectionState {
  final bool hasSelection;
  final bool isFormatted;
  final String? selectionType; // 'text', 'image', 'table', etc.

  const SelectionState({
    required this.hasSelection,
    this.isFormatted = false,
    this.selectionType,
  });
}

/// User preferences and skill level
class UserProfile {
  final SkillLevel skillLevel;
  final Set<String> preferredTools;
  final Set<String> hiddenTools;

  const UserProfile({
    required this.skillLevel,
    this.preferredTools = const {},
    this.hiddenTools = const {},
  });
}

enum SkillLevel { beginner, intermediate, advanced }

enum WorkMode { quick, standard, detailed }

/// Schema defining available tools and their selection rules
class ToolSelectionSchema {
  /// All possible tool groups (the full capability set)
  final Map<String, ToolGroupDefinition> toolGroups;

  /// Rules for when each group should appear
  final List<SelectionRule> selectionRules;

  const ToolSelectionSchema({
    required this.toolGroups,
    required this.selectionRules,
  });

  /// Select which tools to show based on context
  Set<String> selectTools(ToolContext context) {
    final selectedGroups = <String>{};

    // Apply selection rules in order
    for (final rule in selectionRules) {
      if (rule.matches(context)) {
        selectedGroups.addAll(rule.groupsToShow);
      }
    }

    // Apply user profile filters
    if (context.userProfile != null) {
      final profile = context.userProfile!;

      // Remove hidden tools
      selectedGroups.removeAll(profile.hiddenTools);

      // Filter by skill level
      selectedGroups.removeWhere((group) {
        final def = toolGroups[group];
        return def != null && !def.isAvailableForSkillLevel(profile.skillLevel);
      });
    }

    return selectedGroups;
  }
}

/// Defines a tool group and when it's relevant
class ToolGroupDefinition {
  final String id;
  final String label;
  final String description;
  final SkillLevel minimumSkillLevel;
  final Set<String> keywords; // For intent matching

  const ToolGroupDefinition({
    required this.id,
    required this.label,
    required this.description,
    this.minimumSkillLevel = SkillLevel.beginner,
    this.keywords = const {},
  });

  bool isAvailableForSkillLevel(SkillLevel level) {
    return level.index >= minimumSkillLevel.index;
  }
}

/// Rule for when to show specific tool groups
class SelectionRule {
  final String name;
  final Set<String> groupsToShow;
  final bool Function(ToolContext) matches;

  const SelectionRule({
    required this.name,
    required this.groupsToShow,
    required this.matches,
  });
}

/// Example schema for a text editor toolbar
class TextEditorToolSchema {
  static final schema = ToolSelectionSchema(
    toolGroups: {
      'file': const ToolGroupDefinition(
        id: 'file',
        label: 'File',
        description: 'Search and print operations',
        keywords: {'search', 'find', 'print'},
      ),
      'history': const ToolGroupDefinition(
        id: 'history',
        label: 'History',
        description: 'Undo and redo',
        keywords: {'undo', 'redo', 'revert', 'history'},
      ),
      'marks': const ToolGroupDefinition(
        id: 'marks',
        label: 'Text Formatting',
        description: 'Bold, italic, underline, colors',
        keywords: {'bold', 'italic', 'underline', 'format', 'color', 'style'},
      ),
      'style': const ToolGroupDefinition(
        id: 'style',
        label: 'Styles',
        description: 'Paragraph and heading styles',
        keywords: {'heading', 'title', 'paragraph', 'style'},
        minimumSkillLevel: SkillLevel.intermediate,
      ),
      'font': const ToolGroupDefinition(
        id: 'font',
        label: 'Font',
        description: 'Font family and size',
        keywords: {'font', 'size', 'typeface'},
        minimumSkillLevel: SkillLevel.intermediate,
      ),
      'insert': const ToolGroupDefinition(
        id: 'insert',
        label: 'Insert',
        description: 'Insert links and images',
        keywords: {'link', 'image', 'insert', 'add', 'include'},
      ),
      'alignment': const ToolGroupDefinition(
        id: 'alignment',
        label: 'Alignment',
        description: 'Text alignment options',
        keywords: {'align', 'left', 'center', 'right', 'justify'},
      ),
      'lists': const ToolGroupDefinition(
        id: 'lists',
        label: 'Lists',
        description: 'Bullet, numbered, and check lists',
        keywords: {'list', 'bullet', 'number', 'checklist', 'todo'},
      ),
      'indent': const ToolGroupDefinition(
        id: 'indent',
        label: 'Indentation',
        description: 'Indentation and line spacing',
        keywords: {'indent', 'spacing', 'margin'},
        minimumSkillLevel: SkillLevel.intermediate,
      ),
      'zoom': const ToolGroupDefinition(
        id: 'zoom',
        label: 'Zoom',
        description: 'Zoom level control',
        keywords: {'zoom', 'scale', 'size'},
      ),
      'misc': const ToolGroupDefinition(
        id: 'misc',
        label: 'Miscellaneous',
        description: 'Other editing tools',
        keywords: {'clear', 'edit'},
        minimumSkillLevel: SkillLevel.advanced,
      ),
    },
    selectionRules: [
      // Basic writing: just need marks and alignment
      SelectionRule(
        name: 'basic_writing',
        groupsToShow: {'marks', 'alignment', 'history'},
        matches: (context) {
          final intent = context.userIntent.toLowerCase();
          return (intent.contains('write') || intent.contains('type')) &&
              !intent.contains('advanced') &&
              !intent.contains('format');
        },
      ),

      // Advanced writing: add styles, fonts, and more
      SelectionRule(
        name: 'advanced_writing',
        groupsToShow: {'marks', 'style', 'font', 'alignment', 'history'},
        matches: (context) {
          final intent = context.userIntent.toLowerCase();
          return (intent.contains('write') &&
                  (intent.contains('advanced') || intent.contains('format'))) ||
              intent.contains('document');
        },
      ),

      // Editing existing content
      SelectionRule(
        name: 'editing',
        groupsToShow: {'history', 'marks', 'alignment'},
        matches: (context) {
          final intent = context.userIntent.toLowerCase();
          return intent.contains('edit') || intent.contains('change');
        },
      ),

      // Inserting content
      SelectionRule(
        name: 'inserting',
        groupsToShow: {'insert', 'lists', 'history'},
        matches: (context) {
          final intent = context.userIntent.toLowerCase();
          return intent.contains('insert') ||
              intent.contains('add') ||
              intent.contains('link') ||
              intent.contains('image');
        },
      ),

      // Creating lists
      SelectionRule(
        name: 'lists',
        groupsToShow: {'lists', 'indent', 'history'},
        matches: (context) {
          final intent = context.userIntent.toLowerCase();
          return intent.contains('list') ||
              intent.contains('todo') ||
              intent.contains('checklist');
        },
      ),

      // Formatting/styling
      SelectionRule(
        name: 'formatting',
        groupsToShow: {'marks', 'style', 'font', 'alignment', 'indent'},
        matches: (context) {
          final intent = context.userIntent.toLowerCase();
          return intent.contains('format') || intent.contains('style');
        },
      ),

      // Reading/viewing mode - minimal tools
      SelectionRule(
        name: 'reading',
        groupsToShow: {'zoom', 'file'},
        matches: (context) {
          final intent = context.userIntent.toLowerCase();
          return intent.contains('read') ||
              intent.contains('view') ||
              context.workMode == WorkMode.quick;
        },
      ),
    ],
  );
}
