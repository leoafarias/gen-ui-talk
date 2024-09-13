import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/message.dart';

abstract class MessageView<T extends Message> extends StatelessWidget {
  const MessageView(this.message, {super.key, this.onSelected});
  final T message;
  final void Function(bool)? onSelected;

  Future<void> onCopy(BuildContext context) async {
    onSelected?.call(false);
    await Clipboard.setData(ClipboardData(text: message.toClipboardText()));

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
