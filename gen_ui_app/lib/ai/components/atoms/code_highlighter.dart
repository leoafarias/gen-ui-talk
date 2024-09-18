import 'package:flutter/widgets.dart';

import '../../style.dart';
import 'markdown_view.dart';

class JsonSyntax extends StatelessWidget {
  const JsonSyntax(this.content, {super.key});

  final String content;

  @override
  Widget build(BuildContext context) {
    return buildCodeHighlighter(content, 'json',
        textStyle: chatTheme.textStyle);
  }
}
