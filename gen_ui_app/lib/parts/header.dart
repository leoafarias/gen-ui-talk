import 'package:flutter/material.dart';
import 'package:superdeck/superdeck.dart';

class HeaderPart extends StatelessWidget implements PreferredSizeWidget {
  const HeaderPart({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(context) {
    final slide = SlideConfiguration.of(context);
    final title = slide.options.title;

    final index = slide.slideIndex;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          title != null ? Text(title) : const SizedBox.shrink(),
          const SizedBox(width: 20),
          Text('${index + 1}'),
        ],
      ),
    );
  }
}
