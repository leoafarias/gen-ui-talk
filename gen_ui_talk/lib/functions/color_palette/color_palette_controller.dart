import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../ai/helpers.dart';
import 'color_palette_dto.dart';

final _defaultPalette = ColorPaletteDto(
  name: 'Build your own color palette',
  font: ColorPaletteFontFamily.bungee,
  fontColor: const Color(
      0xFF00D486), // Vibrant green to stand out against the cool colors
  topLeftColor: const Color.fromARGB(255, 1, 157, 234),
  topRightColor: const Color(0xFF4527A0),
  bottomRightColor: const Color.fromARGB(255, 0, 169, 143),
  bottomLeftColor: const Color.fromARGB(255, 0, 212, 134),
);

class ColorPaletteController extends ChangeNotifier {
  ColorPaletteDto _colorPalette = _defaultPalette;
  ColorPaletteController();

  Future<JSON> post(JSON parameters) {
    setColorPalette(ColorPaletteDto.fromMap(parameters));
    return Future.value(get());
  }

  Future<JSON> get() {
    return Future.value(_colorPalette.toMap());
  }

  void update(JSON parameters) {
    try {
      final other = ColorPaletteDto.fromMap(parameters);
      final newColorPalette = _colorPalette.merge(other);
      _colorPalette = newColorPalette;
      notifyListeners();
    } catch (e) {
      print('Error updating color palette: $e');
    }
  }

  void setColorPalette(ColorPaletteDto colorPalette) {
    _colorPalette = colorPalette;
    notifyListeners();
  }

  ColorPaletteDto get colorPalette => _colorPalette;
}

ColorPaletteController useColorPaletteController() {
  final controller = useRef(ColorPaletteController());

  useEffect(() {
    return controller.value.dispose;
  }, []);

  return useListenable(controller.value);
}
