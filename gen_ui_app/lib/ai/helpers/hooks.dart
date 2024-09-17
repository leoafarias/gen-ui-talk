import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void usePostFrameEffect(void Function() effect,
    [List<Object?> keys = const []]) {
  useEffect(() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      effect();
    });
  }, keys);
}
