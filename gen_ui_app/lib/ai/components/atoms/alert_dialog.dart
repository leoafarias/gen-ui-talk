import 'package:flutter/material.dart';

import '../../helpers.dart';
import '../../style.dart';
import 'code_highlighter.dart';

Future<void> showWidgetDetails(
  BuildContext context, {
  required String title,
  required JSON? contents,
}) {
  Widget? tryGenericResponse(JSON? contents) {
    if (contents == null) return null;
    try {
      return JsonSyntax(prettyJson(contents));
    } catch (e) {
      return null;
    }
  }

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.black,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 6,
          ),
          titlePadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          title: Text(
            title,
            style: kMonoFont.copyWith(fontSize: 20),
          ),
          content: tryGenericResponse(contents) ??
              JsonSyntax(
                contents.toString(),
              ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
            ),
          ],
        );
      });
}
