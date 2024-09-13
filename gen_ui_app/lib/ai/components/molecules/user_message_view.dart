import 'package:flutter/material.dart';

import '../../models/message.dart';
import 'attachment_view.dart';
import 'base_message_view.dart';

class UserMessageView extends MessageView<UserMessage> {
  const UserMessageView(super.message, {super.key, super.onSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Flexible(flex: 2, child: SizedBox()),
        Flexible(
          flex: 6,
          child: Column(
            children: [
              ...[
                for (final attachment in message.attachments)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                        height: 80,
                        width: 200,
                        child: AttachmentView(attachment),
                      ),
                    ),
                  ),
              ],
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.zero,
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      message.prompt,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
