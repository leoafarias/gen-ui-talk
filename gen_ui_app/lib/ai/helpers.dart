import 'dart:convert';

import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  IconThemeData get iconTheme => theme.iconTheme;

  TextTheme get primaryTextTheme => theme.primaryTextTheme;
}

typedef JSON = Map<String, Object?>;

String prettyJson(JSON json) {
  return const JsonEncoder.withIndent('  ').convert(json);
}
