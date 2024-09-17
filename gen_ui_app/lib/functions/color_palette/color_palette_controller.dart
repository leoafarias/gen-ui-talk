import 'package:flutter/widgets.dart';

import '../../ai/helpers.dart';
import 'color_palette_dto.dart';

final colorPaletteController = _ColorPaletteController();

class _ColorPaletteController extends ChangeNotifier {
  ColorPaletteDto? _colorPalette;
  _ColorPaletteController();

  Future<JSON> post(JSON parameters) {
    setColorPalette(ColorPaletteDto.fromMap(parameters));
    return Future.value(get());
  }

  Future<JSON> get() {
    return Future.value(_colorPalette?.toMap());
  }

  void setColorPalette(ColorPaletteDto colorPalette) {
    _colorPalette = colorPalette;
    notifyListeners();
  }

  void clearColorPalette() {
    _colorPalette = null;
    notifyListeners();
  }

  ColorPaletteDto? get colorPalette => _colorPalette;
}
