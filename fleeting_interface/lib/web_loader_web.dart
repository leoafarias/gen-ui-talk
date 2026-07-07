import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/widgets.dart';

void scheduleHideWebLoader() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!globalContext.has('hideFlutterLoader')) return;

    final hideFlutterLoader = globalContext['hideFlutterLoader'] as JSFunction;
    hideFlutterLoader.callAsFunction(globalContext);
  });
}
