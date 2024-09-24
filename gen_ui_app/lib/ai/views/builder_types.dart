import 'package:flutter/widgets.dart';

import '../controllers/chat_controller.dart';
import '../models/content.dart';
import '../models/llm_response.dart';

typedef UserContentViewBuilder = Widget? Function(UserContent content);

typedef ControllerWidgetBuilder = Widget Function(ChatController controller);

typedef WidgetElementViewBuilder<T extends LlmElement> = Widget? Function(
  T element,
);
