// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../helpers.dart';
import '../../providers/ai_provider_interface.dart';

class AttachmentView extends StatelessWidget {
  const AttachmentView(this.attachment, {super.key});

  final Attachment attachment;

  @override
  Widget build(BuildContext context) => switch (attachment) {
        // For file attachments, use a custom file attachment view
        (FileAttachment a) => _FileAttachmentView(a),
        // For image attachments, display the image aligned to the right
        (ImageAttachment a) => Align(
            alignment: Alignment.centerRight,
            child: Image.memory(a.bytes),
          ),
        // Link attachments are not supported in this implementation
        (LinkAttachment _) => throw Exception('Link attachments not supported'),
      };
}

class _FileAttachmentView extends StatelessWidget {
  const _FileAttachmentView(this.attachment);
  final FileAttachment attachment;

  @override
  Widget build(BuildContext context) => Container(
        height: 80,
        padding: const EdgeInsets.all(8),
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 64,
              padding: const EdgeInsets.all(10),
              decoration: ShapeDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Icon(
                Icons.attach_file,
                size: 24,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            const Gap(8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    attachment.name,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    attachment.mimeType,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
