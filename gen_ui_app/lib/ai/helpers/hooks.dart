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

FocusNode useFocus(FocusNode? focusNode) {
  final focusNode0 = useFocusNode();

  return focusNode ?? focusNode0;
}

void useEffectOnce(VoidCallback callback) {
  useEffect(() {
    callback();
    return null;
  }, []);
}

// useEffect but after update
void useEffectUpdate(VoidCallback callback, [List<Object?> keys = const []]) {
  final mounted = useRef(false);

  return useEffect(() {
    if (mounted.value) {
      callback();
    } else {
      mounted.value = true;
    }
  }, keys);
}

R Function<R>(R Function(T)) buildHookSelector<T extends Listenable>(
    T listenable) {
  return <R>(R Function(T) selector) {
    return useListenableSelector(listenable, () => selector(listenable));
  };
}
