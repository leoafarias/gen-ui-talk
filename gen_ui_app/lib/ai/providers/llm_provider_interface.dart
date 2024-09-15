// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:mime/mime.dart';

import '../models/message.dart';

/// An abstract class representing an attachment in a chat message.
///
/// This class serves as a base for different types of attachments
/// (e.g., files, images, links) that can be included in a chat message.
sealed class Attachment {
  /// Creates an [Attachment] with the given name.
  ///
  /// [name] is the name of the attachment, which must not be null.
  const Attachment({required this.name});

  /// The name of the attachment.
  final String name;

  /// Determines the MIME type of a given file.
  ///
  /// This method attempts to determine the MIME type in the following order:
  /// 1. Use the file's reported MIME type if available.
  /// 2. Look up the MIME type based on the file path.
  /// 3. Default to 'application/octet-stream' if the MIME type cannot be
  ///    determined.
  ///
  /// [file] is the XFile object representing the file.
  ///
  /// Returns a String representing the MIME type of the file.
  static String _mimeType(XFile file) =>
      file.mimeType ?? lookupMimeType(file.path) ?? 'application/octet-stream';
}

/// Represents a file attachment in a chat message.
///
/// This class extends [Attachment] and provides specific properties and methods
/// for handling file attachments.
final class FileAttachment extends Attachment {
  /// The MIME type of the file attachment.
  final String mimeType;

  /// The binary content of the file attachment.
  final Uint8List bytes;

  /// Creates a [FileAttachment] with the given name, MIME type, and bytes.
  ///
  /// [name] is the name of the file attachment.
  /// [mimeType] is the MIME type of the file.
  /// [bytes] is the binary content of the file.
  FileAttachment({
    required super.name,
    required this.mimeType,
    required this.bytes,
  });

  /// Creates a [FileAttachment] from an [XFile].
  ///
  /// This factory method asynchronously reads the file content and determines
  /// its MIME type.
  ///
  /// [file] is the XFile object representing the file to be attached.
  ///
  /// Returns a Future that completes with a [FileAttachment] instance.
  static Future<FileAttachment> fromFile(XFile file) async => FileAttachment(
        name: file.name,
        mimeType: Attachment._mimeType(file),
        bytes: await file.readAsBytes(),
      );
}

/// Represents an image attachment in a chat message.
///
/// This class extends [Attachment] and provides specific properties and methods
/// for handling image attachments.
final class ImageAttachment extends Attachment {
  final String mimeType;

  final Uint8List bytes;

  ImageAttachment({
    required super.name,
    required this.mimeType,
    required this.bytes,
  });

  static Future<ImageAttachment> fromFile(XFile file) async {
    final mimeType = Attachment._mimeType(file);
    if (!mimeType.toLowerCase().startsWith('image/')) {
      throw Exception('Not an image: $mimeType');
    }

    return ImageAttachment(
      name: file.name,
      mimeType: mimeType,
      bytes: await file.readAsBytes(),
    );
  }
}

final class LinkAttachment extends Attachment {
  final Uri url;

  LinkAttachment({required super.name, required this.url});
}

abstract class LlmProvider {
  Stream<LlmMessagePart> sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments,
  });

  Future<LlmMessage> sendMessage(
    String prompt, {
    Iterable<Attachment> attachments,
  });
}
