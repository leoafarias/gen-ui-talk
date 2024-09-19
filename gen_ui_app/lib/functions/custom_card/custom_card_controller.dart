import 'package:flutter/widgets.dart';

import '../../ai/helpers.dart';
import '../../ai/helpers/hooks.dart';
import 'custom_card_dto.dart';

final customCardController = _CustomCardController();

class _CustomCardController extends ChangeNotifier {
  CustomCardDto? _customCard;
  _CustomCardController();

  Future<JSON> post(JSON parameters) {
    setCustomCard(CustomCardDto.fromMap(parameters));
    return Future.value(get());
  }

  Future<JSON> get() {
    return Future.value(_customCard?.toMap());
  }

  void setCustomCard(CustomCardDto customCard) {
    _customCard = customCard;
    notifyListeners();
  }

  void clearCustomCard() {
    _customCard = null;
    notifyListeners();
  }

  CustomCardDto? get cardDto => _customCard;
}

final useCustomCard = buildHookSelector(customCardController);
