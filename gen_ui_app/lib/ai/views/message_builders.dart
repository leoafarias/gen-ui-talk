import 'package:flutter/widgets.dart';

import '../models/message.dart';

typedef MessageBuilder = Widget Function(
  BuildContext context,
  Message response,
);

typedef FunctionResponseBuilder = Widget Function(
  LlmFunctionResponse response,
);
