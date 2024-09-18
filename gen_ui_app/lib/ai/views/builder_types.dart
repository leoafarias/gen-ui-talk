import 'package:flutter/widgets.dart';

import '../controllers/chat_controller.dart';
import '../models/ai_response.dart';
import '../models/content.dart';

typedef UserContentViewBuilder = Widget? Function(UserContent content);

typedef ControllerWidgetBuilder = Widget Function(ChatController controller);

typedef WidgetElementViewBuilder<T extends AiElement> = Widget? Function(
  T element,
);
