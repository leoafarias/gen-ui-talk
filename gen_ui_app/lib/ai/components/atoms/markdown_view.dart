import 'package:flutter/material.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown_selectionarea.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:re_highlight/languages/all.dart';
import 'package:re_highlight/re_highlight.dart';
import 'package:re_highlight/styles/all.dart';

import '../../helpers.dart';

class MarkdownView extends StatelessWidget {
  final String data;

  const MarkdownView({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: data,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
      extensionSet: md.ExtensionSet(
        md.ExtensionSet.gitHubFlavored.blockSyntaxes,
        <md.InlineSyntax>[
          md.EmojiSyntax(),
          ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
        ],
      ),
      builders: {
        'code': CodeElementBuilder(),
        'img': ImageElementBuilder(),
        'pre': PreElementBuilder(),
      },
      paddingBuilders: {'img': ZeroPaddingBuilder()},
    );
  }
}

final _highlight = Highlight()..registerLanguages(builtinLanguages);

class CodeElementBuilder extends MarkdownElementBuilder {
  CodeElementBuilder();

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    String? language;

    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      language = lg.substring(9);

      if (builtinAllLanguages[language] == null) {
        language = null;
      }
    }

    if (language == null) {
      return PreElementBuilder().visitElementAfter(element, preferredStyle);
    }

    final result =
        _highlight.highlight(code: element.textContent, language: language);

    final defaultStyle = GoogleFonts.jetBrainsMono();
    final theme = builtinAllThemes['github-dark']!;

    final renderer = TextSpanRenderer(defaultStyle, theme);

    result.render(renderer);
    return Builder(builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        color: context.colorScheme.surface,
        child: RichText(
          text: renderer.span ?? const TextSpan(),
        ),
      );
    });
  }
}

class PreElementBuilder extends MarkdownElementBuilder {
  PreElementBuilder();
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    return Builder(builder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: context.colorScheme.onSurface,
        ),
        child: Text(
          element.textContent,
          style: GoogleFonts.jetBrainsMono(
            fontSize: preferredStyle?.fontSize,
            fontWeight: preferredStyle?.fontWeight,
            color: context.colorScheme.surface,
          ),
        ),
      );
    });
  }
}

class ImageElementBuilder extends MarkdownElementBuilder {
  ImageElementBuilder();
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final uri = Uri.parse(element.attributes['src']!);

    return Builder(builder: (context) {
      return Image.network(
        uri.toString(),
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox(
            width: 24,
            height: 24,
            child: Icon(
              Icons.error,
              color: Colors.red,
            ),
          );
        },
      );
    });
  }
}

class ZeroPaddingBuilder extends MarkdownPaddingBuilder {
  @override
  EdgeInsets getPadding() {
    return EdgeInsets.zero;
  }
}
