import 'package:flutter/material.dart';

import '../../models/content.dart';

abstract class ContentView<T extends ContentBase> extends StatelessWidget {
  const ContentView(this.content, {super.key, this.onSelected});
  final T content;
  final void Function(bool)? onSelected;
}
