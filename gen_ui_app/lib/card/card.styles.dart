import 'package:mix/mix.dart';
import 'package:mutable_card/theme/brutalist/theme.dart';
import 'package:mutable_card/theme/elegant/theme.dart';
import 'package:mutable_card/theme/playful/theme.dart';
import 'package:mutable_card/theme/simple/theme.dart';

class CardVariants extends Variant {
  const CardVariants(super.name);

  static const brutalist = CardVariants('brutalist');
  static const simple = CardVariants('simple');
  static const playful = CardVariants('playful');
  static const elegant = CardVariants('elegant');

  static const values = [
    brutalist,
    simple,
    playful,
    elegant,
  ];
}

class PageStyles {
  final card = Style(
    CardVariants.simple(PageSimpleStyles().card()),
    CardVariants.playful(PagePlayfulStyles().card()),
    CardVariants.elegant(PageElegantStyles().card()),
    CardVariants.brutalist(PageBrutalistStyles().card()),
  );

  final image = Style(
    CardVariants.simple(PageSimpleStyles().image()),
    CardVariants.playful(PagePlayfulStyles().image()),
    CardVariants.elegant(PageElegantStyles().image()),
    CardVariants.brutalist(PageBrutalistStyles().image()),
  );

  final title = Style(
    CardVariants.simple(PageSimpleStyles().title()),
    CardVariants.playful(PagePlayfulStyles().title()),
    CardVariants.elegant(PageElegantStyles().title()),
    CardVariants.brutalist(PageBrutalistStyles().title()),
  );

  final subtitle = Style(
    CardVariants.simple(PageSimpleStyles().subtitle()),
    CardVariants.playful(PagePlayfulStyles().subtitle()),
    CardVariants.elegant(PageElegantStyles().subtitle()),
    CardVariants.brutalist(PageBrutalistStyles().subtitle()),
  );

  final segmentControl = Style(
    CardVariants.simple(PageSimpleStyles().segmentControl()),
    CardVariants.playful(PagePlayfulStyles().segmentControl()),
    CardVariants.elegant(PageElegantStyles().segmentControl()),
    CardVariants.brutalist(PageBrutalistStyles().segmentControl()),
  );

  final button = Style(
    CardVariants.simple(PageSimpleStyles().button()),
    CardVariants.playful(PagePlayfulStyles().button()),
    CardVariants.elegant(PageElegantStyles().button()),
    CardVariants.brutalist(PageBrutalistStyles().button()),
  );

  final checkbox = Style(
    CardVariants.simple(PageSimpleStyles().checkbox()),
    CardVariants.playful(PagePlayfulStyles().checkbox()),
    CardVariants.elegant(PageElegantStyles().checkbox()),
    CardVariants.brutalist(PageBrutalistStyles().checkbox()),
  );

  final footer = Style(
    CardVariants.simple(PageSimpleStyles().footer()),
    CardVariants.playful(PagePlayfulStyles().footer()),
    CardVariants.elegant(PageElegantStyles().footer()),
    CardVariants.brutalist(PageBrutalistStyles().footer()),
  );
}
