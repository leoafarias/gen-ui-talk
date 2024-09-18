import 'package:flutter/material.dart';

import '../../providers/ai_provider_interface.dart';
import '../molecules/attachment_view.dart';

class MessageBubbleStyle {
  final Color backgroundColor;

  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry padding;
  final Alignment alignment;
  final TextStyle textStyle;

  const MessageBubbleStyle({
    this.backgroundColor = const Color(0xFF303030),
    this.borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20),
    ),
    this.padding = const EdgeInsets.all(16),
    this.alignment = Alignment.topLeft,
    this.textStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
  });
}

class MessageBubble extends StatelessWidget {
  final String text;

  final List<Attachment> attachments;

  final MessageBubbleStyle style;

  const MessageBubble({
    super.key,
    required this.text,
    this.style = const MessageBubbleStyle(),
    this.attachments = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: style.alignment,
      child: Column(
        crossAxisAlignment: style.alignment == Alignment.topRight
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          // Attachments (if any)
          for (final attachment in attachments)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: SizedBox(
                height: 80,
                width: 200,
                child: AttachmentView(attachment),
              ),
            ),
          // Message bubble
          Container(
            decoration: BoxDecoration(
              color: style.backgroundColor,
              borderRadius: style.borderRadius,
            ),
            child: Padding(
              padding: style.padding,
              child: Text(
                text,
                style: style.textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
